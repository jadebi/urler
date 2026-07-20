local cjson = require("cjson")
local ENV = require("utils.env")

-- cjson.encode_escape_slash(false)
cjson.encode_escape_forward_slash(false)

local Logger = {}

-- write directly to Docker stdout instead of OpenResty's error log
local function WriteOutput(Message)
  io.stdout:write(Message .. "\n")
  io.stdout:flush()
end

local function FormatContext(Context)
  if not Context then return "" end

  local Output = {}

  for Key, Value in pairs(Context) do
    table.insert(Output, Key .. "=" .. tostring(Value))
  end

  return "| " .. table.concat(Output, " | ")
end

local function WriteLogLine(InputLevel, InputMessage, InputContext)
  local LogEntry = {
    time = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    level = InputLevel,
    message = InputMessage,
    context = InputContext or nil
  }

  if ENV.LogFormat == "json" then
    WriteOutput(cjson.encode(LogEntry))

  elseif ENV.LogFormat == "text" then
    local ContextString = ""

    if InputContext then
      ContextString = FormatContext(LogEntry.context)
    end

    WriteOutput(string.format("[%s] [%s] %s %s",
      LogEntry.time,
      LogEntry.level,
      LogEntry.message,
      ContextString
    ))
  end
end


function Logger.info(Message, Context)
  WriteLogLine("INFO", Message, Context)
end

function Logger.warn(Message, Context)
  WriteLogLine("WARN", Message, Context)
end

function Logger.err(Message, Context)
  WriteLogLine("ERR ", Message, Context)
end

function Logger.fatal(Message, Context)
  WriteLogLine("FATAL", Message, Context)
end

function Logger.debug(Message, Context)
  if ENV.Debug then
    WriteLogLine("DEBUG", Message, Context)
  end
end

return Logger
