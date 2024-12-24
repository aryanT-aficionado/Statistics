# Joint Density of the 2 independent varibales X and Y
library(plotly)

set.seed(123)  # For reproducibility
# Assuming there is no correlation 
x = rnorm(1000, mean = 0, sd = 1)  
y = rnorm(1000, mean = 0, sd = 1)  

# Create a 2D density estimate
density_data <- MASS::kde2d(x, y, n = 50)  # Kernel density estimation

# Create a 3D surface plot
fig <- plot_ly(
  x = ~density_data$x,
  y = ~density_data$y,
  z = ~density_data$z,
  type = "surface",
  colorscale = "Viridis"
)

fig <- fig %>%
  layout(
    title = "Normal Distribution in Joint Space",
    scene = list(
      xaxis = list(title = "X Values"),
      yaxis = list(title = "Y Values"),
      zaxis = list(title = "Density")
    )
  )

# Display the plot
fig
