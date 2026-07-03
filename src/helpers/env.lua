local Validators = require("helpers.validators")

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

for _, Variable in ipairs(EnvVariables) do
  local Value = os.getenv(Variable.EnvName)

  if not Value then
    error(("Environment variable '%s' is not set."):format(Variable.EnvName))
  end

  local Validator = Validators[Variable.Type]

  if not Validator then
    error(("Unknown validator '%s'."):format(Variable.Type))
  end

  local Normalized, Error = Validator(Value, Variable)

  if not Normalized then
    error(("Invalid value for '%s': %s"):format(Variable.EnvName, Error))
  end

  Variables[Variable.VariableName] = Normalized
end

return Variables
