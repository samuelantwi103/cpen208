FROM openjdk:21
VOLUME /tmp
EXPOSE 8001
COPY target/cpen_208_api.jar cpen_208_api.jar
ENTRYPOINT [ "java", "-jar", "cpen_208_api.jar" ]