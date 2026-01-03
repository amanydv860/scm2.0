# -------------------------
# Build stage
# -------------------------
FROM eclipse-temurin:21-jdk-jammy AS builder
WORKDIR /app

# Copy Maven wrapper files FIRST (for caching)
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies (layer cache)
RUN chmod +x mvnw && ./mvnw dependency:go-offline

# Copy source code
COPY src ./src

# Build jar
RUN ./mvnw clean package -DskipTests

# -------------------------
# Runtime stage
# -------------------------
FROM gcr.io/distroless/java21-debian12
WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
