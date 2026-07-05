local validators = {}

-- Okay, so I gotta be honest here...
-- I did not write the regexes myself... I copied them from different Stack Overflow threads
-- I'm so bad with regexes (especially this lua regex 😔), im sorry for copying...
-- A little cheatsheet so I actually know that they are doing in the future!
-- ^    | start of the string
-- %s*  | zero or more whitespace characters
-- (.-) | capture as few characters as possible
-- %s*  | zero or more whitespace characters
-- %w   | letters and digits
-- %-   | a literal '-'
-- %.   | a literal '.'
-- $    | end of the string

local function trim(value)
  return value:match("^%s*(.-)%s*$")
end

validators.string = function(value)
  value = trim(value)

  if value == "" then
    return nil, "must not be empty"
  end
  return value
end

validators.bool = function(value)
  value = trim(value):lower()

  if value == "true" then
    return true
  elseif value == "false" then
    return false
  end
  return nil, "must be 'true' or 'false'"
end

validators.number = function(value)
  value = trim(value)

  local number = tonumber(value)

  if not number then
    return nil, "must be a number"
  end
  return number
end

validators.url = function(value)
  value = trim(value)
  if value:match("^https://[%w%-%.]+") or
      value:match("^http://[%w%-%.]+") then
    return value
  end

  return nil, "must be a valid HTTP or HTTPS URL"
end

Validators.port = function(Value)
  Value = trim(Value)
  local number = tonumber(Value)

  if not number then -- has to be a number
    return nil, "must be a number"
  end
  if number % 1 ~= 0 then -- has to be a integer (no decimals)
    return nil, "must be a whole number"
  end
  if number >= 1 and number <= 65535 then -- has to be in the network port range (1-65535)
    return Value
  end

  return nil, "must be a valid port number (1-65535)"
end

Validators.enum = function(Value, Variable)
  Value = trim(Value):lower()

  for _, allowed in ipairs(Variable.Values) do
    if Value == allowed then
      return Value
    end
  end

  return nil, ("must be one of: %s"):format(table.concat(variable.values, ", "))
end

return validators
