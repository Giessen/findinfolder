VERSION = "1.1.1"

local strings = import("strings")
local micro = import("micro")
local config = import("micro/config")
local buffer = import("micro/buffer")
local shell = import("micro/shell")

function  findInFolder(bp, mode)
  local command = "sh -c \"rg --no-ignore-parent --color='always' --iglob='!.git' -.n .|fzf -x +i -n 2 --ansi --prompt='Find >' --layout=reverse --color=dark --preview='echo -n {}|cut -d':' -f1|xargs -r bat -f --style=numbers,changes,grid'|cut -d':' -f1,2\""
  local output, err = shell.RunInteractiveShell(command, false, true)
  if err ~= nil or output == "" then
    micro.InfoBar():Error(output)
  else
    findOutput(bp, output, mode)
  end
end

function findOutput(bp, output, mode)
  output = strings.Split(strings.TrimSpace(output), ':')

  local filename, linenumber = output[1], tonumber(output[2]) or 1

  if output ~= "" and output ~= nil then
    local buf, err = buffer.NewBufferFromFile(filename)

    if err ~= nil then
      micro.InfoBar():Error(err)
    else
      openBuf(bp, buf, mode, linenumber)
    end
  end
end

function openBuf(bp, buf, mode, linenumber)
  if mode == 0 then
    bp:OpenBuffer(buf)
  elseif mode == 1 then
    bp = bp:HSplitBuf(buf)
  elseif mode == 2 then
    bp = bp:VSplitBuf(buf)
  elseif mode == 3 then
    bp:NewTabCmd({buf.AbsPath})
    bp = micro.CurPane()
  end

  bp.Cursor.Y = linenumber - 1
  bp:StartOfText()
end

function init()
    config.MakeCommand("fif", function(bp) findInFolder(bp, 0) end, config.NoComplete)
    config.MakeCommand("fifh", function(bp) findInFolder(bp, 1) end, config.NoComplete)
    config.MakeCommand("fifv", function(bp) findInFolder(bp, 2) end, config.NoComplete)
    config.MakeCommand("fift", function(bp) findInFolder(bp, 3) end, config.NoComplete)

    local overwrite = false

    config.TryBindKey("Alt-f", "command:fif", overwrite)
    config.TryBindKey("Alt-h", "command:fifh", overwrite)
    config.TryBindKey("Alt-v", "command:fifv", overwrite)
    config.TryBindKey("Alt-t", "command:fift", overwrite)
end
