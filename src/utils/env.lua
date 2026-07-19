local validators = require("utils.validators")

local variables = {}

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

for _, variable in ipairs(EnvVariables) do
  local Value = os.getenv(variable.EnvName)

  if not Value then
    error(string.format("Environment variable '%s' is not set.", variable.EnvName))
  end

  local Validator = validators[variable.Type]

  if not Validator then
    error(string.format("Unknown validator '%s'.", variable.Type))
  end

  local Normalized, Error = Validator(Value, variable)

  if not Normalized then
    error(string.format("Invalid value for '%s': %s", variable.EnvName, Error))
  end

  variables[variable.VariableName] = Normalized
end

return variables
