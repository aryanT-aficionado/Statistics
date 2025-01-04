library(ggplot2)

set.seed(123) # For reproducibility

# Weather conditions and probabilities
weather = c("Sunny", "Rainy", "Snowy", "Cloudy")
weather_probs = c(0.5, 0.1, 0.2, 0.2) # Adjust probabilities as needed
n = 200

# Generate random weather conditions
weather_data = sample(weather, n, replace = TRUE, prob = weather_probs)

# Generate mood levels (scale: 0–100, higher is happier)
mood = ifelse(weather_data == "Sunny", 
               rnorm(n, mean = 80, sd = 10),  # Happy on sunny days
               ifelse(weather_data == "Snowy", 
                      rnorm(n, mean = 30, sd = 15),  # Low mood in snow
                      ifelse(weather_data == "Rainy", 
                             rnorm(n, mean = 50, sd = 10),  # Moderate mood in rain
                             rnorm(n, mean = 60, sd = 10)))) # Slightly better mood in cloudy weather


# Generate decisions (1 = Go Shopping, 0 = Stay Home)
shop_decision = ifelse(mood > 70, 0.9, # High mood = likely to shop
                       ifelse(mood > 50, 0.6, .3)) # Moderate or low mood reduces chances


# Generate decisions (1 = Proceed, 0 = Stop)
decisions = rbinom(n, size = 1, prob = shop_decision)

# Create a data frame
data = data.frame(Weather = weather_data, Mood = mood, Decision = decisions)

# Fit a logistic regression model
model = glm(Decision ~ Weather + Mood, data = data, family = binomial)

# Summarize the model
summary(model)

# Predict probabilities
data$Predicted_Prob = predict(model, type = "response")

# Bar plot of decisions by weather
ggplot(data, aes(x = Weather, fill = factor(Decision))) +
  geom_bar(position = "dodge") +
  labs(title = "Shopping Decisions by Weather Condition",
       x = "Weather", y = "Count",
       fill = "Shopping (1 = Go, 0 = Stay)") +
  theme_minimal()

# Scatter plot of mood vs. predicted probability
ggplot(data, aes(x = Mood, y = Predicted_Prob, color = Weather)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "glm", method.args = list(family = binomial), se = FALSE) +
  labs(title = "Will My Mood Lead Me to Go Shopping?",
       x = "Mood Level", y = "Predicted Probability",
       color = "Weather") +
  theme_minimal()
