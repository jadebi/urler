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

RUN luarocks-5.4 install lua-cjson --tree=lua_rocks && \
  luarocks-5.4 install lsqlite3 --tree=lua_rocks && \
  luarocks-5.4 install pegasus --tree=lua_rocks

COPY ./entrypoint.sh /urler/entrypoint.sh
RUN chmod +x /urler/entrypoint.sh


# This image will run the actual code
# A small and minimal alpine image with only a few packages
FROM alpine

RUN apk add --no-cache \
  lua5.4 \
  libssl3 \
  libcrypto3 \
  sqlite-libs \
  su-exec

WORKDIR /urler

RUN adduser -D -h /urler urler 

EXPOSE 8080

# custom lua paths because we install the rocks in the 
# working directory instead of globally.
ENV LUA_PATH="/urler/lua_rocks/share/lua/5.4/?.lua;/urler/lua_rocks/share/lua/5.4/?/init.lua;/urler/helpers/?.lua;;"
ENV LUA_CPATH="/urler/lua_rocks/lib/lua/5.4/?.so;;"

# Fallbacks (get applied in entrypoint.sh)
ENV DEFAULT_DATA_FOLDER="/urler/data"
ENV DEFAULT_BASE_URL="http://localhost"
ENV DEFAULT_PORT="8080"
ENV DEFAULT_LOG_FORMAT="text"
ENV DEFAULT_DEBUG="false"

# copy over the nessesary files from the 'builder' container
COPY --from=builder /urler /urler

# we copy the source files in prod because we dont actually
# need them in build and this way we can improve build
# speeds even more! 
COPY ./src .

ENTRYPOINT [ "/urler/entrypoint.sh" ]

CMD ["lua5.4", "main.lua"]