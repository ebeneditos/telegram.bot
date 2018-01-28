
# Provide public token so it's easy for contributors to run tests on their local machine
token <- "532598148:AAEtazTsFqOXznfxWFaslPru-oZCI7EKR0E" # username: @RTelegramExtBot

skip_if_offline <- function(bot){
  
  res <- try(bot$getMe())
  
  if (inherits(res, 'try-error'))
    skip(attr(res, 'condition')$message)
}

# Handler function
foo_handler <- function(bot, update, ...){return(update)}

# Foo update
foo_update <- list(update_id = 0,
                   message = list(from_user = 'Tester',
                                  chat = list(id = 123456789),
                                  text = '/foo bar'))
# Foo callbackquery
foo_callbackquery <- list(update_id = 1,
                          callback_query = list(data = 'foo'))
