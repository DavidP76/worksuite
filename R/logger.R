newLoggerWD <- function(folder.name = NULL
                      ,path.home = "\\\\pscfp0005.yyz.local\\David.Phillips\\Desktop\\Worksuite Scratchpad\\Logger" # "."
                      ,new.folder = TRUE
                      ,folder.timestamp = TRUE
                      ,folder.timestamp.format = "%F_%H%M"
                      ,folder.timestamp.timezone = "GMT"    ## Sys.timezone() for local, or perhaps US/Eastern, US/Central, US/Mountain,
                                                            ## or US/Pacific. GMT is preferred since it is not affected by locale or
                                                            ## daylight savings
                      ,rename.upon.error = TRUE) {

  ## Sense-check the arguments
  path.home <- try(normalizePath(path.home, mustWork = TRUE), silent = TRUE)
  if(class(path.home) == "try-error") stop("The system cannot find the designated logger parent folder")
  if(new.folder == TRUE && missing(folder.name)) stop("Logger arguments: new.folder == TRUE && missing(folder.name)")
  if(new.folder == FALSE && rename.upon.error == TRUE) stop("Logger arguments: new.folder == FALSE && rename.upon.error == TRUE")
  
  if(new.folder == FALSE) {
    ## Just return the given home path
    path <- normalizePath(path.home)
  }
  
  if(new.folder == TRUE) {
    timestamp <- ifelse(folder.timestamp
                       ,paste(format(as.POSIXlt(Sys.time(), folder.timestamp.timezone), format = folder.timestamp.format), " ", sep = "")
                       ,"")
    path = paste(path.home, "\\", timestamp, folder.name, sep = "")
    if(dir.exists(path)) {
      i <- 2
      while(dir.exists(paste(path, " (v", i, ")", sep = ""))) i <- i+1
      path = paste(path, " (v", i, ")", sep = "")
    }
    ## Create the new folder
    dir.create(path)
  }
  
  me <- list(path = path, rename.upon.error = rename.upon.error)
  class(me) <- append(class(me), "loggerWD")
  
  console.logger <- newLogger(mode = "console")
  me <- addLogger(me, console.logger, alias = "console")
  return(me)
  
}

newLogger <- function(mode) {
  return(NULL)
}

addLogger <- function(wd, logger, alias) {
  return(wd)
}