# Load necessary libraries
library(ggplot2)
library(dplyr)

# Set seed for reproducibility
set.seed(123)

# Generate Exponential population distribution data
popu = rexp(10000)  

# Function to calculate sample means for CLT demonstration
clt = function(sample_size, n) {
  replicate(n, mean(sample(popu, size = sample_size, replace = TRUE)))
}

# Define sample sizes and generate CLT data
sample_sizes = c(2, 5, 8, 10, 30, 50)
clt_data = data.frame(
  sample = rep(sample_sizes, each = 1000),
  sample_mean = unlist(lapply(sample_sizes, clt, n = 1000))
)

# Define custom colors for sample sizes
colors = c(
  "2" = "#F91EB0",   # Red
  "5" = "#ED7B00",   # Orange
  "8" = "#F5DBCB",   # Yellow
  "10" = "#33FF57",  # Green
  "30" = "#3357FF",  # Blue
  "50" = "#FFD700"   # Gold
)

# Plot the CLT demonstration
ggplot(clt_data, aes(x = sample_mean, fill = as.factor(sample))) +
  geom_density(alpha = 0.6) +
  scale_fill_manual(values = colors, name = "Sample Size") +
  labs(
    title = "Central Limit Theorem",
    subtitle = "Sample mean approaches normality as n increases",
    x = "Sample Mean",
    y = "Density",
    fill = "Sample Size"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, size = 12),
    legend.position = "right"
  )
