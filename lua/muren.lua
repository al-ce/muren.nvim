local M = {}

M.setup = function(opts)
  local options = require("muren.options")
  options.update(opts or {})

  local api = require("muren.api")
  local muren_commands = {
    MurenOpen = { api.open_ui, true },
    MurenClose = { api.close_ui, nil },
    MurenToggle = { api.toggle_ui, true },
    MurenFresh = { api.open_fresh_ui, true },
    MurenUnique = { api.open_unique_ui, true },
  }

  local anchor_positions = {
    "top",
    "bottom",
    "left",
    "right",
    "top_left",
    "top_right",
    "bottom_left",
    "bottom_right",
  }

  local create_muren_commands = function()
    for name, muren_cmd in pairs(muren_commands) do
      local muren_api, range = unpack(muren_cmd)
      vim.api.nvim_create_user_command(name, function(args)
        muren_api({ anchor = args.args })
      end, {
        nargs = "?",
        range = range,
        complete = function()
          return anchor_positions
        end,
      })
    end
  end

  if options.default.create_commands then
    create_muren_commands()
  end
end

return M
