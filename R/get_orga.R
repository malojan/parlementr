#' Retrieve Organisms Data from the French Parliament API
#'
#' This function fetches data about specified organisms (or "orgas") from the French Parliament API
#' based on given legislature terms and types.
#'
#' @param term A character vector specifying the legislature terms. Valid terms are '13', '14', '15', and '16'.
#' @param type A character vector specifying the types of the organisms. Default is 'groupe'.
#'
#' @return A tibble containing information about the organisms for the provided terms and types.
#' @export
#'
#' @examples
#' \dontrun{
#' terms_list <- c("15", "16")
#' types_list <- c("groupe", "extra")
#' all_orga <- get_orga(term = terms_list, type = types_list)
#' }
get_orga <- function(term, type = c("groupe")) {
  # Define base URLs for different legislatures
  base_urls <- list(
    "13" = "2007-2012.nosdeputes.fr",
    "14" = "2012-2017.nosdeputes.fr",
    "15" = "2017-2022.nosdeputes.fr",
    "16" = "www.nosdeputes.fr"
  )

  # Ensure that the provided legislatures are valid
  if (any(!term %in% names(base_urls))) {
    stop("Invalid legislature provided. Choose from '13', '14', '15', or '16'.")
  }

  # Ensure that the provided types are valid
  valid_types <- c("extra", "groupes", "groupe", "parlementaire")
  if (any(!type %in% valid_types)) {
    stop(paste("Invalid type provided. Choose from", paste(valid_types, collapse = ", "), "."))
  }

  # Function to fetch data based on the legislature and type
  fetch_data <- function(leg, t) {
    base_url <- base_urls[[leg]]
    url <- stringr::str_c("https://", base_url, "/organismes/", t, "/csv")

    # Fetch data for each legislature and type and bind into a single tibble
    return(
      readr::read_delim(
        url,
        col_select = -tidyselect::starts_with("..."),
        col_types = readr::cols(),
        name_repair = "unique_quiet"
      ) |>
        dplyr::mutate(term = leg, orga_type = t) |>
        dplyr::rename(orga_slug = slug)
    )
  }

  # Loop over each type and term to fetch data and combine
  data <- purrr::map_dfr(term, function(leg) {
    purrr::map_dfr(type, function(t) {
      fetch_data(leg, t)
    })
  })

  return(data)
}


#' Fetch Members of Organisms from the French Parliament API
#'
#' This function retrieves members of specified organisms (or "orgas") from the French Parliament API
#' for given legislatures and slugs.
#'
#' @param term A character vector specifying the legislature terms. Valid terms are '13', '14', '15', and '16'.
#' @param slug A character vector specifying the slugs of the organisms.
#' @param include_past A logical value. If TRUE and term is '15' or '16', the function will also fetch past members of the organisms.
#'
#' @return A tibble containing members for the provided terms and slugs.
#' @export
#'
#' @examples

#' all_members <- get_orga_members(term =c("15"), slug = c("democrate"), include_past = TRUE)

get_orga_members <- function(term, slug, include_past = FALSE) {
  # Define base URLs for different legislatures
  base_urls <- list(
    "13" = "2007-2012.nosdeputes.fr",
    "14" = "2012-2017.nosdeputes.fr",
    "15" = "2017-2022.nosdeputes.fr",
    "16" = "www.nosdeputes.fr"
  )

  # Fetch members based on a single term and slug
  fetch_data <- function(single_term, single_slug) {
    # Ensure that the provided legislature is valid
    if (!single_term %in% names(base_urls)) {
      stop("Invalid legislature provided. Choose from '13', '14', '15', or '16'.")
    }

    base_url <- base_urls[[single_term]]

    # Construct the URL using the provided slug
    url <- stringr::str_c("https://", base_url, "/organisme/", single_slug, "/csv")

    # Include past members if specified for term 15 or 16
    if (include_past && single_term %in% c("15", "16")) {
      url <- paste0(url, "?includePast=true")
    }

    # Fetch members' data from the constructed URL
    members_data <- readr::read_csv2(url, show_col_types = FALSE) |>
      select(term, orga_slug, slug, fonction)

    return(members_data)
  }

  # Loop over each combination of term and slug to fetch data and combine into a single tibble
  all_data <- purrr::map_dfr(term, function(t) {
    purrr::map_dfr(slug, function(s) {
      fetch_data(t, s)
    })
  })

  return(all_data)
}




