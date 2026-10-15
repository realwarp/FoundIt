# Build stage: compile the existing non-Maven JSP/Servlet project.
FROM tomcat:10.1-jdk21-temurin AS build

WORKDIR /app

COPY src/ ./src/
COPY WebContent/ ./WebContent/

# Connector/J is intentionally downloaded here because the repository's
# .gitignore excludes JAR files under WebContent/WEB-INF/lib.
RUN mkdir -p WebContent/WEB-INF/lib
ADD https://repo.maven.apache.org/maven2/com/mysql/mysql-connector-j/9.5.0/mysql-connector-j-9.5.0.jar WebContent/WEB-INF/lib/mysql-connector-j-9.5.0.jar

# Compile all Java sources against Tomcat 10.1's Jakarta Servlet API.
RUN mkdir -p WebContent/WEB-INF/classes \
    && javac -encoding UTF-8 \
       -cp "/usr/local/tomcat/lib/servlet-api.jar:WebContent/WEB-INF/lib/*" \
       -d WebContent/WEB-INF/classes \
       $(find src -type f -name '*.java')

# Runtime stage: deploy the web application under /FoundIt.
FROM tomcat:10.1-jdk21-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /app/WebContent/ /usr/local/tomcat/webapps/FoundIt/

# Render injects PORT at runtime (commonly 10000); locally this defaults to 8080.
EXPOSE 10000

CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"\${PORT:-8080}\\\"/\" \"$CATALINA_HOME/conf/server.xml\" && exec catalina.sh run"]
