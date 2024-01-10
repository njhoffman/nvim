package = 'devdocs'
version = 'dev-1'
source = {
   url = '*** please add URL for source tarball, zip or repository here ***',
}
description = {
   homepage = '*** please enter a project homepage ***',
   license = '*** please specify a license ***',
}
build = {
   type = 'none',
   install = {
      bin = {
         ['list'] = 'bin/list.lua',
      },
      lua = {
         ['bin.list'] = 'bin/list.lua',
         ['devdocs.config'] = 'devdocs/config.lua',
         ['devdocs.utils'] = 'devdocs/utils.lua',
      },
   },
}
