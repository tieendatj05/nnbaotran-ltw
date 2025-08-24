# ---- Build WAR ----
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /src
COPY pom.xml .
COPY src ./src
RUN mvn -DskipTests package

# ---- Run on Tomcat ----
FROM tomcat:9.0-jdk17

# Dùng server.xml tự quản (đã tắt shutdown, có placeholder __PORT__)
COPY conf/server.xml $CATALINA_HOME/conf/server.xml

# Deploy WAR thành ROOT
COPY --from=build /src/target/*.war $CATALINA_HOME/webapps/ROOT.war

# Thay __PORT__ = $PORT rồi chạy Tomcat
CMD sh -c "sed -i 's/__PORT__/'\"${PORT}\"'/g' $CATALINA_HOME/conf/server.xml && catalina.sh run"
