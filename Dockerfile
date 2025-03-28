# Use official OpenJDK base image
FROM openjdk:11-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file built by Maven
COPY target/hello-world-java-1.0-SNAPSHOT.jar app.jar

# Expose port 8080 for the application
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
