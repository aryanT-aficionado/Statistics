# Load necessary library
library(ggplot2)

# Generate random data from normal distributions with different standard deviations
set.seed(123)
# Normal Distribution with standard deviation 1
data_sd1 <- rnorm(1000, mean = -2, sd = 1)  # Standard deviation 1
# Normal Distribution with standard deviation 0.5
data_sd2 <- rnorm(1000, mean = 0, sd = 0.5)  
# Normal Distribution with standard deviation 2.0
data_sd3 <- rnorm(1000, mean = 2, sd = 2)  

# Combine into a data frame
df <- data.frame(
  values = c(data_sd1, data_sd2, data_sd3),
  group = factor(c(rep("SD = 1", 1000), rep("SD = 0.5", 1000), rep("SD = 2", 1000)))
)

# Plot the density curves for each standard deviation
ggplot(df, aes(x = values, color = group, fill = group)) +
  geom_density(alpha = 0.3, size = 1.2) +
  labs(
    title = "Effect of Variance on the Normal Distribution",
    x = "Values",
    y = "Density",
    color = "Standard Deviation",
    fill = "Standard Deviation"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    legend.position = "top"
  ) +
  scale_color_manual(values = c("blue", "pink", "red")) +
  scale_fill_manual(values = c("blue", "pink", "red"))

