FROM maven:3.6.3-jdk-8 AS build-env

COPY pom.xml ./

FROM openjdk:8-jre-alpine
EXPOSE 8090
WORKDIR /spring-petclinic/

COPY /target/*.jar ./petclinic.jar
CMD ["/usr/bin/java", "-jar", "./petclinic.jar", "--server.port=8090"]
