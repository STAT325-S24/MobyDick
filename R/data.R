#' MobyDick
#'
#' This data frame returns a tibble with every line from the text of Moby Dick 
#' along with line number, text section, and chapter number. 
#'
#' @format ## `MobyDick`
#' A data frame with 22243 rows and 1 column:
#' \describe{
#'   \item{text}{lines of text}
#'   \item{line_number}{line number}
#'   \item{section}{section of work the line is found}
#'   \item{chapter_number}{chapter number}
#'   ...
#' }
#' @source <https://www.gutenberg.org/ebooks/15>
"MobyDick"

#' anno_moby
#'
#' This data frame has annotated text of Moby-Dick from the cleanNLP package
#'
#' @format ## `anno_moby`
#' A data frame with 3 elements
#' \describe{
#'   \item{token}{tibble of tokenized words}
#'   \item{entity}{tibble of entities in text}
#'   \item{document}{tibble of document IDs}
#'   ...
#' }
#' @source annotated using cleanNLP
"anno_moby"

#' token_with_chapters
#'
#' This data frame returns a tibble of tokenized text with chapter numbers
#'
#' @format ## `token_with_chapters`
#' A data frame with 254,474 rows and 11 columns
#' \describe{
#'   \item{doc_id}{document ID}
#'   \item{sid}{sentence ID}
#'   \item{tid}{token ID}
#'   \item{token}{token}
#'   \item{token_with_ws}{token with whitespace}
#'   \item{lemma}{lemma}
#'   \item{upos}{part of speech}
#'   \item{xpos}{abbreviated part of speech}
#'   \item{tid_source}{start of token set}
#'   \item{relation}{relation to root of token set}
#'   \item{chapter_number}{chapter number}
#'   ...
#' }
#' @source data wrangling of annotated text from cleanNLP
"token_with_chapters"

#' token_type_summary
#'
#' This package returns a tibble of the number of parts of speech and 
#' their proportion per chapter
#'
#' @format ## `token_type_summary`
#' A data frame with 135 rows and 18 columns
#' \describe{
#'   \item{chapter_number}{chapter number}
#'   \item{total}{total number of words}
#'   \item{NOUN_count}{number of nouns}
#'   \item{NOUN_prop}{proportion of nouns}
#'   \item{ADJ_count}{number of adjective}
#'   \item{ADJ_prop}{proportion of adjective}
#'   \item{VERB_count}{number of verbs}
#'   \item{VERB_prop}{proportion of verbs}
#'   \item{ADV_count}{number of adverbs}
#'   \item{ADV_prop}{proportion of adverbs}
#'   \item{PROPN_count}{number of proper nouns}
#'   \item{PROPN_prop}{proportion of proper nouns}
#'   \item{CONJ_count}{number of conjunctions}
#'   \item{CONJ_prop}{proportion of conjunctions}
#'   \item{PRON_count}{number of pronouns}
#'   \item{PRON_prop}{proportion of pronouns}
#'   \item{PUNCT_count}{number of punctuations}
#'   \item{PUNCT_prop}{proportion of punctuations}
#'   ...
#' }
#' @source data wrangling of annotated text from cleanNLP
"token_type_summary"
