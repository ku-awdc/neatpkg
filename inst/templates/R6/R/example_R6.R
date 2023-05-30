#' An example R6 class
#'
#' @param value an initialisation value
#' @param new_value a new value to use
#'
#' @importFrom R6 R6Class
#'
#' @examples
#' example_instance <- ExampleR6$new(value = 1L)
#' example_instance
#' example_instance$value <- 2L
#' example_instance$value
#'
#' @export
ExampleR6 <- R6Class("ExampleR6")

# A private field:
ExampleR6$set("private", "m_value", numeric())

# Public initialize method:
ExampleR6$set("public", "initialize",
  function(value){
    private %.% m_value <- value
  }
)

# Public print method:
ExampleR6$set("public", "print",
    function(){
      cat("An ExampleR6 class with value ", private %.% m_value, "\n", sep="")
      invisible(self)
  }
)

# Active binding:
ExampleR6$set("active", "value",
    function(new_value){
      # To get a value:
      if(missing(new_value)) return(private %.% m_value)

      # To set a value:
      private %.% m_value <- new_value
    }
)

# Lock the class when you are done:
ExampleR6$lock()
