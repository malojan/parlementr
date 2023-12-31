
#' Get roll call votes for specified terms.
#'
#' This function retrieves roll call votes for the provided legislatures.
#' It provides an option to add metadata to the returned dataset.
#'
#' @param term A character vector indicating the term. Default is "16".
#' @param add_meta A logical indicating if additional metadata should be added. Default is TRUE.
#' @return A tibble containing the roll call votes.
#' @export
#' @examples
#' get_votes("16", add_meta = TRUE)

get_votes <- function(term = "16", add_meta = FALSE) {
  # Define base URLs for different legislatures
  # Only legislature 15 and 16 are available for roll_call
  base_urls <- list(
    "15" = "2017-2022.nosdeputes.fr",
    "16" = "www.nosdeputes.fr"
  )

  # Ensure that the provided legislatures are valid
  if (any(!term %in% names(base_urls))) {
    stop("Invalid legislature provided. Choose from '15', or '16'.")
  }

  # Function to fetch data based on the legislature
  fetch_data <- function(leg) {
    base_url <- base_urls[[leg]]
    url <- stringr::str_c("https://", base_url, "/", leg, "/scrutins/csv")

    return(
      readr::read_delim(url, show_col_types = FALSE) |>
        dplyr::mutate(term = leg)
    )
  }

  votes <- purrr::map_dfr(term, fetch_data)

  if (add_meta == TRUE) {
    votes <- votes |>
      dplyr::mutate(
        titre = stringr::str_squish(titre),
        scrutin_loi = stringr::str_extract(titre, "(?<=du )projet de loi.+|(?<=au )projet de loi.+|(?<=sur le )projet de loi.+|(?<=la )proposition de loi.+|proposition de résolution.+|(?<=la )motion de censure(?= déposée en application)|déclaration du Gouvernement.+|d[ée]claration de politique g[ée]n[ée]rale.+"),
        scrutin_loi_type = dplyr::case_when(
          stringr::str_detect(scrutin_loi, "proposition de loi") ~ "Proposition de loi",
          stringr::str_detect(scrutin_loi, "projet de loi") ~ "Projet de loi",
          stringr::str_detect(scrutin_loi, "motion de censure") ~ "Motion de censure",
          stringr::str_detect(scrutin_loi, "proposition de résolution") ~ "Proposition de résolution",
          stringr::str_detect(scrutin_loi, "déclaration du Gouvernement") ~ "Déclaration du Gouvernement",
          stringr::str_detect(scrutin_loi, "d[ée]claration de politique g[ée]n[ée]rale") ~ "Déclaration de politique générale",
        )
      )
    return(votes)
  }
  else {
    return(votes)
  }
}

#' Get detail of each mp for roll call
#'
#' @param api_url A character vector indicating the endpoint of the API
#' @param legislature The legislature number
#' @param vote_number The vote number
#'
#' @return A tibble
#' @export
#'
#' @examples get_vote_mps(legislature = "16", vote_number = "1")

get_vote_mps <- function(api_url = NULL, legislature = NULL, vote_number = NULL) {
  # Base URLs for legislatures (assuming similar structure as before)
  base_urls <- list(
    "15" = "2017-2022.nosdeputes.fr",
    "16" = "www.nosdeputes.fr"
  )

  # If api_url is provided, use it directly
  if (!is.null(api_url)) {
    url <- api_url
  } else if (!is.null(legislature) && !is.null(vote_number)) {
    # Check if the provided legislature is valid
    if (!legislature %in% names(base_urls)) {
      stop("Invalid legislature provided. Choose from '15', or '16'.")
    }
    base_url <- base_urls[[legislature]]
    # Construct the URL using the legislature and vote number
    url <- stringr::str_c("https://", base_url, "/", legislature, "/scrutin/", vote_number, "/csv")
  } else {
    stop("Please provide either the API URL or both the legislature and vote number.")
  }

  # Fetch the data from the constructed or provided URL
  vote_details <- readr::read_delim(url, show_col_types = FALSE)

  return(vote_details)
}

