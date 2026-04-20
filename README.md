docker build -t my-custom-jenkins:v1 .
docker run -d --name demo1 -p 8080:8080 my-custom-jenkins:v1