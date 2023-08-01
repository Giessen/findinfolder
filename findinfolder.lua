VERSION = "0.1.0"

local strings = import("strings")
local micro = import("micro")
local config = import("micro/config")
local buffer = import("micro/buffer")
local shell = import("micro/shell")

function  findinfolder(bp)
  local command = "bash -c \"rg --no-ignore-parent --iglob='!.git' -.n . | fzf --layout=reverse  --color=dark --preview='echo -n {} | cut -d':' -f1 | xargs -r bat --style=numbers --color=always'| cut -d':' -f1\""
  local output, err = shell.RunInteractiveShell(command, false, true)
  if err ~= nil or output == "" then
    micro.InfoBar():Error(output)
  else
    findOutput(output, bp)
  end
end

function findOutput(output, bp)
  output = strings.TrimSpace(output)
  if output ~= "" and output ~= nil then
    local buf, err = buffer.NewBufferFromFile(output)
    if err == nil then
      bp:OpenBuffer(buf)
    end
  end
end

function init()
    config.MakeCommand("findinfolder", findinfolder, config.NoComplete)
    config.TryBindKey("Alt-f", "lua:findinfolder.findinfolder", false)
end

