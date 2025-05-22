set.seed(42)

# Generate synthetic dataset
n <- 200  # Number of observations
conversation_minutes <- runif(n, 5, 120)  # Random minutes (5 to 120)
shared_interests <- sample(0:10, n, replace = TRUE)  # Common interests (0-10)
gift_quality <- runif(n, 1, 10)  # Gift rating (1-10)
noise <- rnorm(n, 0, 0.3)  # Adding some noise

# Define probability of success using a logistic function
linear_combination <- 0.02 * conversation_minutes + 
  0.1 * shared_interests + 
  0.15 * gift_quality + noise
success_prob <- exp(linear_combination) / (1 + exp(linear_combination))
success <- rbinom(n, 1, success_prob)  # Binary outcome

# Fit logistic regression model
model <- glm(success ~ conversation_minutes + shared_interests + gift_quality, 
             family = binomial)

# Generate predictions for visualization
predicted_prob <- predict(model, type = "response")

# Base R plot
plot(conversation_minutes, predicted_prob, col = ifelse(success == 1, "red", "pink"),
     pch = 16, xlab = "Conversation Duration (minutes)", ylab = "Predicted Probability",
     main = "Love in Numbers: Predicting a Successful Date")
legend("topleft", legend = c("Success", "Failure"), col = c("red", "pink"), pch = 16)
