FROM amazeeio/nginx:latest

# nginx config.
COPY satis.conf /etc/nginx/satis.conf
RUN fix-permissions /etc/nginx

COPY app/ /app/
