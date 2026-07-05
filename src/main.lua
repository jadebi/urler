-- local sqlite3 = require("lsqlite3")
-- local utils = require("helpers.utils")
local ENV = require("helpers.env")
local log = require("helpers.logging")
local utils = require("helpers.utils")

local Pegasus = require "pegasus"
local Files = require "pegasus.plugins.files"
local Router = require "pegasus.plugins.router"
local cjson = require "cjson"
-- local TLS = require "pegasus.plugins.tls"

-- example data for the "router" plugin
local routes
do
  local testData = {
    Jane = { firstName = "Jane", lastName = "Doe", age = 25 },
    John = { firstName = "John", lastName = "Doe", age = 30 },
  }

  routes = {
    -- router-level preFunction runs before the method prefunction and callback
    preFunction = function(req, resp)
      local headers = req:headers()
      log.info("GET", headers)
      log.info("Request", req)
      log.info("Response", resp.headers)
    end,

    ["/people"] = {
      GET = function(req, resp)
        resp:statusCode(200)
        resp:addHeader("Content-Type", "application/json")
        resp:write(cjson.encode(testData))
      end,
    },

    ["/people/{name}"] = {
      -- callback per method
      GET = function(req, resp)
        resp:statusCode(200)
        resp:addHeader("Content-Type", "application/json")
        resp:write(cjson.encode(testData[req.pathParameters.name]))
      end,
    }
  }
end

local server = Pegasus:new({
  port = "8080",
  plugins = {
    Files:new {
      location = "./www/",
    },
    Router:new {
      prefix = "",
      routes = routes,
    },
  }
})

server:start()

-- local UrlsDbFile = (os.getenv("DB_URLS_FILE") or "/urler/data/urls.db")

-- print(string.format("attempting to open the sqlite db (%s)...", UrlsDbFile))

-- UrlsDb = sqlite3.open(UrlsDbFile)

-- sql = [=[
-- CREATE TABLE numbers(num1,num2,str);
-- INSERT INTO numbers VALUES(1,11,"ABC");
-- INSERT INTO numbers VALUES(2,22,"DEF");
-- INSERT INTO numbers VALUES(3,33,"UVW");
-- INSERT INTO numbers VALUES(4,44,"XYZ");
-- SELECT * FROM numbers;
-- ]=]
-- function showrow(udata, cols, values, names)
-- assert(udata == "test_udata")
-- print("exec:")
-- for i = 1, cols do
-- print("", names[i], values[i])
-- end
-- return 0
-- end

-- UrlsDb:exec(sql, showrow, "test_udata")

-- print("closind the db now")
-- UrlsDb:close()
