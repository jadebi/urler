local cjson = require("cjson")
local ENV = require("helpers.env")
-- local utils = require("helpers.utils")
-- Uncommenting the 'require utils' will produce a Stack Overflow!
-- Wow, why did I get so excited the first time I got this error 🤣?

local logger = {}

-- dont judge me please... i know, i know...
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
    Time = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    Level = InputLevel,
    Message = InputMessage,
    Context = InputContext or nil
  }

  if ENV.LogFormat == "json" then
    print(cjson.encode(LogEntry))
  elseif ENV.LogFormat == "text" then
    if InputContext then
      ContextString = FormatContext(LogEntry.Context)
    else
      ContextString = ""
    end

    print(string.format("[%s] [%s] %s %s",
      LogEntry.Time,
      LogEntry.Level,
      LogEntry.Message,
      ContextString
    ))
  end
end


function logger.info(Message, Context)
  WriteLogLine("INFO", Message, Context)
end

function logger.warn(Message, Context)
  WriteLogLine("WARN", Message, Context)
end

function logger.err(Message, Context)
  WriteLogLine("ERR ", Message, Context)
end

function logger.fatal(Message, Context)
  WriteLogLine("FATAL", Message, Context)
end

function logger.debug(Message, Context)
  if ENV.Debug then
    WriteLogLine("DEBUG", Message, Context)
  end
end

return logger
