#' An example R6 class
#'
#'
#' @importFrom R6 R6Class
#'
#' @export
ExampleR6 <- R6Class("ExampleR6")

ExampleR6$set("public", "initialize",
              function(){
                "Initialize method"

                browser()
              }
)

m <- function(what, env = quote(self)){

  eval(as.call(list(quote(ls), env, all.names=TRUE)), envir=parent.frame())
  browser()

}

`m<-` <- function(what, value, env = quote(self)){
  #wn <- deparse(substitute(what))
  browser()
  substitute(what)
}

#e$t <- FALSE
#m("vt", env=e) <- TRUE

`%.%` <- function(env, obj) {
  obj <- deparse(substitute(obj))
  if(!obj %in% eval(as.call(list(quote(ls), substitute(env))), envir = parent.frame())){
    stop(obj, " not found in the specified environment")
  }
  if(!member %in% ls) stop(member, " is not a member of this R6 class")
  eval(as.call(list(quote(`[[`), substitute(env), obj)), envir = parent.frame())
}

`%.%<-` <- function(env, obj, val) {
  eval(as.call(list(quote(`[[<-`), substitute(env), deparse(substitute(obj)), value)), envir = parent.frame())
}

if(FALSE){
  all <- eval(as.call(list(quote(ls), substitute(env), all.names=TRUE)),
              envir = parent.frame())
  if(!".__enclos_env__" %in% all) stop("Not an R6 class")
  prvt <- eval(as.call(list(quote(ls), substitute(env$.__enclos_env__$private))),
               envir = parent.frame())
}


#e <- new.env()
#e %.% t <- TRUE
#e %.% t

ExampleR6$set("private", "ptestval", 1L)
ExampleR6$set("public", "testval", 1L)
ExampleR6$set("active", "actestval", function() 1L)

ExampleR6$set("private", "get",
              function(what, where=c("public","private","active")){
                "Private helper method to get objects"


              }
)

ExampleR6$set("public", "test",
              function(){
                "Initialize method"

                browser()

                get(t, env=quote(self))

                tv <- self %.% testval
                # self %.% actestval <- 9
                private %.% ptestval <- 9

                self %.% testval <- 9

                browser()

                selfie(hi)

                return(tv)
              }
)

ee <- ExampleR6$new()

ee$test()
