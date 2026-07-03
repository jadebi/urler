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
  m4

WORKDIR /urler

COPY ./src .
COPY ./entrypoint.sh /urler/entrypoint.sh
RUN chmod +x /urler/entrypoint.sh

RUN luarocks-5.4 install http --tree=lua_rocks
RUN luarocks-5.4 install lua-cjson --tree=lua_rocks
RUN luarocks-5.4 install lsqlite3 --tree=lua_rocks

# This image will run the actual code
# A small and minimal alpine image with only a few packages
FROM alpine

RUN apk add --no-cache \
  lua5.4 \
  libssl3 \
  libcrypto3 \
  sqlite-libs \
  su-exec

RUN adduser -D -h /urler urler 

WORKDIR /urler

# Copy over the nessesary files from the 'builder' container
COPY --from=builder /urler /urler

EXPOSE 8080

ENV LUA_PATH="/urler/lua_rocks/share/lua/5.4/?.lua;/urler/lua_rocks/share/lua/5.4/?/init.lua;;"
ENV LUA_CPATH="/urler/lua_rocks/lib/lua/5.4/?.so;;"

# Fallbacks (get applied in entrypoint.sh)
ENV FB_DATA_FOLDER="/urler/data"
ENV FB_BASE_URL="http://localhost"
ENV FB_LOG_FORMAT="text"

ENTRYPOINT [ "/urler/entrypoint.sh" ]

CMD ["lua5.4", "start.lua"]