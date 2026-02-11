create_data_project <- function(path, 
                                author = NULL,
                                description = NULL,
                                license = "MIT",
                                use_renv = TRUE,
                                use_targets = FALSE,
                                create_rproj = TRUE) {
  
  # Create main directory
  usethis::create_project(path, rstudio = create_rproj, open = FALSE)
  
  # Set up directory structure
  withr::with_dir(path, {
    dirs <- c("data", "data/raw", "data/processed", "R", "reports", 
              "reports/figures", "models", "notebooks")
    
    for (dir in dirs) {
      usethis::use_directory(dir)
      file.create(file.path(dir, ".gitkeep"))
    }
    
    
    # Initialize renv if requested
    if (use_renv) {
      renv::init()
    }
    
    # Set up targets if requested
    if (use_targets) {
      targets::use_targets()
    }
    
    # Add license
    if (license != "None") {
      usethis::use_mit_license(copyright_holder = if(is.null(author)) "Author" else author)
    }
    
    # Create basic README with setup instructions
    readme_content <- paste0("# ", basename(path), "\n\n",
                             "## Getting Started\n\n",
                             "### 1. Clone this repository\n",
                             "```bash\n",
                             "git clone <repository-url>\n",
                             "cd ", basename(path), "\n",
                             "```\n\n",
                             "### 2. Set up R environment\n",
                             "- Open `", basename(path), ".Rproj` in RStudio\n",
                             "- Run: `renv::restore()` (this installs all required packages)\n\n",
                             "### 3. Initialize project data\n",
                             "- Run: `source('R/load_data.R')`\n\n",
                             "You're ready to go!")
    
    writeLines(readme_content, "README.md")
    
    
    ## Create load_data.R starter file  
    writeLines(c(
      "# Data loading script",
      "# Add your data loading code here"
    ), "R/load_data.R")
  })
  
  invisible(path)
}