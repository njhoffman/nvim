local error1 = [[
E5113: Error while calling lua chunk: /home/nicholas/.config/nvim/lua/watcher/utils.lua:37: attempt to call method 'info' (a nil value)
stack traceback:
        /home/nicholas/.config/nvim/lua/watcher/utils.lua:37: in function 'clear_timers'
        lua/watcher/init.lua:7: in function 'setup'
        lua/watcher/init.lua:19: in main chunk
  ]]

local error2 = [[
E5112: Error while creating lua chunk: lua/scripts/notify-test.lua:80: 'end' expected (to close 'function' at line 50) near '<eof>'
  ]]

local error3 = [[
E5113: Error while calling lua chunk: lua/scripts/notify-test.lua:63: hey
stack traceback:
        [C]: in function 'error'
        lua/scripts/notify-test.lua:63: in function 'notify_error'
        lua/scripts/notify-test.lua:79: in function 'notify_test'
        lua/scripts/notify-test.lua:86: in main chunk
]]

return {
  error1, error2, error3
}
