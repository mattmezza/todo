todo
===

`todo` is a utility for quickly keep track of your todos without leaving the comfort of your terminal.


Installation
===

Installing `todo` is very easy: you just need to clone this very same repo at the latest release and then source the `todo.sh` file in your bash profile. Here's how I do it in my [dotfiles](https://github.com/mattmezza/dotfiles).


Usage
===

What follows is the output of `todo help`, accessible at any time.

```
Usage:
  todo [CMD] [WHAT] [WHEN]

CMD can be:
  'add|a' to add element to list
  'remove|rm' to remove an element from a list
  'view|v' to print the list on stdout
  'left|l' to print the items left to do for WHEN
  'did' to print the items already did for WHEN
  'done|d' or undone|u to mark or unmark the item as done
  'carry-on|co moves yesterday's undone items to today's list
  'help|h' prints this message
If no command is passed, 'view' is assumed.

WHEN can be:
  today|t
  tomorrow|tomo|tm
  yesterday|y
  a temporal interaval referred to today's date (e.g. +2d, -2d etc...).
When CMD is 'view', it can also be a string matching the format '%Y-%m-%d' to list all the items in different days. If no WHEN is passed, 'today' is assumed.

Examples:
$ todo add 'Buy milk'
$ todo rm 'Buy milk'
$ todo view tomorrow
$ todo view 2019-11
$ todo left today
$ todo did yesterday
$ todo done 'Buy milk' yesterday
$ todo undone|u 'Buy milk' yesterday
$ todo carry-on
```

#### todo carry-on

This command takes all the items for today that are not marked as done, and carries them over to tomorrow's todo list (I am a bloody procrastinator).


Development
===

Developing `todo` is quite easy. Clone the repo and start editing the `todo.sh` file. You can always source your verions and test it in your shell.
