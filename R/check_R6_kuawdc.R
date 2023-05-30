#' Check compliance of an R6 class specification according to KU-AWDC standards
#'
#' @param Class an R6 class to check
#'
#' @import R6
#'
#' @export
check_R6_kuawdc <- function(Class){

  # Check the class is locked:
  stopifnot(Class$is_locked())

  # Check there are no public fields (that aren't active bindings):
  stopifnot(is.null(Class$public_fields))

  invisible(TRUE)

}
