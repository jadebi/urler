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

validators.enum = function(value, variable)
  value = trim(value):lower()

  for _, allowed in ipairs(variable.values) do
    if value == allowed then
      return value
    end
  end

  return nil, ("must be one of: %s"):format(table.concat(variable.values, ", "))
end

return validators
