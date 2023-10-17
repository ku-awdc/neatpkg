#' Add R6 support to a package
#'
#' @param package_name name of the package (optional)
#' @param directory working directory containing the package
#'
#' @import R6
#'
#' @export
pkg_R6 <- function(package_name, directory=getwd()){

  cwd <- getwd()
  setwd(directory)
  on.exit(setwd(cwd))

  ## If package_name is missing, then assume we are in the relevant directory:
  if(missing(package_name)){
    ff <- list.files(pattern=".Rproj$")
    if(length(ff)!=1L) stop("The specified directory does not appear to contain a valid R package")
    package_name <- gsub(".Rproj$", "", ff)
  }else{
    setwd(package_name)
  }

  ## Check this is a valid R package directory:
  if(!paste0(package_name, ".Rproj") %in% list.files()) stop("The specified package/directory does not appear to be a valid R package")

  ## Internal stuff:
  add_R6(document=TRUE)

  cat("Done!\n")

}

add_R6 <- function(document=TRUE){

  ## Add required template files:
  cat("Adding files...\n")
  copy_files <- list.files(system.file("templates", "R6", package="neatpkg"), recursive=TRUE)
  ss <- file.copy(file.path(system.file("templates", "R6", package="neatpkg"), copy_files), file.path(getwd(), copy_files), overwrite = TRUE)
  if(any(!ss)) stop("One or more file failed to copy - check write permissions?")

  ## Add required info to the DESCRIPTION file:
  cat("Modifying DESCRIPTION...\n")
  desc <- readLines("DESCRIPTION")
  if(!any(grepl("R6", desc))){
    wi <- which(grepl("Imports:", desc))
    stopifnot(length(wi)==1L)
    desc <- c(desc[1:wi], "  R6,", desc[-(1:wi)])
  }
  if(!any(grepl("neatpkg", desc))){
    ws <- which(grepl("Suggests:", desc))
    if(length(ws)==0L){
      desc <- c(desc, "Suggests:", "  neatpkg")
    }else{
      stopifnot(length(ws)==1L)
      desc <- c(desc[1:ws], "  neatpkg,", desc[-(1:ws)])
    }
    desc <- c(desc, "Additional_repositories:  https://ku-awdc.github.io/drat/")
  }
  ro <- which(grepl("Roxygen:", desc))
  stopifnot(length(ro)==1L)
  desc[ro] <- "Roxygen: list(markdown = TRUE, r6 = FALSE)"
  writeLines(desc, "DESCRIPTION")

  ## Run document:
  if(document){
    cat("Running roxygen...\n")
    document(roclets=c("rd", "collate", "namespace"))
  }

}
