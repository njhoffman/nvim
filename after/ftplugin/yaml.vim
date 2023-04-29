" Turn off syntax highlighting for large YAML files.
if line('$') > 2000
  setlocal syntax=OFF
endif
