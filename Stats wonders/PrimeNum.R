library(ggplot2)
library(dplyr)
library(gridExtra)
library(viridis)

# Function to check if a number is prime
is_prime = function(n) {
  if (n < 2) return(FALSE)
  if (n == 2) return(TRUE)
  if (n %% 2 == 0) return(FALSE)
  for (i in 3:sqrt(n)) {
    if (n %% i == 0) return(FALSE)
  }
  return(TRUE)
}

# Generate primes up to n
generate_primes = function(n) {
  primes = c()
  for (i in 2:n) {
    if (is_prime(i)) {
      primes <- c(primes, i)
    }
  }
  return(primes)
}

# Prime counting function π(x)
prime_count = function(x) {
  sum(generate_primes(x) <= x)
}

# Create data for visualization
max_n = 10000
x_values = seq(100, max_n, by = 100)


# Calculating actual prime counts and approximations
data = data.frame(
  x = x_values,
  actual_count = sapply(x_values, prime_count),
  # Prime Number Theorem: π(x) ~ x/ln(x) as x → ∞
  # This is the fundamental asymptotic formula discovered by Gauss and Legendre
  pnt_approx = x_values / log(x_values),  # Prime Number Theorem approximation
  
  # Logarithmic Integral approximation: Li(x) ≈ x/ln(x) * (1 + 1.2762/ln(x) + ...)
  # More accurate than basic PNT, includes first-order correction term
  # The constant 1.2762 comes from the series expansion of Li(x)
  li_approx = sapply(x_values, function(x) x / log(x) * (1 + 1.2762/log(x)))  # Better approximation
)

head(data)

# Calculate errors for analysis
data$pnt_error = abs(data$actual_count - data$pnt_approx) / data$actual_count * 100
data$li_error = abs(data$actual_count - data$li_approx) / data$actual_count * 100

# Plot 1: Main Prime Number Theorem visualization
p1 = ggplot(data, aes(x = x)) +
  geom_line(aes(y = actual_count, color = "Actual π(x)"), size = 1.2) +
  geom_line(aes(y = pnt_approx, color = "x/ln(x) Approximation"), size = 1, linetype = "dashed") +
  geom_line(aes(y = li_approx, color = "Improved Approximation"), size = 1, linetype = "dotted") +
  scale_color_manual(values = c("Actual π(x)" = "#2E86AB", 
                                "x/ln(x) Approximation" = "#A23B72",
                                "Improved Approximation" = "#F18F01")) +
  labs(
    title = "Prime Number Theorem",
    subtitle = "How nature's 'regularization' governs prime distribution",
    x = "n",
    y = "Number of primes ≤ n",
    color = "Function",
    caption = "The asymptotic behavior mirrors sparsity patterns in high-dimensional ML"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 11),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )
p1

# Plot 2: Error analysis - crucial for ML applications
p2 = ggplot(data, aes(x = x)) +
  geom_line(aes(y = pnt_error, color = "Basic PNT Error"), size = 1) +
  geom_line(aes(y = li_error, color = "Improved Error"), size = 1) +
  scale_color_manual(values = c("Basic PNT Error" = "#A23B72", 
                                "Improved Error" = "#F18F01")) +
  labs(
    title = "Approximation Error Analysis",
    subtitle = "Understanding convergence rates - key for algorithm design",
    x = "n",
    y = "Relative Error (%)",
    color = "Error Type"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )
p2

# Plot 3: Prime gaps - relevant to sampling and feature selection
primes = generate_primes(1000)
gaps = diff(primes)
gap_data = data.frame(
  prime_index = 1:(length(gaps)),
  gap = gaps,
  prime_value = primes[-length(primes)]
)

p3 = ggplot(gap_data, aes(x = prime_value, y = gap)) +
  geom_point(alpha = 0.6, color = "#2E86AB", size = 1.5) +
  geom_smooth(method = "loess", color = "#F18F01", se = FALSE) +
  labs(
    title = "Prime Gaps: Natural Sparsity Patterns",
    subtitle = "Similar to feature importance distributions in ML",
    x = "Prime Number",
    y = "Gap to Next Prime"
  ) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank())
p3

# Plot 4: Density visualization - connection to probability distributions
density_data = data.frame(
  x = x_values,
  prime_density = data$actual_count / x_values,
  theoretical_density = 1 / log(x_values)
)

p4 = ggplot(density_data, aes(x = x)) +
  geom_line(aes(y = prime_density, color = "Actual Density"), size = 1.2) +
  geom_line(aes(y = theoretical_density, color = "1/ln(x) Theoretical"), size = 1, linetype = "dashed") +
  scale_color_manual(values = c("Actual Density" = "#2E86AB", 
                                "1/ln(x) Theoretical" = "#A23B72")) +
  labs(
    title = "Prime Density: Nature's Learning Rate Schedule",
    subtitle = "Logarithmic decay similar to adaptive learning rates in DL",
    x = "n",
    y = "Prime Density",
    color = "Density Type"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )
p4

cat("\n=== KEY INSIGHTS FOR YOUR LINKEDIN POST ===\n")
cat("At n =", max(x_values), ":\n")
cat("- Actual prime count:", tail(data$actual_count, 1), "\n")
cat("- PNT approximation:", round(tail(data$pnt_approx, 1)), "\n")
cat("- Approximation error:", round(tail(data$pnt_error, 1), 2), "%\n")
cat("- Average prime density:", round(tail(data$actual_count, 1) / tail(x_values, 1), 4), "\n")
cat("- Theoretical density:", round(1/log(tail(x_values, 1)), 4), "\n")
