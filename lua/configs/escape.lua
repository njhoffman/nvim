-- eiw -> escape in word

require("mapper").map({ "n", "v" }, "<leader>e", require("escape").escape, { desc = "escape" })
