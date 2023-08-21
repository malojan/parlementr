
get_mps <- function(legislature = c("current"), type) {
  # Define base URLs for different legislatures
  base_urls <- list(
    "13" = "2007-2012.nosdeputes.fr",
    "14" = "2012-2017.nosdeputes.fr",
    "15" = "2017-2022.nosdeputes.fr",
    "current" = "www.nosdeputes.fr"
  )

  # Ensure that the provided legislatures are valid
  if (any(!legislature %in% names(base_urls))) {
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
      readr::read_delim(url, col_select = - starts_with("..."), col_types = readr::cols()) |>
        dplyr::mutate(legislature = leg)
    )
  }

  # Use map_dfr to fetch data for each legislature and bind into a single tibble
  mps <- purrr::map_dfr(legislature, fetch_data)

  return(mps)
}
