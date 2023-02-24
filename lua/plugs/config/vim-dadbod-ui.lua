-- :DB sqlite:myfile.sqlite3 select count(*) from widgets
-- :DB redis:/// CLIENT LIST
-- :%DB mysql://root@localhost/bazquux

-- let g:db_ui_env_variable_url = 'DATABASE_URL'
-- let g:db_ui_env_variable_name = 'DATABASE_NAME'

-- # .env
-- DB_UI_DEV=...          # becomes the `dev` connection
-- DB_UI_PRODUCTION=...   # becomes the `production` connection
-- let g:db_ui_dotenv_variable_prefix = 'MYPREFIX_'

vim.g.db_ui_save_location = vim.fn.getenv("HOME") .. "/.config/nvim/queries"
vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_force_echo_notifications = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_table_helpers = {
  postgresql = {
    List = "select * from {table} order by id asc",
    Count = "select count(*) from {optional_schema}{table}",
    Explain = "EXPLAIN ANALYZE {last_query}",
    TableCount = "SELECT table_schema, table_name, (xpath('/row/cnt/text()', xml_count))[1]::text::int as row_count FROM ( SELECT table_name, table_schema, query_to_xml(format('select count(*) as cnt from %I.%I', table_schema, table_name), false, true, '') AS xml_count FROM information_schema.tables WHERE table_schema = '$1' ORDER BY table_name) t",
    TableSize = "SELECT oid, table_schema, table_name, row_estimate , pg_size_pretty(index_bytes) AS INDEX , pg_size_pretty(toast_bytes) AS toast , pg_size_pretty(table_bytes) AS TABLE , pg_size_pretty(total_bytes) AS total FROM (SELECT *, total_bytes-index_bytes-COALESCE(toast_bytes,0) AS table_bytes FROM ( SELECT c.oid, nspname AS table_schema, relname AS table_name , c.reltuples AS row_estimate , pg_total_relation_size(c.oid) AS total_bytes , pg_indexes_size(c.oid) AS index_bytes , pg_total_relation_size(reltoastrelid) AS toast_bytes FROM pg_class c LEFT JOIN pg_namespace n ON n.oid = c.relnamespace WHERE relkind = 'r' AND nspname = '$1' ORDER BY total_bytes DESC) a) a"
  }
}
vim.g.dbs = {
  spadash_dev = "postgres://spadash:spadash@localhost:5432/spadash",
  spadash_local = "postgres://spadash:spadash@localhost:5432/spadash_local"
}

-- :DB mongodb:///test < big_query.js
