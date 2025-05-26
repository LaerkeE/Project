import json
import glob
import os
import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import interp1d

def load_likelihood_curves(json_path):
    with open(json_path, 'r') as f:
        data = json.load(f)
    like_x = np.array([x for x, _ in data['likelihood']])
    like_y = np.array([y for _, y in data['likelihood']])
    return like_x, like_y

def compute_average_likelihood(like_x, like_y, n_points=100):
    x_min = np.min(like_x)
    x_max = np.max(like_x)
    plot_x = np.linspace(x_min, x_max, n_points)

    interpolated = []
    for i in range(like_x.shape[0]):
        interp_func = interp1d(like_x[i], like_y[i], bounds_error=False, fill_value=np.nan)
        y_interp = interp_func(plot_x)
        y_interp -= np.nanmin(y_interp)  # Normalize
        interpolated.append(y_interp)

    interpolated = np.array(interpolated)
    valid_counts = np.sum(np.isfinite(interpolated), axis=0)
    mean_y = np.nanmean(interpolated, axis=0)
    mean_y[valid_counts < 3] = np.nan  
    return plot_x / 1000, mean_y

def plot_multiple_models(fit_files, labels, title, output_file):
    plt.figure(figsize=(8, 5))
    cm = plt.cm.get_cmap('tab10')
    
    for i, file in enumerate(fit_files):
        like_x, like_y = load_likelihood_curves(file)
        if like_x is None:
            continue
        x_plot, y_mean = compute_average_likelihood(like_x, like_y)
        plt.plot(x_plot, y_mean, label=labels[i], color=cm(i % 10))

    plt.xlabel('Shared variant number [k]')
    plt.ylabel('-log(L) + const')
    plt.title(title)
    plt.legend()
    plt.tight_layout()
    plt.savefig(output_file)
    plt.show()

fit_json_files = sorted(glob.glob("PGC_AN_2019_qc_noMHC_vs_ADHD_2022_noMHC_it*.fit.json"))
labels = [os.path.basename(f).replace(".fit.json", "") for f in fit_json_files]

plot_multiple_models(
    fit_files=fit_json_files,
    labels=labels,
    title="Log-likelihood (mean) across 5 models",
    output_file="loglikelihood_models.png"
)


