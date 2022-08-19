local formatters = {
  "%score% %icon% %dir%%name%",
  "%size% %icon% %dir%%name%",
  "%access% %icon% %dir%%name%",
  "%mod% %icon% %dir%%name%",
  "%create% %icon% %dir%%name%",
  "%access_ago% %icon% %dir%%name%",
  "%mod_ago% %icon% %dir%%name%",
  "%create_ago% %icon% %dir%%name%",
}

local files = {
  "/home/nicholas/.profile",
  "/home/nicholas/bin/backlight.sh"
}

for _, file in pairs(files) do
  for _, formatter in pairs(formatters) do
    print(file, formatter)
  end
  -- stdout(prettyfile.pretty_path(line) .. '\n')
end
