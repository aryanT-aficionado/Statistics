# Libraries
library(ggplot2)
library(dplyr)

# Parameters
n <- c(50, 100, 250, 500, 800, 1000) # Different numbers of trials
alive <- 0.53  # Probability of "alive" state
dead <- 1 - alive

# Initialize an empty data frame for storing results
all_data <- data.frame()

# Loop through each number of trials
for (n_trials in n) {
  # Simulate Bernoulli trials
  alive_trials <- rbinom(n_trials, size = 1, prob = alive)
  dead_trials <- rbinom(n_trials, size = 1, prob = dead)
  
  # Compute means for each state
  alive_mean <- mean(alive_trials)
  dead_mean <- mean(dead_trials)
  
  # Approximate distributions using CLT
  x <- seq(0, 1, by = 0.01)
  alive_prob <- dnorm(x, mean = alive_mean, sd = sqrt(alive * dead / n_trials))
  dead_prob <- dnorm(x, mean = dead_mean, sd = sqrt(alive * dead / n_trials))
  
  # Combine data for this n_trials
  data <- data.frame(
    x = rep(x, 2),
    Probability = c(alive_prob, dead_prob),
    State = rep(c("Alive", "Dead"), each = length(x)),
    Trials = rep(n_trials, length(x) * 2)
  )
  
  # Add to the main data frame
  all_data <- bind_rows(all_data, data)
}

# Plot the combined data
ggplot(all_data, aes(x = x, y = Probability, color = State)) +
  geom_line(size = 1) +
  facet_wrap(~ Trials, ncol = 2, scales = "free_y") +
  labs(title = "Schrodinger's Cat Theory",
       subtitle = "Visualization with varying trials",
       x = "State Continuum", y = "Probability Density") +
  theme_minimal() +
  theme(legend.position = "bottom")
