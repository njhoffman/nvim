vim.g.table_mode_always_active = false
vim.g.table_mode_disable_mappings = false
vim.g.table_mode_disable_tableize_mappings = false
vim.g.table_mode_map_verbose = true
vim.g.table_mode_tableize_map = "<Leader>T"

-- *table-mode-mappings-prefix*
-- <Leader>t	This is a prefix defined by the option |table-mode-map-prefix|
-- 		used before all other table mode commands.

-- *table-mode-mappings-toggle*
-- <Leader>tm	Toggle table mode for the current buffer. You can change this
-- 		using the |toggle-mode-options-toggle-map| option.

--                 NOTE This is applicable only if |table-mode-always-active| is
--                 not set.

-- *table-mode-mappings-trigger*
-- |		Trigger table creation in table mode. You can change this
-- 		using the |toggle-mode-options-separator| option.

-- <Leader>tt	Triggers |table-mode-commands-tableize| on the visually
-- 		selected content.

-- *table-mode-mappings-op-trigger*
-- <Leader>T	Triggers |table-mode-commands-tableize| on the visually
-- 		selected asking for user to input the delimiter.

-- 						*table-mode-mappings-realign*
-- <Leader>tr	Realigns table columns

-- <Leader>t?      Echo the current table cells representation for defining
--                 formulas.

-- *table-mode-mappings-motions*
-- [|              Move to previous cell
-- ]|              Move to next cell
-- {|              Move to the cell above
-- }|              Move to the cell below

--                                               *table-mode-mappings-delete-row*
-- <Leader>tdd	Delete the entire table row you are on or multiple rows using
-- 		a [count]. You can change this using |table-mode-delete-row-map|
-- 		option.

-- *table-mode-mappings-delete-column*
-- <Leader>tdc	Delete entire table column you are within. You can preceed it
-- 		with a [count] to delete multiple columns to the right. You
-- 		can change this using |table-mode-delete-column-map| option.

-- *table-mode-mappings-insert-column-before*
-- <Leader>tiC	Insert a table column before the column you are within. You can
-- 		preceed it with a [count] to insert multiple columns. You can
-- 		change this using |table-mode-insert-column-before-map| option.

-- *table-mode-mappings-insert-column-after*
-- <Leader>tic	Insert a table column after the column you are within. You can
-- 		preceed it with a [count] to insert multiple columns. You can
-- 		change this using |table-mode-insert-column-after-map| option.

-- *table-mode-mappings-add-formula*
-- <Leader>tfa	Add a fomula for the current table cell. This invokes
-- 		|TableAddFormula| command.

-- *table-mode-mappings-evaluate-formula-line*
-- <Leader>tfe	Evaluate the formula line which is a commented line right
-- 		after the table beginning with 'tmf:'. If one exists this
-- 		would evaluate the formula line and update the table
-- 		accordingly. This invokes the |TableEvalFormulaLine| command.

-- *table-mode-mappings-sort-column*
-- <Leader>ts      Sort a column under the cursor. This invokes |TableSort|

-- ||              Expands to a header border. You can change this by changing
--                 |table-mode-separator| option. You can change the character to
--                 be used for the extreme corners of the border by changing
--                 |table-mode-corner-corner| option.
-- use i|, a| for inner and around text objects

-- Enter the first line, delimiting columns by the | symbol. The plugin reacts by inserting spaces between the text and the separator if you omit them:

-- | name | address | phone |
-- In the second line (without leaving Insert mode), enter | twice. The plugin will write a properly formatted horizontal line:

-- | name | address | phone |
-- |------+---------+-------|

-- Go on until the table is ready:

-- | name            | address                  | phone      |
-- |-----------------+--------------------------+------------|
-- | John Adams      | 1600 Pennsylvania Avenue | 0123456789 |
-- |-----------------+--------------------------+------------|
-- | Sherlock Holmes | 221B Baker Street        | 0987654321 |
-- |-----------------+--------------------------+------------|
-- Then you can return to the first line and above it enter ||:
--
-- Use ":" for alignment
