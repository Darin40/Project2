FROM tomcat:latest
MAINTAINER Darin <darindaflin2011@gmail.com>
EXPOSE 8080
COPY ../target/maven-web-app.war /usr/local/tomcat/webapps/maven-web-app.war
