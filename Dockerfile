ARG OPENRESTY_VER=1.31

# FAT builder image
FROM openresty/openresty:${OPENRESTY_VER}-alpine-fat AS builder

WORKDIR /urler

# Installing LuaJIT luarocks
RUN /usr/local/openresty/luajit/bin/luarocks install lua-cjson && \
  apk add --no-cache sqlite-dev && \
  /usr/local/openresty/luajit/bin/luarocks install lsqlite3

# Making the "init.sh" and "generate_config.sh" executable
COPY ./init.sh ./generate_config.sh /urler/
RUN chmod +x /urler/init.sh /urler/generate_config.sh


# light image that runs urler
FROM openresty/openresty:${OPENRESTY_VER}-alpine-slim

WORKDIR /urler

# create locked down user for urler execution
RUN adduser -D -h /urler urler

# add required packages
RUN apk add --no-cache \
  sqlite-libs \
  gettext-envsubst \
  bash \
  su-exec

# copy all source code
COPY ./src /urler
COPY ./frontend /urler/frontend

# copy luarocks and init scripts
COPY --from=builder \
  /usr/local/openresty/luajit/lib/lua/5.1/ \
  /usr/local/openresty/luajit/lib/lua/5.1/
COPY --from=builder \
  /usr/local/openresty/luajit/share/lua/5.1/ \
  /usr/local/openresty/luajit/share/lua/5.1/

COPY --from=builder \
  /urler/init.sh \
  /urler/generate_config.sh \
  /urler/

RUN chown -R urler:urler /urler

# defining variable fallbacks (get applied in init.sh)
ENV DEFAULT_DATA_FOLDER="/urler/data"
ENV DEFAULT_BASE_URL="http://localhost"
ENV DEFAULT_PORT="8080"
ENV DEFAULT_LOG_FORMAT="text"
ENV DEFAULT_DEBUG="false"

EXPOSE 8080

# start the init script with CMD as a arg
ENTRYPOINT [ "/urler/init.sh" ]
CMD ["/usr/local/openresty/bin/openresty", "-e", "/urler/logs/error.log", "-g", "daemon off;"]
