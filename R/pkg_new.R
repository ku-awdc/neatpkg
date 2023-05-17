#' Create a new R package
#'
#' @param package_name the name of the package to create
#' @param directory the GitHub directory containing the package
#'
#' @importFrom usethis proj_activate
#' @importFrom devtools document
#'
#' @export
pkg_new <- function(package_name, directory=getwd()){

  startwd <- getwd()
  on.exit( setwd(startwd) )

  if(!dir.exists(directory)) stop("Invalid directory provided: '", directory, "'")
  setwd(directory)

  if(!dir.exists(package_name)) stop("A folder with the specified package_name ('", package_name, "') was not found in the specified directory ('", directory, "')")
  setwd(package_name)
  if(!file.exists("README.md")){
    warning("No README.md was found in the specified directory, so one has been created. Next time remember to generate this file when creating a new repository on GitHub!")
    cat("# ", package_name, "\nAdd a description of what your package does here\n", sep="", file="README.md")
  }

  copy_files <- system.file("template", package="neatpkg") |> list.files(include.dirs=TRUE)

  ff <- list.files(all.files=FALSE)
  if(length(ff)!=1L || ff!="README.md"){
    cf <- c(copy_files, paste0(package_name, ".Rproj"))
    if(any(file.exists(cf) | dir.exists(cf))){
      stop("Unable to create package due to pre-existing files/folders that would be over-written:\n", paste(cf[file.exists(cf) | dir.exists(cf)], collapse=", "))
    }
    warning("Unexpected files/folders were detected in the package directory:\n", paste(ff[ff!="README.md"], collapse=", "), "\nThe package will be created, but you may get warnings from R CMD check due to these unexpected files/folders")
  }

  cat("Creating package structure for '", package_name, "'...\n")

  copy_files <- c(system.file("template", package="neatpkg") |> list.files(include.dirs=TRUE), ".gitignore", ".Rbuildignore")
  # Temporarily exclude data and data-raw:
  copy_files <- copy_files[!copy_files %in% c("data","data-raw")]

  ss <- file.copy(file.path(system.file("template", package="neatpkg"), copy_files), getwd(), recursive = TRUE)
  if(any(!ss)) stop("One or more file failed to copy - check write permissions?")

  cat("Adding package name...\n")

  desc <- readLines("DESCRIPTION")
  desc[1] <- paste0("Package: ", package_name)
  desc[4] <- paste0("Date: ", as.character(Sys.Date()))
  writeLines(desc, "DESCRIPTION")

  file.rename("template.Rproj", paste0(package_name, ".Rproj"))

  rpkg <- readLines("R/template-package.R")
  rpkg <- gsub("template",package_name,rpkg)
  writeLines(rpkg, "R/template-package.R")
  file.rename("R/template-package.R", paste0("R/", package_name, "-package.R"))

  test <- readLines("tests/testthat.R")
  test[10] <- paste0('library("', package_name, '")')
  test[12] <- paste0('test_check("', package_name, '")')
  writeLines(test, "tests/testthat.R")

  vig <- readLines("vignettes/template.Rmd")
  vig[2] <- paste0('title: "', package_name, '"')
  vig[18] <- paste0('library("', package_name, '")')
  writeLines(vig, "vignettes/template.Rmd")
  file.rename("vignettes/template.Rmd", paste0("vignettes/", package_name, ".Rmd"))

  rbi <- readLines(".Rbuildignore")
  rbi <- gsub("template", package_name, rbi)
  writeLines(rbi, ".Rbuildignore")

  cat("Running roxygen...\n")
  document(roclets=c("rd", "collate", "namespace"))

  cat("Done!\n")

  proj_activate(getwd())

}
