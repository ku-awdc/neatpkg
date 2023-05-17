#' An example function
#'
#' @param optional_argument an argument with a default value
#'
#' @examples
#' # Some example code:
#' example_function()
#'
#' @export
example_function <- function(optional_argument = 42L){

  # Internal functions are visible within your package code:
  df <- example_internal(optional_argument)

  return(df)
}
