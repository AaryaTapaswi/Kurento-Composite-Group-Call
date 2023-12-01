FROM maven:3.9.5-ibm-semeru-17-focal AS builder
WORKDIR /app
COPY . .
RUN mvn package

# Use an official OpenJDK image as the runtime stage
FROM openjdk:22-slim-bullseye

# Set the working directory
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=builder /app/target/app.jar .

# Expose the port your application is listening on
EXPOSE 8000

# Set environment variables for JVM options
ENV JAVA_OPTS="-Dkms.url=ws://kms-server3.pune.cdac.in:8888/kurento"

# Run your application with CMD
CMD ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]

