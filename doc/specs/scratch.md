## Silence command

We will come back to this, but for now let's move the silence command in `lua/configs/noice/commands.lua` to my commands folder, add clean up and add tests like the
other commands have.  Include checks before accessing plugin state or commands. Basically 'Silence' should turn off
noice, clear the message history, and close all popup windows while routing the error messages to not be seen.

```
