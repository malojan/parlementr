

get_activity <- function(term = "16") {
  # Define base URLs for different legislatures
  # Only legislature 15 and 16 are available for roll_call
  base_urls <- list(
    "13" = "2007-2012.nosdeputes.fr",
    "14" = "2012-2017.nosdeputes.fr",
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
    url <- stringr::str_c("https://", base_url, "/synthese/data/csv")

    return(
      readr::read_delim(url, show_col_types = FALSE) |>
        dplyr::mutate(term = leg)
    )
  }

  activity <- purrr::map_dfr(term, fetch_data)
}
