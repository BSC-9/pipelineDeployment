# Base Image
FROM openjdk:11-jre-slim

# Copy the built jar file
COPY target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "/app.jar"]
