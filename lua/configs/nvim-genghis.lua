-- default config
require("genghis").setup({
  -- default is ` "trash" ` on Mac/Windows, and `{ "gio", "trash" }` on Linux
  icons = {
    chmodx = "󰒃",
    copyFile = "󱉥",
    copyPath = "󰅍",
    duplicate = "",
    file = "󰈔",
    move = "󰪹",
    new = "󰝒",
    nextFile = "󰖽",
    prevFile = "󰖿",
    rename = "󰑕",
    trash = "󰩹",
  },
  fileOperations = {
    trashCmd = "trash",
  },
  navigation = {
    ignoreExt = { "png", "svg", "webp", "jpg", "jpeg", "gif", "pdf", "zip" },
  },
  successNotifications = true,
})
-- .createNewFile: Create a new file.
-- .duplicateFile: Duplicate the current file.
-- .moveSelectionToNewFile: Prompts for a new file name and moves the current selection to that new file. (Note that this is a Visual Line mode command, the selection is moved linewise.)
-- .renameFile: Rename the current file.
-- .moveAndRenameFile: Move and Rename the current file. Keeps the old name if the new path ends with /. Works like the Unix mv command.
-- .moveToFolderInCwd: Move the current file to an existing folder in the current working directory.
-- .copyFilename: Copy the file name.
-- .copyFilepath: Copy the absolute file path.
-- .copyFilepathWithTilde: Copy the absolute file path, replacing the home directory with ~.
-- .copyRelativePath: Copy the relative file path.
-- .copyDirectoryPath: Copy the absolute directory path.
-- .copyRelativeDirectoryPath: Copy the relative directory path.
-- .chmodx: Makes current file executable. Equivalent to chmod +x.
-- .trashFile: Move the current file to the trash location.
vim.cmd.cabbrev("File Genghis")
vim.cmd.cabbrev("F Genghis")
vim.cmd.cabbrev("F Genghis")
vim.cmd.cabbrev("Chmodx Genghis chmodx")
vim.cmd.cabbrev("NewFile Genghis createNewFile")
vim.cmd.cabbrev("RenameFile Genghis moveAndRename")
vim.cmd.cabbrev("Fdupe Genghis duplicateFile")
vim.cmd.cabbrev("Fnew Genghis createNewFile")
vim.cmd.cabbrev("Fren Genghis moveAndRename")
vim.cmd.cabbrev("Fdel Genghis trashFile")
