# FROM openjdk:21-alpine
# WORKDIR /app
# COPY dist/scm2.0-0.0.1-SNAPSHOT.jar app/scm2.0-0.0.1-SNAPSHOT.jar

# EXPOSE 8080

# ENTRYPOINT ["java", "-jar", "app/scm2.0-0.0.1-SNAPSHOT.jar"]


# Use a lightweight OpenJDK runtime
FROM eclipse-temurin:21-jdk-jammy AS builder
WORKDIR /app
COPY dist/scm2.0-0.0.1-SNAPSHOT.jar app.jar

# FROM eclipse-temurin:21-jre-jammy
# use distroless for a smaller image
FROM gcr.io/distroless/java:21   
WORKDIR /app
COPY --from=builder /app/app.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]