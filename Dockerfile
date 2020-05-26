FROM ubuntu
RUN apt-get update \
    && apt-get install -y nginx vim
COPY app/main/templates/index.html /var/www/html/
EXPOSE 80
CMD ["nginx","-g","daemon off;"]