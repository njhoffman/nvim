The histories subproject is now a submodule of the main project. I will outline the layout and the main features of the
project eventually, but for now, I want a one-off task to explore the behavior of extmarks.  Create a keymap that binds
to 'space' in visual mode to add an extmark with a start and end position the same as the visual selection.  There will
only be three of these extmark ranges active at a time, old ones are removed when a new one is added.  The range
highlights will also be updated to reflect the following order:

1st: #300000 (most recent)
2nd: #003060
3rd: #004c36

Create a command 'ExtInfo' that prints out the info about the extmarks.
Create a command 'ExtClear' that removes these three extmarks.

Disregard the other functionality of the histories subproject for now.
