library(shiny)
library(igraph)
library(ggplot2)
library(dplyr)
library(visNetwork)
library(shinythemes)

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = shinytheme("flatly"),
  titlePanel("🎯 Six Degrees of Separation - Interactive Explorer"),
  
  sidebarLayout(
    sidebarPanel(
      width = 3,
      h4("Network Controls"),
      sliderInput("n_people", "Number of People:", 
                  min = 50, max = 500, value = 100, step = 50),
      sliderInput("neighbors", "Average Neighbors:", 
                  min = 2, max = 10, value = 5, step = 1),
      sliderInput("rewiring", "Rewiring Probability:", 
                  min = 0.01, max = 0.2, value = 0.05, step = 0.01),
      numericInput("seed", "Random Seed:", value = 6969),
      actionButton("generate", "Generate New Network", class = "btn-primary"),
      br(), br(),
      h4("Visualization Options"),
      checkboxInput("show_labels", "Show Node Labels", value = FALSE),
      checkboxInput("show_communities", "Show Communities", value = TRUE),
      selectInput("layout", "Network Layout:",
                  choices = c("Fruchterman-Reingold" = "fr",
                              "Kamada-Kawai" = "kk",
                              "Circle" = "circle",
                              "Grid" = "grid"))
    ),
    
    mainPanel(
      width = 9,
      tabsetPanel(
        tabPanel("Interactive Network",
                 visNetworkOutput("network_plot", height = "600px")),
        tabPanel("Statistics & Analysis",
                 fluidRow(
                   column(6,
                          plotOutput("path_histogram", height = "300px"),
                          plotOutput("degree_dist", height = "300px")
                   ),
                   column(6,
                          h4("Network Metrics"),
                          tableOutput("metrics_table"),
                          h4("Community Detection"),
                          plotOutput("community_plot", height = "400px")
                   )
                 )),
        tabPanel("About",
                 div(
                   h3("About Six Degrees of Separation"),
                   p("This interactive demonstration shows the 'six degrees of separation' concept using network science and graph theory."),
                   HTML("<p><strong>What is Six Degrees of Separation?</strong><br>
                        The idea that any two people in the world are connected by at most six social connections.</p>"),
                   p("This app generates synthetic social networks using the Watts-Strogatz small-world model, which captures the properties of real-world social networks:"),
                   tags$ul(
                     tags$li("High clustering (friends of friends are likely friends)"),
                     tags$li("Short average path lengths (the 'six degrees' phenomenon)")
                   ),
                   h4("How to Use This App:"),
                   tags$ol(
                     tags$li("Adjust the network parameters in the sidebar"),
                     tags$li("Click 'Generate New Network' to create a new random social network"),
                     tags$li("Explore the interactive network visualization"),
                     tags$li("Check the Statistics tab for detailed analysis")
                   )
                 ))
      )
    )
  )
)

server <- function(input, output, session) {
  
  # Reactive expression for network generation
  network_data <- eventReactive(input$generate, {
    set.seed(input$seed)
    
    # Generate small-world network
    social_network <- sample_smallworld(1, input$n_people, input$neighbors, input$rewiring)
    
    # Calculate network metrics
    shortest_paths <- distances(social_network)
    path_lengths <- shortest_paths[upper.tri(shortest_paths)]
    path_lengths <- path_lengths[is.finite(path_lengths)]
    
    # Community detection
    communities <- cluster_louvain(social_network)
    
    # Degree distribution
    degree_dist <- degree(social_network)
    
    list(
      network = social_network,
      path_lengths = path_lengths,
      communities = communities,
      degree_dist = degree_dist,
      avg_path_length = mean(path_lengths),
      clustering_coef = transitivity(social_network),
      diameter = diameter(social_network)
    )
  }, ignoreNULL = FALSE)
  
  # Interactive network plot
  output$network_plot <- renderVisNetwork({
    data <- network_data()
    g <- data$network
    communities <- data$communities
    
    # Prepare nodes
    nodes <- data.frame(
      id = 1:vcount(g),
      label = if(input$show_labels) paste("Person", 1:vcount(g)) else NA,
      group = as.character(membership(communities)),
      title = paste("Person", 1:vcount(g), "<br>",
                    "Community:", membership(communities)[1:vcount(g)], "<br>",
                    "Degree:", degree(g)),
      value = degree(g),
      font.size = 18
    )
    
    # Prepare edges
    edges <- get.edgelist(g) %>% 
      as.data.frame() %>%
      rename(from = V1, to = V2)
    
    # Create network
    visNetwork(nodes, edges, width = "100%", height = "100%") %>%
      visNodes(scaling = list(min = 10, max = 30)) %>%
      visEdges(smooth = FALSE, color = list(opacity = 0.7)) %>%
      visOptions(highlightNearest = list(enabled = TRUE, degree = 1, hover = TRUE),
                 nodesIdSelection = TRUE) %>%
      visLayout(randomSeed = 42) %>%
      visPhysics(stabilization = TRUE) %>%
      visInteraction(navigationButtons = TRUE)
  })
  
  # Path length histogram
  output$path_histogram <- renderPlot({
    data <- network_data()
    path_data <- data.frame(distance = as.numeric(data$path_lengths))
    
    ggplot(path_data, aes(x = distance)) +
      geom_histogram(binwidth = 1, fill = "steelblue", alpha = 0.7, color = "white") +
      geom_vline(xintercept = mean(path_data$distance), 
                 color = "red", linetype = "dashed", size = 1) +
      labs(title = "Distribution of Social Distances",
           subtitle = paste("Average Path Length:", round(mean(path_data$distance), 2)),
           x = "Degrees of Separation",
           y = "Frequency") +
      theme_minimal() +
      theme(plot.title = element_text(face = "bold"))
  })
  
  # Degree distribution
  output$degree_dist <- renderPlot({
    data <- network_data()
    degree_data <- data.frame(degree = data$degree_dist)
    
    ggplot(degree_data, aes(x = degree)) +
      geom_histogram(fill = "darkorange", alpha = 0.7, color = "white", bins = 15) +
      labs(title = "Degree Distribution",
           subtitle = "Number of connections per person",
           x = "Number of Connections",
           y = "Count") +
      theme_minimal() +
      theme(plot.title = element_text(face = "bold"))
  })
  
  # Community detection plot
  output$community_plot <- renderPlot({
    data <- network_data()
    
    plot(data$communities, data$network,
         vertex.size = 6,
         vertex.label = NA,
         vertex.frame.color = "white",
         edge.arrow.size = 0.3,
         main = paste("Detected Communities:", length(unique(membership(data$communities)))))
  })
  
  # Metrics table
  output$metrics_table <- renderTable({
    data <- network_data()
    
    metrics <- data.frame(
      Metric = c("Number of People", 
                 "Average Path Length", 
                 "Clustering Coefficient",
                 "Network Diameter",
                 "Number of Communities",
                 "Average Degree"),
      Value = c(input$n_people,
                round(data$avg_path_length, 2),
                round(data$clustering_coef, 3),
                data$diameter,
                length(unique(membership(data$communities))),
                round(mean(data$degree_dist), 2)
      )
    )
    metrics
  }, bordered = TRUE, striped = TRUE, width = "100%")
}

# Run the application 
shinyApp(ui = ui, server = server)
