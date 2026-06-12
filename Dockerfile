# ==========================================
# Stage 1: The Build Stage
# ==========================================
# Use an official Maven image with the required JDK version
FROM maven:3.9.6-eclipse-temurin-21  AS build

# Set the working directory inside the container
WORKDIR /build

# Copy ONLY the pom.xml first to leverage Docker layer caching
COPY pom.xml .

# Copy the actual application source code
COPY ./src ./src

# Compile and package the application into a JAR file
RUN mvn clean package -DskipTests

# ==========================================
# Stage 2: The Production Runtime Stage
# ==========================================
# Use a lightweight JRE or JDK image for the runtime environment
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# Copy the built JAR file from the builder stage
# Replace "my-app-1.0.0.jar" with the actual name generated in your target/ folder
COPY --from=build /build/target/*.jar app.jar

# Expose the application port (change 8080 if your app uses a different port)
EXPOSE 80

# Configure the container to execute the JAR file on startup
ENTRYPOINT ["java", "-jar", "app.jar"]
