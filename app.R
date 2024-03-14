library(shiny)
library(readr)
library(dplyr)
library(plotly)
library(stringr)
library(DT)
library(MobyDick)

# Load in necessary data
token_type_summary <- read_csv("token_type_summary.csv")
token_with_chapters <- read_csv("token_with_chapters.csv")

ui <- fluidPage(
  
  titlePanel("Moby Dick"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      # Buttons to select part of speech
      radioButtons(inputId = "part_of_speech",
                   h3("Select a Part of Speech"),
                   choices = list("Noun" = "NOUN", 
                                  "Adjective" = "ADJ",
                                  "Verb" = "VERB",
                                  "Adverb" = "ADV",
                                  "Proper Noun" = "PROPN",
                                  "Conjunction" = "CONJ",
                                  "Pronoun" = "PRON",
                                  "Punctuation" = "PUNCT"), 
                   selected = "NOUN")
      
    ),
    
    mainPanel(
      
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
  
  # plot output
  output$plot <- renderPlotly({
    fig <- plot_ly(data = token_type_summary, 
                   x = ~chapter_number, 
                   y = ~get(paste0(input$part_of_speech, "_prop")), 
                   type = "scatter",
                   mode='markers',
                   source = "myPlotSource") |>
      layout(title = 'Proportion of Parts of Speech by Chapter', 
             xaxis = list(title = "Chapter Number"), 
             yaxis = list(title = paste0('Proportion of ', 
                                         str_to_title(input$part_of_speech))))
    event_register(fig, "plotly_click")
    fig
  })
  
  # text output
  output$selected_point <- renderPrint({
    selected_point <- event_data("plotly_click", source = "myPlotSource")
    if (!is.null(selected_point)) {
      annotated_text <- token_with_chapters |>
        filter(chapter_number == selected_point[2]$pointNumber + 1) |>
        mutate(token = 
                 if_else(upos %in% ifelse(input$part_of_speech == "CONJ", 
                                          c("CCONJ", "SCONJ"), 
                                          c(input$part_of_speech)), 
                         paste0("<b>", token, "</b>"), token)) |>
        arrange(doc_id, sid, tid) |> 
        group_by(doc_id, sid) |>
        mutate(space_after = ifelse(lead(upos, default = " ") == "PUNCT", 
                                    "", " "),
               word_with_space = paste(token, space_after, sep = "")) |>
        summarise(sentence = paste(word_with_space, collapse = ""), 
                  .groups = 'drop') |> 
        group_by(doc_id) |>
        summarise(paragraph = paste(sentence, collapse = " "), 
                  .groups = 'drop')
      
      # Output the result
      HTML(paste(annotated_text$paragraph, collapse = ""))
    } else {
      "Click on a point to see its information"
    }
  })
}

shinyApp(ui = ui, server = server)

