library(ggplot2)

# Define the total lifespan (in billion years) for a Sun-like star
total_lifespan = 15  # Main sequence + Red Giant + White Dwarf

# Define time spent in each stage of a star (in billion years)
time_spent = c(
  Main_Sequence = 10,  # Billion years
  Red_Giant = 1,       # Billion years
  White_Dwarf = 4,     # Billion years
  Supernova = 0.001    # Billion years (negligible for Sun-like stars)
)

# Normalize to ensure total matches the lifespan
time_spent = time_spent / sum(time_spent) * total_lifespan

# Create a data frame for visualization
star_data = data.frame(
  Stage = names(time_spent),
  Duration = time_spent
)

# Create a stacked bar chart
timeline_chart = ggplot(star_data, aes(x = "", y = Duration, fill = Stage)) +
  geom_bar(stat = "identity", width = 0.5) +
  coord_polar(theta = "y") +  # Optional: Use `coord_flip()` for horizontal bars
  scale_fill_brewer(palette = "Set2") +
  theme_minimal() +
  labs(
    title = "Time Spent in Each Stage of a Star's Life (Billion Years)",
    x = NULL,
    y = "Duration (Billion Years)"
  )

print(timeline_chart)
