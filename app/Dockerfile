FROM nginx:1.27-alpine

# Свой конфиг вместо дефолтного
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/app.conf

# Статика
COPY static/ /usr/share/nginx/html/

EXPOSE 80

# healthcheck на уровне образа
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost/healthz || exit 1
