worksuite_execute <- function(file
                              ,folder = NULL
                              ,log.title = "ad hoc"
                              ,log.folder = localize(tag = "Logs Folder")[[1]]
                              ,script.events = NULL
                              ,my.wd = NULL) {
  ## Execute the given file of R code with logging and error handling
  
  start.time = Sys.time()
  
  ## Construct working directory
  if(length(my.wd) == 0) my.wd = getwd()
  else my.wd = c(getwd(), my.wd)
  
  browser()
  
  ## Determine the appropriate working directory folder
  my.wd = get_output_folder(log.title, log.folder, start.time)
  browser()
  ## Establish error handler
  ## Establish logger
  
  ## Execute code
  if(!is.null(folder)) { file = paste(folder, file, sep = "/") }
  file = normalizePath(file, winslash = "/")
  source(file)
  
  ## Evaluate success
  ## Conclude the logger
  
  setwd(my.wd[2])
  my.wd = my.wd[-1]
  
}