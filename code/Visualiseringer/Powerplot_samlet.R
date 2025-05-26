# Set the file path
path <- "/home/User/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/visualization/"

file_names <- c("ADHD.test.power.csv", "AN.test.power.csv", "ASD.test.power.csv", "BMI.test.power.csv", "EA.test.power.csv", "THIN.test.power.csv", "HEIGHT.test.power.csv")

# Load the CSV files
data_list <- lapply(file_names, function(file) {
  read.csv(paste0(path, file), sep = "\t", header = TRUE, dec = ".")
})

data <- do.call(rbind, data_list)

# Define a function to find the nearest point
find_nearest_point <- function(target, vec) {
  nearest_index <- which.min(abs(vec - target))
  return(vec[nearest_index])
}

neff_adhd <- 4 / ((1/38614) + (1/186843))
neff_an <- 4 / ((1/16992) + (1/55525))
neff_asd <- 4 / ((1/18382) + (1/27969))
n_bmi <- 693529
n_ea <- 765283
neff_thin <- 4 / ((1/1622) + (1/10433))
n_height <- 1597374 

# Define current N values
current_n <- data.frame(
  trait = c("PGC_ADHD_2022.test.json", "PGC_AN_2019.test.json", "PGC_ASD_2017.test.json", "PGC_BMI.test.json", "EA_2022.test.json", "PGC_THIN.test.json","PGC_HEIGHT.test.json"),
  nvec = c(neff_adhd, neff_an, neff_asd, n_bmi, n_ea, neff_thin, n_height),
  svec = NA  # Initialize with NA
)

# Find the nearest point in 'data' for each current N
for (i in 1:nrow(current_n)) {
  trait <- current_n$trait[i]
  n <- current_n$nvec[i]
  index <- which(data$trait == trait)
  closest_n <- find_nearest_point(n, data$nvec[index])
  current_n$nvec[i] <- closest_n
  current_n$svec[i] <- data$svec[index[data$nvec[index] == closest_n]] 
}  
print(current_n)

# Create the plot using ggplot2
library(ggplot2)
ggplot(data, aes(x = nvec, y = svec, color = trait)) +
  geom_line() +  # Draw lines
  geom_point(data = current_n, aes(x = nvec, y = svec), size = 4, shape = 19) +  # Add points for current N
  geom_text(data = current_n, aes(x = nvec, y = svec, label = round(svec, 2)), 
            vjust = -0.5, size = 4, color = "black") +  # Add y-coordinates as labels
  labs(x = "",  # Label for x-axis
       y = "Estimated Variance Explained (%) by genome-wide SNPs",  # Label for y-axis
       color = "Current Neff"  # Label for color legend
  ) +
  scale_color_manual(values = c("PGC_ADHD_2022.test.json" = "darkblue", "PGC_AN_2019.test.json" = "darkorange", "PGC_ASD_2017.test.json" = "darkgreen", "PGC_BMI.test.json" = "darkred", "EA_2022.test.json" = "purple", "PGC_THIN.test.json" = "magenta", "PGC_HEIGHT.test.json" ="yellow2"),
                     labels = c("PGC_ADHD_2022.test.json" = "ADHD", "PGC_AN_2019.test.json" = "Anoreksi", "PGC_ASD_2017.test.json" = "Autisme", "PGC_BMI.test.json" = "BMI", "EA_2022.test.json" = "Educational Attainment", "PGC_THIN.test.json" = "Persistent Thinness","PGC_HEIGHT.test.json" = "Height")) +  
  scale_x_continuous(trans = "log10", breaks = c(0,10000,100000,1000000,10000000,100000000), labels = c("0","10k","100k","1M","10M","100M")) + # Log-transform x-axis with original nvec values as labels
  theme_classic() +  # Apply minimal theme
  theme(  # Adjust theme settings
    text = element_text(size = 16),  # Set text size
    axis.title = element_text(size = 16),  # Set axis title size
    legend.title = element_text(size = 20),  # Set legend title size
    legend.text = element_text(size = 16),  # Set legend text size
    aspect.ratio = 1,  # Make the plot square
    legend.position = c(0.02, 0.95),  # Position legend in the upper left corner
    legend.justification = c(0, 1),  # Justify legend to the left and top
    legend.box = "horizontal"  # Make legend box horizontal (square)
  )

  
