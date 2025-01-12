# Load necessary libraries
library(ggplot2)
library(dplyr)

# Set seed for reproducibility
set.seed(2025)

# Simulate a fictional election scenario
population_size = 1e6
candidate_support = 0.55  # True proportion of votes for Candidate A

# Simulate the population, normally
population = rbinom(population_size, 1, candidate_support)

# Polling: Randomly sample voters
sample_size = 5000
sample = sample(population, sample_size)

# Calculate sample proportion
sample_proportion = mean(sample)

# Confidence Interval Calculation
z_score = 1.96  # For 95% confidence
margin_of_error = z_score * sqrt((
  sample_proportion * (
    1 - sample_proportion)) / sample_size)

confidence_interval = c(sample_proportion - margin_of_error, sample_proportion + margin_of_error)

# Visualize the Results
df = data.frame(
  x = seq(0, 1, length.out = 1000),
  y = dnorm(seq(0, 1, length.out = 1000), mean = sample_proportion, 
            sd = sqrt((sample_proportion * (1 - sample_proportion)) / sample_size))
)

# Add confidence interval shading
df <- df %>%
  mutate(is_in_ci = x >= confidence_interval[1] & x <= confidence_interval[2])

# Plot
# Sample Proportion: 0.56 | 95% Confidence Interval:[0.55, 0.57]
ggplot(df, aes(x, y)) +
  geom_line(color = "#2E86C1", size = 1.5) +  # Normal curve
  geom_ribbon(data = subset(df, is_in_ci),
              aes(ymin = 0, ymax = y),
              fill = "#AED6F1", alpha = 0.6) +  # Confidence interval shading
  geom_vline(xintercept = sample_proportion, linetype = "dashed", color = "#C0392B", size = 1) +
  annotate("text", x = sample_proportion, y = max(df$y), label = "Sample Proportion", 
           hjust = -0.2, color = "#C0392B", size = 5) +
  labs(
    title = "Visualizing Exit Poll Predictions",
    x = "Proportion of Votes for Candidate A",
    y = "Density",
    caption = "The shaded region represents the 95% confidence interval for the sample proportion."
  ) +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "#5D6D7E"))

