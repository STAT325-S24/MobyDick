library(shiny)
library(readr)
library(dplyr)

# Load in necessary data
token_type_summary <- read_csv("token_type_summary.csv")

ui <- fluidPage(
  
  titlePanel("Moby Dick"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      # Buttons to select part of speech
      radioButtons(inputId = "part_of_speech",
                   h3("Select a Part of Speech"),
                   choices = list("Noun" = "noun", 
                                  "Adjective" = "adj",
                                  "Verb" = "verb",
                                  "Proper Noun" = "proper_noun",
                                  "Conjunction" = "conj"), 
                   selected = "noun")
      
    ),
    
    mainPanel(
      
      # display table
      dataTableOutput(outputId = "table")
      
    )
  )
)

server <- function(input, output) {
  
  # table output
  output$table <- renderDataTable({
    token_type_summary |>
      select(chapter_number,
             total,
             paste0(input$part_of_speech, "_count"),
             paste0(input$part_of_speech, "_prop")
             )
  })
}

shinyApp(ui = ui, server = server)

