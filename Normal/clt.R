# Load necessary libraries
library(ggplot2)
library(dplyr)

# Generate a non-normal population (Exponential Distribution)
set.seed(123)
population = rpois(10000, lambda = 2)  # Exponential distribution

# Function to simulate sampling and calculate means
simulate_clt = function(population, sample_size, num_samples) {
  sample_means = replicate(num_samples, mean(sample(population, sample_size)))
  data.frame(mean = sample_means)
}

# Parameters for simulation
sample_size = 30       # Size of each sample
num_samples = 1000     # Number of samples to draw

# Simulate sample means
sample_means_data = simulate_clt(population, sample_size, num_samples)

# Plot the original population and sample means
ggplot() +
  # Population distribution
  geom_density(data = data.frame(value = population), aes(x = value, fill = "Population Distribution"), 
               alpha = 0.4) +
  geom_density(data = sample_means_data, aes(x = mean, fill = "Sample Means"), 
               alpha = 0.6) +
  labs(title = "Central Limit Theorem in Action",
       subtitle = "Non-Normality to Normality",
       x = "Value", 
       y = "Density",
       fill = "Distribution") +  # Legend title
  theme_minimal() +
  theme(legend.position = c(0.8, 0.8),    # Position inside graph (x, y: 0 to 1)
        legend.background = element_rect(fill = "white", color = "black"),
        legend.key.size = unit(0.5, "cm")) +  # Adjust legend size
  xlim(0, 10)
