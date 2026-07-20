local cjson = require("cjson.safe")
local random = require("resty.random")
local log = require("utils.logging")

local ffi = require("ffi")

ffi.cdef[[
typedef struct {
    long tv_sec;
    long tv_nsec;
} struct_timespec;

int clock_gettime(int clk_id, struct_timespec *tp);
]]

local CLOCK_MONOTONIC = 1

local function monotonic_time()
    local ts = ffi.new("struct_timespec")
    ffi.C.clock_gettime(CLOCK_MONOTONIC, ts)
    return tonumber(ts.tv_sec) + tonumber(ts.tv_nsec) / 1e9
end

local t0 = monotonic_time()

ngx.req.read_body()
local body = ngx.req.get_body_data()
if not body then
  ngx.status = ngx.HTTP_BAD_REQUEST
  log.info("missing body")
  return
end

local data, err = cjson.decode(body)

if not data then
  ngx.status = ngx.HTTP_BAD_REQUEST
  log.info(string.format("invalid json: %s", err or "unknown error"))
  return
end

local url = data.url

log.info(string.format("URL: %s", url))
local CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local CHARS_LEN = #CHARS

local function random_code(length)
  local bytes = random.bytes(length, true)
  if not bytes then
    return nil, "failed to generate random bytes"
  end

  local out = {}

  for i = 1, length do
    local index = (bytes:byte(i) % CHARS_LEN) + 1
    out[i] = CHARS:sub(index, index)
  end

  return table.concat(out)
end

local code, err = random_code(8)

if not code then
  ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
  ngx.header.content_type = "application/json"

  ngx.say(cjson.encode({error = err}))

  return
end

local dt = monotonic_time() - t0

ngx.say(cjson.encode({
  duration = dt,
  code = code
}))
