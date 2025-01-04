library(ggplot2)

# Generate hypothetical scenarios
data <- data.frame(
  n = 1:20,
  Total = (1:20)^2 + (1:20) + 1,
  Network_Connections = (1:20) * ((1:20) - 1) / 2,  # Fully connected network
  Data_Scaling = (1:20)^3  # Exponential growth in data processing
)

# Replace zeros or non-positive values with NA for log transformation
data <- data %>%
  mutate(
    Total = ifelse(Total > 0, Total, NA),
    Network_Connections = ifelse(Network_Connections > 0, Network_Connections, NA),
    Data_Scaling = ifelse(Data_Scaling > 0, Data_Scaling, NA)
  )

# Combined plot
ggplot(data) +
  geom_line(aes(x = n, y = Total, color = "Dobble Cards"), size = 1.2, linetype = "solid") +
  geom_line(aes(x = n, y = Network_Connections, color = "Social Network Connections"), size = 1.2, linetype = "dashed") +
  geom_line(aes(x = n, y = Data_Scaling, color = "Data Scaling"), size = 1.2, linetype = "dotted") +
  scale_color_manual(values = c("Dobble Cards" = "blue", "Social Network Connections" = "green", "Data Scaling" = "purple")) +
  labs(
    title = "Growth Comparisons: Dobble vs Real-Life Scenarios",
    x = "Parameter n",
    y = "Growth Metric (log scale)",
    color = "Scenario"
  ) +
  scale_y_log10() +  # Log scale for better visualization
  theme_minimal(base_size = 15) +
  theme(legend.position = "top")
