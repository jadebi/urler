local log = require("logging")
local FallbackLogFormat = os.getenv("FB_LOG_FORMAT")

local utils = {}

-- function utils.FormatContext(Context)
--   if not Context then
--     return ""
--   end

--   local Output = {}

--   for Key, Value in pairs(Context) do
--     local FormattedValue = tostring(Value)

--     table.insert(Output, Key .. "'='" .. FormattedValue)
--   end

--   return " | '" .. table.concat(Output, "', '")
-- end

return utils
