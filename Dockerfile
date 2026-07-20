FROM openresty/openresty:alpine-fat AS builder

WORKDIR /urler

RUN /usr/local/openresty/luajit/bin/luarocks install lua-cjson
RUN apk add --no-cache sqlite-dev && /usr/local/openresty/luajit/bin/luarocks install lsqlite3

COPY ./init.sh /urler/init.sh
RUN chmod +x /urler/init.sh


FROM openresty/openresty:alpine

WORKDIR /urler
RUN mkdir tmp logs data

RUN adduser -D -h /urler urler
RUN apk add --no-cache sqlite-dev bash su-exec

COPY ./src /urler

COPY --from=builder /usr/local/openresty/luajit/lib/luarocks/rocks-5.1/ \
  /usr/local/openresty/luajit/lib/luarocks/rocks-5.1/
COPY --from=builder /urler/init.sh /urler/init.sh

RUN chown -R urler:urler /urler
# RUN chown -R urler:urler /usr/local/openresty/nginx/logs

COPY urler.conf /usr/local/openresty/nginx/conf/nginx.conf

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
