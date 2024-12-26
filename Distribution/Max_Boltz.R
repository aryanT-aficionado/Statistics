# Load necessary library
library(ggplot2)

# Define constants
k_B <- 1.38e-23   # Boltzmann constant (J/K)
m <- 4.65e-26     # Mass of a single nitrogen molecule (kg)

# Define the Maxwell-Boltzmann distribution function
maxwell_boltzmann <- function(v, T) {
  (4 * pi * ((m / (2 * pi * k_B * T))^(3 / 2)) * 
     (v^2) * exp(-m * v^2 / (2 * k_B * T)))
}

# Generate speed values
v <- seq(0, 2000, length.out = 1000) # Speed range in m/s

# Define temperatures to visualize
# Define temperatures dynamically (100 to 1000 K with step 100)
temperatures <- seq(100, 1000, by = 75) # Temperatures in Kelvin

# Create a data frame for plotting
data <- data.frame(
  Speed = rep(v, times = length(temperatures)),
  Probability = unlist(lapply(temperatures, function(T) maxwell_boltzmann(v, T))),
  Temperature = factor(rep(temperatures, each = length(v)))
)

# Plot the Maxwell-Boltzmann distribution
ggplot(data, aes(x = Speed, y = Probability, color = Temperature)) +
  geom_line(size = 1) +
  labs(
    title = "Maxwell-Boltzmann Distribution",
    x = "Speed (m/s)",
    y = "Probability Density",
    color = "Temperature (K)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.position = "bottom"
  )
