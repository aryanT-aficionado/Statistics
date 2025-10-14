library(pROC)
library(PRROC)
library(caret)
library(mlbench)


set.seed(42)
n_samples <- 10000

# Generate a synthetic binary classification problem with 5% positive class
X <- mlbench.2dnormals(n_samples, sd = 0.8, fat = TRUE)
y <- ifelse(X$classes == 1, 0, 1)  # Convert to binary labels (class 2 becomes minority)

# Only keep the features and labels
X <- X$x
y <- as.numeric(y)

# Split into train/test sets
index <- createDataPartition(y, p = 0.7, list = FALSE)
X_train <- X[index, ]
X_test <- X[-index, ]
y_train <- y[index]
y_test <- y[-index]