# Load required libraries
library(shiny)
library(ggplot2)
library(fmsb)

# Define UI
ui <- fluidPage(
  titlePanel("Bayesian Prediction of Opponent's Next Move"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("obs_action", "Select Observed Action:",
                  choices = c("Prev_Attack", "Prev_Parry", "Prev_Retreat"),
                  selected = "Prev_Attack")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Bar Plot", plotOutput("bar_plot")),
        tabPanel("Violin Plot", plotOutput("violin_plot")),
        tabPanel("Radar Chart", plotOutput("radar_chart"))
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Define prior and likelihood
  prior <- c(attack = 0.4, parry = 0.3, retreat = 0.3)
  likelihood <- matrix(c(
    0.7, 0.2, 0.1,  # If opponent previously attacked
    0.3, 0.5, 0.2,  # If opponent previously parried
    0.2, 0.3, 0.5   # If opponent previously retreated
  ), nrow = 3, byrow = TRUE,
  dimnames = list(c("Prev_Attack", "Prev_Parry", "Prev_Retreat"), 
                  c("Attack", "Parry", "Retreat")))
  
  # Reactive function to compute posterior probabilities
  posterior <- reactive({
    obs_action <- input$obs_action
    (likelihood[obs_action, ] * prior) / sum(likelihood[obs_action, ] * prior)
  })
  
  # Bar Plot
  output$bar_plot <- renderPlot({
    posterior_df <- data.frame(Move = names(posterior()), Probability = posterior())
    ggplot(posterior_df, aes(x = Move, y = Probability, fill = Move)) +
      geom_bar(stat = "identity") +
      labs(title = "Bar Plot of Posterior Probabilities", y = "Probability") +
      theme_minimal()
  })
  
  # Violin Plot
  output$violin_plot <- renderPlot({
    posterior_df <- data.frame(Move = names(posterior()), Probability = posterior())
    ggplot(posterior_df, aes(x = Move, y = Probability, fill = Move)) +
      geom_violin(trim = FALSE) +
      geom_boxplot(width = 0.1, fill = "white") +
      labs(title = "Violin Plot of Posterior Probabilities", y = "Probability") +
      theme_minimal()
  })
  
  # Radar Chart
  output$radar_chart <- renderPlot({
    posterior_df <- data.frame(Move = names(posterior()), Probability = posterior())
    radar_df <- rbind(rep(1, 3), rep(0, 3), posterior())
    radarchart(radar_df, title = "Radar Chart of Posterior Probabilities", 
               pcol = rainbow(3), plwd = 2, plty = 1)
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
