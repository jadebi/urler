local Validators = require("utils.validators")

local Variables = {}

local EnvVariables = {
  {
    VariableName = "DataFolder",
    EnvName = "DATA_FOLDER",
    Type = "string"
  },
  {
    VariableName = "BaseUrl",
    EnvName = "BASE_URL",
    Type = "url"
  },
  {
    VariableName = "Port",
    EnvName = "PORT",
    Type = "port"
  },
  {
    VariableName = "LogFormat",
    EnvName = "LOG_FORMAT",
    Type = "enum",
    Values = { "text", "json" }
  },
  {
    VariableName = "Debug",
    EnvName = "DEBUG",
    Type = "bool"
  }
}

local function errorMsg(message)
  io.stderr:write(message .. "\n")
  os.exit(1)
end

for _, Variable in ipairs(EnvVariables) do
  local Value = os.getenv(Variable.EnvName)

  if not Value then
    errorMsg(string.format("Environment variable '%s' is not set.", Variable.EnvName))
  end

  local Validator = Validators[Variable.Type]

  if not Validator then
    errorMsg(string.format("Unknown validator '%s'.", Variable.Type))
  end

  local Normalized, Error = Validator(Value, Variable)

  if not Normalized then
    errorMsg(string.format("Invalid value for '%s': %s", Variable.EnvName, Error))
  end

  Variables[Variable.VariableName] = Normalized
end

return Variables
