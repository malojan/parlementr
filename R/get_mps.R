
#' Get members of parliament
#'
#' @param term A character vector with either "13", "14, "15" or "current"
#' @param type A character vector with either "all" or "current". Indicates whether we want only the current Mps of a legislature or all of them.
#'
#' @return A tibble.
#' @export
#'
#' @examples get_mps(c("13", "14"), "all")

get_mps <- function(term = c("current"), type = c("serving")) {
  # Define base URLs for different legislatures
  base_urls <- list(
    "13" = "2007-2012.nosdeputes.fr",
    "14" = "2012-2017.nosdeputes.fr",
    "15" = "2017-2022.nosdeputes.fr",
    "current" = "www.nosdeputes.fr"
  )

  # Ensure that the provided legislatures are valid
  if (any(!term %in% names(base_urls))) {
    stop("Invalid legislature provided. Choose from '13', '14', '15', or 'current'.")
  }

  # Function to fetch data based on the legislature
  fetch_data <- function(leg) {
    base_url <- base_urls[[leg]]

    if (type == "serving") {
      url <- stringr::str_c("https://", base_url, "/deputes/enmandat/csv")
    } else if (type == "all") {
      url <- stringr::str_c("https://", base_url, "/deputes/csv")
    } else {
      stop("Invalid type provided. Choose 'serving' or 'all'.")
    }

    return(
      readr::read_delim(url, col_select = - tidyselect::starts_with("..."), col_types = readr::cols()) |>
        dplyr::mutate(term = leg)
    )
  }

  # Use map_dfr to fetch data for each legislature and bind into a single tibble
  mps <- purrr::map_dfr(term, fetch_data)

  return(mps)
}

