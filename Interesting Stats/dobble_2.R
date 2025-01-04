generate_dobble_deck <- function(n) {
  # Total cards and symbols
  total_cards <- n^2 + n + 1
  cards <- list()
  
  # First group of cards
  for (i in 1:(n+1)) {
    cards[[i]] <- c(1:(n+1)) + (i-1) * (n+1)
  }
  
  # Additional cards
  for (i in 1:n) {
    for (j in 1:n) {
      cards[[length(cards) + 1]] <- c(i, (n+2) + j + (i-1) * n)
    }
  }
  return(cards)
}

# Example: Generate Dobble deck with n=2
deck <- generate_dobble_deck(2)

library(igraph)

# Create a graph where edges represent shared symbols
create_graph <- function(deck) {
  edges <- c()
  for (i in seq_along(deck)) {
    for (j in seq_along(deck)) {
      if (i < j && length(intersect(deck[[i]], deck[[j]])) == 1) {
        edges <- c(edges, i, j)
      }
    }
  }
  g <- graph(edges, directed = FALSE)
  return(g)
}

dobble_graph <- create_graph(deck)

# Degree Centrality
degree_centrality <- degree(dobble_graph)

# Clustering Coefficient
clustering_coeff <- transitivity(dobble_graph, type = "local")

# Community Detection
communities <- cluster_edge_betweenness(dobble_graph)

# Print Results
print(paste("Degree Centrality:", degree_centrality))
print(paste("Clustering Coefficient:", clustering_coeff))
print(paste("Detected Communities:", membership(communities)))

# Enhanced Plot
plot(communities, dobble_graph,
     vertex.size = degree_centrality * 10,  # Size proportional to degree centrality
     vertex.color = membership(communities),  # Color by community
     vertex.label.cex = 1.2,
     edge.label = NA,
     main = "Dobble Graph: Social Network Analysis")
