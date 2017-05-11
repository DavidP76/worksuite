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
  
  ## Determine the appropriate working directory folder
  log.folder = norm_path(log.folder)
  ## Check to see if the intended directory folder exists
  log.folder.dest = paste(log.folder
                          ,paste(format.Date(start.time, "%Y-%m-%d")
                                 ,tolower(log.title)
                                 ,sep = " ")
                          ,sep = "/")
  if(dir.exists(tolower(log.folder.dest))) {
    ## Rename the previous folder in this location
    prev.folder.ctime = file.info(log.folder.dest)$ctime
    if(is.na(prev.folder.ctime)) { prev.folder.ctime = "00:00:00" }
    else { prev.folder.ctime = format(prev.folder.ctime, "%H-%M-%S") }
    file.rename(from = log.folder.dest
                ,to = paste(log.folder.dest, " (", prev.folder.ctime, ")", sep = ""))
    log.folder.dest = paste(log.folder.dest, " (", format(start.time, "%H-%M-%S"), ")", sep = "")
  }
  ## Test to see if there are already multiple folders for the day
  
  dir.create(log.folder.dest)
  my.wd = c(log.folder.dest, my.wd)
  setwd(log.folder.dest)
  
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