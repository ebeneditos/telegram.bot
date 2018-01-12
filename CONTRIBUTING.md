# How to contribute

I'm really grateful that you're reading this, it is because of the generous help from contributors that open source projects like this one can come to fruition.
To make participation as pleasant as possible, please review our [Code of Conduct](https://github.com/ebeneditos/telegram.ext/blob/master/CODE_OF_CONDUCT.md).

## Submitting changes

Please send a [GitHub Pull Request to telegram.ext](https://github.com/ebeneditos/telegram.ext/pull/new/master) with a clear list of what you've done (read more about [pull requests](http://help.github.com/pull-requests/)). Please follow our [coding conventions](CONTRIBUTING.md#coding-conventions) and make sure all of your commits are atomic (one feature per commit).

Always write a clear log message for your commits. One-line messages are fine for small changes, but bigger changes should look like this:

    $ git commit -m "A brief summary of the commit
    > 
    > A paragraph describing what changed and its impact."

## Coding conventions

Start reading our code and you'll get the hang of it. We optimize for readability:

  * For Telegram methods and variables, use [Telegram Bot API](http://core.telegram.org/bots/api) nomenclature.
  * Set intuitive variable names.
  * Follow the structure of the already done work.
  * Put spaces after list items and method parameters (`c(1, 2, 3)`, not `c(1,2,3)`), around operators (`x + 1`, not `x+1`), and when assigning them (`y <- 1` or `y = 1`; not `y<-1` or `y=1`).
  * This is open source project. Consider the people who will read your code, and make it look nice for them.

Thanks!
