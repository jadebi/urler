local cjson = require "cjson"

local testData = {
  Jane = { firstName = "Jane", lastName = "Doe", age = 25 },
  John = { firstName = "John", lastName = "Doe", age = 30 },
}

local handler = {}

function handler.list_people()
  ngx.header["Content-Type"] = "application/json"
  ngx.say(cjson.encode(testData))
end

function handler.get_person(name)
  ngx.header["Content-Type"] = "application/json"
  local person = testData[name]
  if person then
    ngx.say(cjson.encode(person))
  else
    ngx.status = 404
    ngx.say(cjson.encode({ error = "Person not found" }))
  end
end

function handler.submit()
  ngx.req.read_body()
  local body = ngx.req.get_body_data()
  ngx.header["Content-Type"] = "application/json"

  if body then
    local data = cjson.decode(body)
    ngx.say(cjson.encode({ status = "ok", received = data }))
  else
    ngx.status = 400
    ngx.say(cjson.encode({ error = "No body received" }))
  end
end

return handler
