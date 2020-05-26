# Web Application Project

## Docker Build & Run Commands
````shell script
docker build -t nginx .
docker run -d -p 8080:80 nginx
````

## Test the Site with Curl
````shell script
curl localhost:8080
````