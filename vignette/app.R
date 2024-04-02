library(shiny)
library(readr)
library(dplyr)
library(plotly)
library(stringr)
library(DT)
library(MobyDick)

ui <- fluidPage(
  
  titlePanel("Moby Dick"),
  tabsetPanel(
    tabPanel("Part of Speech Analysis",
  
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
                       selected = "NOUN"),
          
          uiOutput("textOutput")
          
        ),
        
        mainPanel(
          dataTableOutput(outputId = "table"),
          plotlyOutput(outputId = "plot", height = '300px', width = '500px'),
          tags$style(HTML(".output_pre { max-height: 300px; }")),
          uiOutput("selected_point")
          
        )
      )
    ),
    tabPanel("About",
             h4("About This App"),
             p("This Shiny app explores the linguistic structure of Herman 
               Melville's 'Moby-Dick' through a detailed part of speech 
               analysis. Users can interactively explore the frequency and 
               distribution of nouns, verbs, adjectives, and other parts of 
               speech throughout the novel's chapters. This app serves as a tool 
               for educators, students, and literature enthusiasts to delve 
               deeper into the text's complexity, uncover patterns, and gain 
               insights into Melville's use of language."),
             p("Data is derived from a comprehensive analysis of the text,
               utilizing the 'MobyDick' R package for tokenization and part of 
               speech tagging. The interactive charts and tables offer a novel 
               way of engaging with this classic work, providing a fresh 
               perspective on its narrative and stylistic elements."),
             p("Developed by Adam Rogers, this application is intended for 
               educational purposes and to foster a deeper appreciation of 
               'Moby-Dick' and literary analysis.")
    )
  )
)


server <- function(input, output) {
  
  output$textOutput <- renderUI({
    selected_pos <- input$part_of_speech
    if (selected_pos == "NOUN") {
      return(HTML("A <b>noun</b> names a person, place, thing, or idea. <i>(Ex: pen, chair, ram, honesty)</i>"))
    } else if (selected_pos == "ADJ") {
      return(HTML("An <b>adjective</b> describes or modifies a noun or pronoun. <i>(Ex: super, red, our, big, great)</i>"))
    } else if (selected_pos == "VERB") {
      return(HTML("A <b>verb</b> indicates a state of doing, being, or having. <i>(Ex: play, be, work, love, like)</i>"))
    } else if (selected_pos == "ADV") {
      return(HTML("An <b>adverb</b> describes or modifies verbs, adjectives, and other adverbs. <i>(Ex: silently, too, very)</i>"))
    } else if (selected_pos == "PROPN") {
      return(HTML("A <b>proper noun</b> is the name of a particular person, place, organization, or thing. <i>(Ex: Buckingham Palace, Cynthia, National Geographic)</i>"))
    } else if (selected_pos == "CONJ") {
      return(HTML("A <b>conjunction</b> links words, phrases, and clauses. <i>(Ex: and, but, though, after)</i>"))
    } else if (selected_pos == "PRON") {
      return(HTML("A <b>pronoun</b> is used in place of a noun. <i>(Ex: I, you, he, she, it, they)</i>"))
    } else if (selected_pos == "PUNCT") {
      return(HTML("<b>Punctuation</b> refers to the tools used in writing to separate sentences, phrases, and clauses so that their intended meaning is clear. (Ex: . , ? ! ; :)</i>"))
    }
  })
  
  # table output
  output$table <- renderDataTable({
    to_display <- MobyDick::token_type_summary |>
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
    fig <- plot_ly(data = MobyDick::token_type_summary, 
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
        # Get chapter by number
        filter(chapter_number == selected_point[2]$pointNumber + 1) |>
        # Add bold to specified part of speech
        mutate(token = 
                 if_else(upos %in% ifelse(input$part_of_speech == "CONJ", 
                                          c("CCONJ", "SCONJ"), 
                                          c(input$part_of_speech)), 
                         paste0("<b>", token, "</b>"), token)) |>
        arrange(doc_id, sid, tid) |> 
        group_by(doc_id, sid) |>
        # Add spaces after words, but not when next token is punctuation
        mutate(space_after = ifelse(lead(upos, default = " ") == "PUNCT", 
                                    "", " "),
               word_with_space = paste(token, space_after, sep = "")) |>
        # Combine words to sentence
        summarise(sentence = paste(word_with_space, collapse = ""), 
                  .groups = 'drop') |> 
        group_by(doc_id) |>
        # Combine sentences to paragraphs
        summarise(paragraph = paste0("<p>", paste(sentence, collapse = " "), "</p>"), 
                  .groups = 'drop') |> 
        # Combine paragraphs to form the chapter content, preserving paragraph structure
        summarise(chapterText = paste(paragraph, collapse = ""), 
                  .groups = 'drop')
      
      # Output the result
      HTML(paste(annotated_text$chapterText, collapse = ""))
    } else {
      "Click on a point to see its information"
    }
  })
}

shinyApp(ui = ui, server = server)

