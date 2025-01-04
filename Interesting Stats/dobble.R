library(igraph)
library(RColorBrewer)

create_graph = function(deck){
  edges = c()
  edge_labels = c()
  
  for(i in seq_along(deck)){
    for(j in seq_along(deck)){
      if(i<j && length(intersect(deck[[i]], deck[[j]])) == 1){
        edges <- c(edges, i, j)
        edge_labels <- c(edge_labels, intersect(deck[[i]], deck[[j]]))
      }
    }
  }
  
  g = graph(edges, directed = FALSE)
  
  # Add vertex and edge attributes
  V(g)$label <- paste("Card", seq_along(deck)) # Card numbers as labels
  V(g)$color <- brewer.pal(n = 8, name = "Set2")[seq_along(deck) %% 8 + 1]
  E(g)$label <- edge_labels
  E(g)$color <- "pink"
  
  return(g)
}

dobble_graph <- create_graph(deck)
plot(dobble_graph,
     vertex.label.cex = 1.2,
     vertex.size = 30,
     edge.label.cex = 0.8,
     main = "Dobble Card Relationships with Shared Symbols")

# Detect clusters based on shared symbols
clusters <- cluster_edge_betweenness(dobble_graph)

# Plot with clusters
plot(clusters, dobble_graph,
     vertex.label.cex = 1.2,
     vertex.size = 30,
     edge.label.cex = 0.8,
     main = "Clustered Dobble Card Graph")

