-- Runs after the runtime markdown ftplugin (which sets formatoptions+=tcqln)
require("modules.markdown.prose").attach(0)
require("modules.markdown.codeblocks").attach(0)
