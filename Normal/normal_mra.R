# Load necessary libraries
library(ggplot2)

# Create some example data
set.seed(123)
x <- rnorm(100)
y <- 2 + 3 * x + rnorm(100)

# Fit a linear model
model <- lm(y ~ x)

# Create a data frame for predictions
new_data <- data.frame(x = seq(min(x), max(x), length.out = 100))
predictions <- predict(model, newdata = new_data, interval = "confidence")
predictions_pred <- predict(model, newdata = new_data, interval = "prediction")

# Combine predictions with new data
new_data <- cbind(new_data, predictions)

# Plot the results
ggplot(data = new_data, aes(x = x)) +
  geom_point(aes(y = y), data = data.frame(x, y), alpha = 0.5) +
  geom_line(aes(y = fit), color = "blue") +
  geom_ribbon(aes(ymin = lwr, ymax = upr), alpha = 0.2, fill = "blue") +
  geom_ribbon(aes(ymin = predictions_pred[,2], ymax = predictions_pred[,3]), alpha = 0.2, fill = "red") +
  labs(title = "Linear Regression with Confidence and Prediction Intervals",
       y = "Response Variable (y)",
       x = "Predictor Variable (x)") +
  theme_minimal()


# Choose a specific point for visualization
specific_x <- 0  # Change this to any x value of interest
predicted_y <- predict(model, newdata = data.frame(x = specific_x))

# Calculate the standard deviation of residuals
residuals <- model$residuals
sigma <- sd(residuals)

# Create a normal distribution curve centered at the predicted value
x_norm <- seq(predicted_y - 3*sigma, predicted_y + 3*sigma, length.out = 100)
y_norm <- dnorm(x_norm, mean = predicted_y, sd = sigma)

# Create a plot
ggplot() +
  geom_point(aes(x = x, y = y), alpha = 0.5) +  # Original data points
  geom_line(aes(x = new_data$x, y = predictions), color = "blue") +  # Regression line
  geom_line(aes(x = x_norm, y = y_norm * max(y) / max(y_norm) + predicted_y), color = "red") +  # Normal distribution curve
  geom_point(aes(x = specific_x, y = predicted_y), color = "green", size = 3) +  # Specific point
  labs(title = "Normal Distribution of Residuals Around a Predicted Value",
       x = "Predictor Variable (x)",
       y = "Response Variable (y)") +
  theme_minimal()
