# Cupid's Polynomial Romance Predictor
library(ggplot2)

set.seed(2023) # For consistent love results

# Generate synthetic dating data
valentine_data <- data.frame(
  chocolate = rbinom(100, 5, 0.6),        # Chocolates given (0-5)
  shared_interests = runif(100, 0, 10),   # Compatibility score (0-10)
  conversation_time = runif(100, 1, 20)   # Hours spent talking
)

# Create love outcomes using modified equation
valentine_data$loves_me <- rbinom(100, 1, plogis(
  -2 + 0.7*valentine_data$chocolate +
    0.1*(valentine_data$shared_interests^2) + 
    0.004*(valentine_data$conversation_time^3)
))

# Build love prediction model with polynomial terms
love_model <- glm(loves_me ~ chocolate + 
                    I(shared_interests^2) + 
                    I(conversation_time^3),
                  data = valentine_data,
                  family = binomial())

# Create prediction dataset
test_data <- data.frame(
  conversation_time = seq(1, 20, length.out = 100),
  chocolate = median(valentine_data$chocolate),
  shared_interests = median(valentine_data$shared_interests)
)

# Generate predictions
pred <- predict(love_model, test_data, se.fit = TRUE)
test_data$prob <- plogis(pred$fit)
test_data$lower <- plogis(pred$fit - 1.96*pred$se.fit)
test_data$upper <- plogis(pred$fit + 1.96*pred$se.fit)

# Create Valentine's plot
ggplot(test_data, aes(conversation_time, prob)) +
  geom_ribbon(aes(ymin = lower, ymax = upper), 
              fill = "#FF69B4", alpha = 0.2) +
  geom_line(color = "#FF1493", linewidth = 1.5) +
  labs(
    title = "Love Probability vs. Quality Time",
    subtitle = "Chocolate (linear) Shared Interests Conversation Time",
    x = "Hours of Deep Conversation", 
    y = "Probability of Mutual Love",
    caption = "Valentine's Uncertainty Quantification with Polynomial Romance Model"
  ) +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "#FFF0F5"),
    plot.title = element_text(color = "#CC0066", face = "bold"),
    panel.grid = element_line(color = "#FFD9E6")
  )


