# Cupid's Base R Romance Plot
set.seed(2023)

# Generate data and model (same as before)
valentine_data <- data.frame(
  chocolate = rbinom(100, 5, 0.6),
  shared_interests = runif(100, 0, 10),
  conversation_time = runif(100, 1, 20)
)

valentine_data$loves_me <- rbinom(100, 1, plogis(
  -2 + 0.7*valentine_data$chocolate +
    0.1*(valentine_data$shared_interests^2) + 
    0.004*(valentine_data$conversation_time^3)
))

love_model <- glm(loves_me ~ chocolate + I(shared_interests^2) + I(conversation_time^3),
                  data = valentine_data, family = binomial())

# Generate predictions
test_data <- data.frame(
  conversation_time = seq(1, 20, length.out = 100),
  chocolate = median(valentine_data$chocolate),
  shared_interests = median(valentine_data$shared_interests)
)

pred <- predict(love_model, test_data, se.fit = TRUE)
test_data$prob <- plogis(pred$fit)
upper <- plogis(pred$fit + 1.96*pred$se.fit)
lower <- plogis(pred$fit - 1.96*pred$se.fit)

# Create plot
par(bg = "#FFF0F5", col.main = "#CC0066", font.main = 2)  # Valentine background
plot(test_data$conversation_time, test_data$prob, type = "n",
     ylim = c(0, 1), xlab = "Hours of Deep Conversation", ylab = "",
     main = "Love Probability vs. Quality Time")

# Add confidence ribbon
polygon(c(test_data$conversation_time, rev(test_data$conversation_time)),
        c(upper, rev(lower)), col = "#FF69B440", border = NA)

# Add main line
lines(test_data$conversation_time, test_data$prob, 
      col = "#FF1493", lwd = 3)

# Add labels and grid
title(ylab = "Probability of Mutual Love", line = 2.3)
grid(col = "#FFD9E6", lty = 1)

# Add legend
legend("topleft", legend = "95% Confidence Band",
       fill = "#FF69B440", border = NA, bty = "n")

