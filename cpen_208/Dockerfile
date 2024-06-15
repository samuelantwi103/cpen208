FROM openjdk:21
VOLUME /tmp
EXPOSE 8001
COPY target/cpen_208-0.0.1-SNAPSHOT.jar cpen_208-0.0.1-SNAPSHOT.jar
ENTRYPOINT [ "java", "-jar", "cpen_208_api.jar" ]