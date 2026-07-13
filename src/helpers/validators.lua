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

local function trim(Value)
  return Value:match("^%s*(.-)%s*$")
end

validators.string = function(Value)
  Value = trim(Value)

  if Value == "" then
    return nil, "must not be empty"
  end
  return Value
end

validators.bool = function(Value)
  Value = trim(Value):lower()

  if Value == "true" then
    return true
  elseif Value == "false" then
    return false
  end
  return nil, "must be 'true' or 'false'"
end

validators.number = function(Value)
  Value = trim(Value)

  local number = tonumber(Value)

  if not number then
    return nil, "must be a number"
  end
  return number
end

validators.url = function(Value)
  Value = trim(Value)
  if Value:match("^https://[%w%-%.]+") or
      Value:match("^http://[%w%-%.]+") then
    return Value
  end

  return nil, "must be a valid HTTP or HTTPS URL"
end

validators.port = function(Value)
  Value = trim(Value)
  local Number = tonumber(Value)

  if not Number then -- has to be a number
    return nil, "must be a number"
  end
  if Number % 1 ~= 0 then -- has to be a integer (no decimals)
    return nil, "must be a whole number"
  end
  if Number >= 1 and Number <= 65535 then -- has to be in the network port range (1-65535)
    return Value
  end

  return nil, "must be a valid port number (1-65535)"
end

validators.enum = function(Value, Variable)
  Value = trim(Value):lower()

  for _, Allowed in ipairs(Variable.Values) do
    if Value == Allowed then
      return Value
    end
  end

  return nil, ("must be one of: %s"):format(table.concat(Variable.values, ", "))
end

return validators
