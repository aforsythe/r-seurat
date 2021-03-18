project_template <- function(proj) {

  # Require usethis
  require(usethis)

  # Create a project
  usethis::create_project(proj, open=FALSE)

  # Create directory structure
  root = paste0("./", proj)
  dir.create(paste0(root, "/data/original"), recursive = TRUE)
  dir.create(paste0(root, "/data/clean"), recursive = TRUE)
  dir.create(paste0(root, "/scripts/functions"), recursive = TRUE)
  dir.create(paste0(root, "/results/figures"), recursive = TRUE)
  dir.create(paste0(root, "/results/data"), recursive = TRUE)
  dir.create(paste0(root, "/rmarkdown/reports"), recursive=TRUE)
  dir.create(paste0(root, "/rmarkdown/presentations"), recursive=TRUE)


  # Setup git
  setwd(root)
  use_git_ignore(c('*.Rproj', '.gitignore', '.Rdata', '.Rhistory', '.DS_Store'), directory = ".")
  usethis::use_git()

  # Open project
  usethis::proj_activate('.')

}
