library(ggplot2)

# Simulate data for position and momentum uncertainty
set.seed(123)

data = data.frame(
  pos_uncertain = c(rnorm(1000, sd = 0.5), rnorm(1000, sd = 1), rnorm(1000, sd = 2)),
  mom_uncertain = c(rnorm(1000, sd = 2), rnorm(1000, sd = 1), rnorm(1000, sd = 0.5)),
  group = factor(rep(c("High Δx, Low Δp", "Equal Δx and Δp", "Low Δx, High Δp"), each = 1000))
)

ggplot(data, aes(x = pos_uncertain, y = mom_uncertain, color = group, fill = group))+
  geom_density_2d(alpha = 0.7)+
  scale_fill_manual(values = c("#FF5733", "#33FF57", "#3357FF"))+
  scale_color_manual(values = c("#FF5733", "#33FF57", "#3357FF"))+
  labs(
    title = "Heisenberg Uncertainty Principle Visualized",
    subtitle = "Trade-off between position (Δx) and momentum (Δp)",
    x = "Position Uncertainty (Δx)",
    y = "Momentum Uncertainty (Δp)",
    color = "Uncertainty Cases",
    fill = "Uncertainty Cases"
  )+
  theme_minimal()+
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    legend.position = "top"
  )