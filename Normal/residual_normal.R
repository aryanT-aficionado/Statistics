library(ggplot2)

#loading dataset
data(airquality)

head(airquality)

# Removing rows with missing values
airquality_clean <- na.omit(airquality)

# Fitting a linear regression model
# Predicting 'Ozone' concentration based on 'Wind'
model <- lm(Ozone ~ Solar.R, data = airquality_clean)

residual_data = data.frame(Resi = resid(model))

ggplot(residual_data, aes(x = Resi)) +
  geom_histogram(aes(y = ..density..), bins = 20, fill = "blue", alpha = 0.6) +
  geom_density(color = "red", size = 1.2) +
  labs(
    title = "Residuals of the dataset",
    x = "Residuals",
    y = "Density"
  ) +
  theme_minimal()

