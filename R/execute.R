execute <- function(cmd, ...) {
  
  if(nargs() != 1) stop("Execute requires an individual argument.")
  
  cmd.class <- try(expr = eval.parent(substitute(withTimeout(class(cmd), timeout = 0.5)))
                   ,silent = TRUE)
  if(class(cmd.class) == "character") {
    if(cmd.class == "character") {
      
      args.call <- match.call()
      
      
      cat("Execute as a script\n")
    }
    
    else { 
      cat("Execute as an expression\n")
    }
    
  } else {
    cat("Execute as an expression\n")
  }
  
}
  
  
  
  
#   ..., execute.string = NULL) {
#   
#   args.call <- match.call()
#   
#   if(missing(execute.string)) {
#     
#     if(nargs() < 1) return()
#     
#     if(nargs() >= 1) {
#       
#       args.list <- as.list(args.call)
#       for(i in 1:nargs()) {
#         execute.string.i = deparse(as.call(list(args.list[[1]], args.list[[i+1]])))
#         execute(args.list[[i+1]], execute.string = execute.string.i)
#       }
#     }
#   }
#   
#   else {
#     
#     
#     cat(paste("Executing call '", execute.string, "'", sep = "")
#     eval()
#     browser()
#   }
# }
# 
# execute(letters)