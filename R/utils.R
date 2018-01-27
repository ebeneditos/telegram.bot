
self    <- 'For R CMD CHECK'
private <- 'For R CMD CHECK'

not_implemented <- function() stop('Currently not implemented')

check_stop <- function(error){
  return(attr(error, 'condition')$message == "Operation was aborted by an application callback")
}

check_file <- function(path, required = FALSE){
  if (file.exists(path))
    path
  else {
    if (required) stop(path, ' is not a valid path')
    else NULL
  }
}

method_summaries <- function(meth, indent = 0){
  wrap_at <- 72 - indent
  meth_string <- paste(meth, collapse = ", ")
  indent(strwrap(meth_string, width = wrap_at), indent)
}

indent <- function(str, indent = 0) {
  gsub("(^|\\n)(?!$)",
       paste0("\\1", paste(rep(" ", indent), collapse = "")),
       str,
       perl = TRUE
  )
}