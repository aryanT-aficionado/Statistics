library(deSolve)
library(ggplot2)
library(tidyverse)
library(brms)  

set.seed(2025)

# ODE (simplified Lotka-Volterra for fencing)
fencer_ode = function(time, state, params) {
  with(as.list(c(state, params)), {
    # dA/dt = αA - βAP : Attack rate grows naturally but is reduced by opponent's parries
    dA = alpha * A - beta * A * P  
    # dP/dt = γP + δAP : Parry rate increases with both self-momentum and opponent's attacks
    dP = gamma * P + delta * A * P
    list(c(dA, dP))
  })
}

# Parameters 🤔 (ground truth for any model)
true_params = c(alpha = 1.1, beta = 0.3, gamma = 0.5, delta = 0.2)
initial_state = c(A = 10, P = 5)  # Initial attack/parry intensity
times = seq(0, 10, by = 0.1)

# ODE Solver
ode_sol = ode(y = initial_state, times = times, func = fencer_ode, parms = true_params) |>
  as.data.frame() |>
  as_tibble()

# To simulate real-world observations, noise is necessary 🤷
observed_data = ode_sol |>
  mutate(
    A_obs = A + rnorm(n(), 0, 3),  # Noisy attack intensity
    P_obs = P + rnorm(n(), 0, 2)   # Noisy parry intensity
  )

# Bayesian model to estimate ODE parameters with uncertainty 😶
bayesian_model = brm(
  bf(A_obs ~ alpha * exp(-beta * P_obs) * time,  # Simplified ODE approximation
     alpha ~ 1, beta ~ 1,
     nl = TRUE),
  data = observed_data,
  family = gaussian(),
  prior = c(
    prior(normal(1, 0.5), nlpar = "alpha"),  # Prior Prediction for alpha
    prior(normal(0.2, 0.1), nlpar = "beta")  # Prior Prediction for beta
  ),
  chains = 4, iter = 2000, refresh = 0
)

# Summarization parameter posteriors
summary(bayesian_model)

# Posterior predictive distribution
posterior_pred = posterior_predict(bayesian_model, newdata = observed_data)

# Ploting intervals
observed_data |>
  mutate(
    pred_median = apply(posterior_pred, 2, median),
    pred_lower = apply(posterior_pred, 2, quantile, 0.05),
    pred_upper = apply(posterior_pred, 2, quantile, 0.95)
  ) |>
  ggplot(aes(x = time)) +
  geom_line(aes(y = A), color = "black", linetype = "dashed") +  # True dynamics
  geom_point(aes(y = A_obs), color = "#d7191c", alpha = 0.3) +   # Observed data
  geom_ribbon(aes(ymin = pred_lower, ymax = pred_upper), fill = "#2c7bb6", alpha = 0.2) +
  geom_line(aes(y = pred_median), color = "#2c7bb6", linewidth = 1) +
  labs(
    title = "Fencing Dynamics: Bayesian Uncertainty Quantification",
    subtitle = "True attack (dashed) vs. Bayesian posterior predictions (blue)",
    x = "Time (s)", y = "Attack Intensity"
  ) +
  theme_minimal()
