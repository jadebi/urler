--local sqlite3 = require("lsqlite3")
local env = require("helpers.env")
local log = require("helpers.logging")
local utils = require("helpers.utils")

log.debug(env.DataFolder)
log.debug(env.Debug)
log.debug(env.BaseUrl)
log.debug(env.LogFormat)
log.info("Hello! This is a friendly log message 😜!", {
  script = "main.lua",
  meaning = "I have no idea...",
  number = 69
})

-- local UrlsDbFile = (os.getenv("DB_URLS_FILE") or "/urler/data/urls.db")

-- print(string.format("attempting to open the sqlite db (%s)...", UrlsDbFile))

-- UrlsDb = sqlite3.open(UrlsDbFile)

-- sql = [=[
--           CREATE TABLE numbers(num1,num2,str);
--           INSERT INTO numbers VALUES(1,11,"ABC");
--           INSERT INTO numbers VALUES(2,22,"DEF");
--           INSERT INTO numbers VALUES(3,33,"UVW");
--           INSERT INTO numbers VALUES(4,44,"XYZ");
--           SELECT * FROM numbers;
--         ]=]
-- function showrow(udata, cols, values, names)
--   assert(udata == 'test_udata')
--   print('exec:')
--   for i = 1, cols do
--     print('', names[i], values[i])
--   end
--   return 0
-- end

-- UrlsDb:exec(sql, showrow, 'test_udata')

-- print("closind the db now")
-- UrlsDb:close()
