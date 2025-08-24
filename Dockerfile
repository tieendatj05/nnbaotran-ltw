# ---- Build WAR ----
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /src
COPY pom.xml .
COPY src ./src
RUN mvn -DskipTests package

# ---- Run on Tomcat ----
FROM tomcat:9.0-jdk17

# Tắt shutdown port để hết cảnh báo
RUN sed -ri 's/port="8005"/port="-1"/' $CATALINA_HOME/conf/server.xml

# Cho Connector nghe đúng PORT của Render
CMD sh -c "sed -ri 's/Connector port=\"[0-9]+\"/Connector port=\"'\"\${PORT}\"'/' $CATALINA_HOME/conf/server.xml && catalina.sh run"

# Deploy WAR thành ROOT.war
COPY --from=build /src/target/*.war $CATALINA_HOME/webapps/ROOT.war
