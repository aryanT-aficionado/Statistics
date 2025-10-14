# Load required libraries
library(igraph)
library(ggplot2)
library(dplyr)
library(visNetwork)
library(networkD3)

# 1. Create a synthetic social network
set.seed(6969)
n_people <- 100
social_network <- sample_smallworld(1, n_people, 5, 0.05)

# Calculate shortest paths
shortest_paths <- distances(social_network)
average_path_length <- mean(shortest_paths[shortest_paths != Inf])

# 2. Basic network visualization
plot(social_network, 
     vertex.size = 4,
     vertex.label = NA,
     vertex.color = "lightblue",
     edge.arrow.size = 0.3,
     main = paste("Six Degrees of Separation Network\nAverage Path Length:",
                  round(average_path_length, 2)))


# Interactive network with visNetwork
nodes <- data.frame(id = 1:n_people, 
                    label = paste("Person", 1:n_people),
                    group = sample(1:4, n_people, replace = TRUE))

edges <- get.edgelist(social_network) %>% 
  as.data.frame() %>%
  rename(from = V1, to = V2)

visNetwork(nodes, edges) %>%
  visGroups(groupname = "1", color = "lightblue") %>%
  visGroups(groupname = "2", color = "orange") %>%
  visPhysics(stabilization = FALSE)

# Path length distribution analysis
path_lengths <- shortest_paths[upper.tri(shortest_paths)]
path_lengths <- path_lengths[is.finite(path_lengths)]

# Create distribution plot
path_data <- data.frame(
  distance = as.numeric(path_lengths)
)

ggplot(path_data, aes(x = distance)) +
  geom_histogram(binwidth = 1, fill = "steelblue", alpha = 0.7) +
  geom_vline(xintercept = mean(path_data$distance), 
             color = "red", linetype = "dashed", size = 1) +
  labs(title = "Distribution of Social Distances",
       subtitle = paste("Six Degrees of Separation: Average =", 
                        round(mean(path_data$distance), 2)),
       x = "Degrees of Separation",
       y = "Frequency") +
  theme_minimal()

# Community detection example
communities <- cluster_louvain(social_network)

plot(communities, social_network,
     vertex.size = 4,
     vertex.label = NA,
     main = "Detected Communities in Social Network")

