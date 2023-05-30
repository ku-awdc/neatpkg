## Non-exported helper functions for working with R6 objects:

`%.%` <- function(env, obj){
  obj <- deparse(substitute(obj))
  if(!obj %in% eval(as.call(list(quote(ls), substitute(env))), envir = parent.frame())){
    stop(obj, " not found in the specified environment")
  }
  eval(as.call(list(quote(`[[`), substitute(env), obj)), envir = parent.frame())
}

`%.%<-` <- function(env, obj, value){
  eval(as.call(list(quote(`[[<-`), substitute(env), deparse(substitute(obj)), value)), envir = parent.frame())
}
