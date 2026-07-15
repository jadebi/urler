# This image will only be used for installing the dependencies and building them
# Useful for image size & performance optimization
FROM alpine AS builder

RUN apk add --no-cache \
  lua5.4 \
  lua5.4-dev \
  luarocks \
  musl-dev \
  openssl-dev \
  sqlite-dev \
  gcc \
  make \
  bsd-compat-headers \
  m4 \
  build-base \
  zlib-dev

WORKDIR /urler

RUN luarocks-5.4 install lua-cjson --tree=lua_rocks \
  && luarocks-5.4 install lsqlite3 --tree=lua_rocks \
  && luarocks-5.4 install pegasus --tree=lua_rocks

COPY ./entrypoint.sh /urler/entrypoint.sh
RUN chmod +x /urler/entrypoint.sh


# This image will run the actual code
FROM openresty/openresty:alpine

RUN apk add --no-cache \
  libssl3 \
  libcrypto3 \
  sqlite-libs \
  su-exec \
  curl \
  bash

WORKDIR /urler

RUN adduser -D -h /urler urler

EXPOSE 8080

# Lua paths for OpenResty (LuaJIT)
ENV LUA_PATH="/urler/?.lua;/urler/helpers/?.lua;;"
ENV LUA_CPATH=";;"

# Fallbacks (get applied in entrypoint.sh)
ENV DEFAULT_DATA_FOLDER="/urler/data"
ENV DEFAULT_BASE_URL="http://localhost"
ENV DEFAULT_PORT="8080"
ENV DEFAULT_LOG_FORMAT="text"
ENV DEFAULT_DEBUG="false"

# copy over the nessesary files from 'builder'
COPY --from=builder /urler/entrypoint.sh /urler/entrypoint.sh

# copy nginx config and source files
COPY ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY ./src .

RUN chown -R urler:urler /urler

ENTRYPOINT [ "/urler/entrypoint.sh" ]
CMD ["/usr/local/openresty/bin/openresty", "-e", "/urler/logs/error.log", "-g", "daemon off;"]
