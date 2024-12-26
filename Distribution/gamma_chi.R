# Loading necessary library
library(ggplot2)

# Define parameters for the gamma distribution
shape_values <- c(1, 2, 5, 10, 15, 20)  # Corresponds to degrees of freedom 2, 4, 10
rate <- 0.5  # Rate parameter for gamma distribution

# Create a data frame for plotting
x_vals <- seq(0, 60, length.out = 500)  # Range of x values
data <- data.frame()

# Generate gamma distributions corresponding to chi-squared distributions
for (shape in shape_values) {
  data <- rbind(data, 
                data.frame(x = x_vals,
                           y = dgamma(x_vals, shape = shape, rate = rate),
                           df = paste0("df = ", shape * 2)))
}

# Plotting the gamma distributions
ggplot(data, aes(x = x, y = y, color = df)) +
  geom_line(size = 1) +
  labs(title = "Gamma Distribution as Chi-Squared Distribution",
       subtitle = "Transforming Gamma(k = ν/2, θ = 1/2) to Chi-Squared(ν)",
       x = "x",
       y = "Density") +
  theme_minimal() +
  theme(legend.title = element_blank())
