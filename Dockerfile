# ---------- Stage 1: Build ----------
FROM eclipse-temurin:17-jdk-jammy AS build

WORKDIR /app

# Copy wrapper and pom first (better layer caching)
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline -B

# Now copy the rest of the source
COPY src src

# Build the jar (skip tests to speed up image build)
RUN ./mvnw clean package -DskipTests -B

# ---------- Stage 2: Run ----------
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Copy only the built jar from the build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
