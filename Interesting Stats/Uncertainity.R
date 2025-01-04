library(ggplot2)

set.seed(123)
sample_size = seq(100,1000,100)
erik = rnorm(length(sample_size), mean = 45, sd = 3)
tchalla = rnorm(length(sample_size), mean = 55, sd = 3)
moe = 1.96 * (3/sqrt(sample_size))

# Makin a data frame
poll_data = data.frame(
  SampleSize = rep(sample_size, 2),
  PollMean = c(tchalla, erik),
  MarginOfError = rep(moe, 2),
  Party = rep(c("T'Challa Party (TP)", "Erik's Unity Party (EUP)"), each = length(sample_size)),
  LowerBound = c(tchalla - moe, erik - moe),
  UpperBound = c(tchalla + moe, erik + moe)
)

# Plotting
ggplot(poll_data, aes(x = SampleSize, y = PollMean, color = Party, fill = Party)) +
  geom_line(size = 1.2) +
  geom_ribbon(aes(ymin = LowerBound, ymax = UpperBound), alpha = 0.2) +
  scale_color_manual(values = c("T'Challa Party (TP)" = "blue", "Erik's Unity Party (EUP)" = "darkorange")) +
  scale_fill_manual(values = c("T'Challa Party (TP)" = "blue", "Erik's Unity Party (EUP)" = "darkorange")) +
  labs(
    title = "Wakanda Election Polls: Predicting the Victory",
    subtitle = "T'Challa Party (TP) leads with higher poll percentages",
    x = "Sample Size",
    y = "Poll Percentage (%)",
    caption = "Data simulated for illustration purposes"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, size = 12)
  ) +
  geom_hline(yintercept = 50, linetype = "dashed", color = "gray50", size = 0.8) +
  annotate("text", x = 900, y = 51, label = "Majority Threshold", color = "gray50", vjust = -1)
