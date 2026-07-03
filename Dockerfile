FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests package

FROM tomcat:10.1-jdk17-temurin

ENV PORT=10000

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/EzBook-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 10000

CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT}\\\"/\" /usr/local/tomcat/conf/server.xml && catalina.sh run"]
