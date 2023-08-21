#' Get members of parliament
#'
#' @param term A character vector with either "13", "14, "15" or "current"
#' @param type A character vector with either "all" or "current". Indicates whether we want only the current Mps of a legislature or all of them.
#' @param detail A boolean operator indicating whether to add additional data. Can take a few minutes in that case.
#' @return A tibble.
#' @export
#'
#' @examples get_mps(c("13", "14"), "all")
get_mps <-
  function(term = c("current"),
           type = c("serving"),
           detail = FALSE) {
    # Define base URLs for different legislatures
    base_urls <- list(
      "13" = "2007-2012.nosdeputes.fr",
      "14" = "2012-2017.nosdeputes.fr",
      "15" = "2017-2022.nosdeputes.fr",
      "16" = "www.nosdeputes.fr"
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
        readr::read_delim(
          url,
          col_select = -tidyselect::starts_with("..."),
          col_types = readr::cols(),
          name_repair = "unique_quiet"
        ) |>
          dplyr::mutate(term = leg,
                        num_circo = dplyr::case_when(
                        stringr::str_length(num_circo) == 1 ~ paste0("0", num_circo),
                        TRUE ~ as.character(num_circo)))
      )
    }

    # Use map_dfr to fetch data for each legislature and bind into a single tibble
    mps <- purrr::map_dfr(term, fetch_data)

    if (detail == TRUE) {
      fetch_detail <- function(slug, leg) {
        cat("Retrieving ", leg, "-", slug, "\n")
        base_url <- base_urls[[leg]] # Get the base URL for the given legislature
        url <- stringr::str_c("https://", base_url, "/", slug, "/csv")
        return(readr::read_delim(url, col_types = readr::cols(), show_col_types = FALSE, name_repair = "unique_quiet"))
      }

      # Fetch additional details for each slug
      details_list <- purrr::map2(mps$slug, mps$term, fetch_detail)
    }
    return(mps)
  }

