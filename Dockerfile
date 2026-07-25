FROM openresty/openresty:1.31-alpine-fat AS builder

WORKDIR /urler

RUN /usr/local/openresty/luajit/bin/luarocks install lua-cjson
RUN apk add --no-cache sqlite-dev && /usr/local/openresty/luajit/bin/luarocks install lsqlite3

COPY ./init.sh ./generate_config.sh /urler/
RUN chmod +x /urler/init.sh /urler/generate_config.sh



FROM openresty/openresty:1.31-alpine-slim

WORKDIR /urler

RUN mkdir tmp logs data

RUN adduser -D -h /urler urler

RUN apk add --no-cache \
  sqlite-libs \
  gettext-envsubst \
  bash \
  su-exec

COPY ./src /urler

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
# RUN chown -R urler:urler /usr/local/openresty/nginx/logs

# COPY ./urler.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY ./src/nginx.conf.template /urler/nginx.conf.template

# Fallbacks (get applied in init.sh)
ENV DEFAULT_DATA_FOLDER="/urler/data"
ENV DEFAULT_BASE_URL="http://localhost"
ENV DEFAULT_PORT="8080"
ENV DEFAULT_LOG_FORMAT="text"
ENV DEFAULT_DEBUG="false"

ENV LUA_PATH="/urler/?.lua;/urler/helpers/?.lua;;"
ENV LUA_CPATH=";;"

EXPOSE 8080

ENTRYPOINT [ "/urler/init.sh" ]
CMD ["/usr/local/openresty/bin/openresty", "-e", "/urler/logs/error.log", "-g", "daemon off;"]
