library(shiny)
library(readr)
library(dplyr)
library(plotly)
library(stringr)
library(DT)
library(MobyDick)

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
      dataTableOutput(outputId = "table"),
      plotlyOutput(outputId = "plot"),
      tags$style(HTML(".output_pre { max-height: 300px; }")),
      uiOutput("selected_point")
      
    )
  )
)

server <- function(input, output) {
  
  # table output
  output$table <- renderDataTable({
    to_display <- token_type_summary |>
      select(chapter_number,
             total,
             paste0(input$part_of_speech, "_count"),
             paste0(input$part_of_speech, "_prop")
             ) |>
      arrange(desc(get(paste0(input$part_of_speech, "_prop"))))
    datatable(to_display, options = list(pageLength = 5))
      
  })
  output$plot <- renderPlotly({
    fig <- plot_ly(data = token_type_summary, 
                   x = ~chapter_number, 
                   y = ~get(paste0(input$part_of_speech, "_prop")), 
                   type = "scatter",
                   source = "myPlotSource") |>
      layout(title = 'Proportion of Parts of Speech by Chapter', xaxis = list(title = "Chapter Number"), 
             yaxis = list(title = paste0('Proportion of ', str_to_title(input$part_of_speech))))
    event_register(fig, "plotly_click")
    fig
  })
  
  output$selected_point <- renderPrint({
    selected_point <- event_data("plotly_click", source = "myPlotSource")
    if (!is.null(selected_point)) {
      to_print <- MobyDick::MobyDick |>
        filter(chapter_number == selected_point[2]$pointNumber + 1)
      HTML(paste(to_print$text, collapse = "<br>"))
    } else {
      "Click on a point to see its information"
    }
  })
}

shinyApp(ui = ui, server = server)

