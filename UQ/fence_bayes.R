library(ggplot2)

prior = c(attack = 0.4, parry = 0.3, retreat = 0.3)


# Define likelihoods based on observed behavior (hypothetical data)
likelihood = matrix(c(
  0.7, 0.2, 0.1,  # If opponent previously attacked
  0.3, 0.5, 0.2,  # If opponent previously parried
  0.2, 0.3, 0.5   # If opponent previously retreated
), nrow = 3, byrow = TRUE, 
dimnames = list(c("Prev_Attack", "Prev_Parry", "Prev_Retreat"), c("Attack", "Parry", "Retreat")))

obs_action = "Prev_Attack"

# Compute posterior probability using Bayes' Theorem
posterior = (likelihood[obs_action, ] * prior) / sum(likelihood[obs_action, ] * prior)

# Print results
print(posterior)

# Visualization
posterior_df = data.frame(Move = names(posterior), Probability = posterior)
ggplot(posterior_df, aes(x = Move, y = Probability, fill = Move)) +
  geom_bar(stat = "identity") +
  labs(title = "Bayesian Prediction of Opponent's Next Move", y = "Probability") +
  theme_minimal()

library(fmsb)

# Prepare data for radar chart
radar_df <- rbind(rep(1, 3), rep(0, 3), posterior)

# Create radar chart
radarchart(radar_df, title = "Radar Chart of Posterior Probabilities", pcol = rainbow(3), plwd = 2, plty = 1)

library(ggplot2)

# Create a bubble plot
ggplot(posterior_df, aes(x = Move, y = Probability, size = Probability, color = Move)) +
  geom_point(alpha = 0.7) +
  scale_size(range = c(5, 15)) +
  labs(title = "Bubble Plot of Posterior Probabilities", y = "Probability") +
  theme_minimal()
