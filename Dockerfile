
FROM maven:3.9.9-eclipse-temurin-21

WORKDIR /app

# Install Chromium and Chromium Driver
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    chromium-driver \
    && rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN=/usr/bin/chromium

# Copy Maven configuration
COPY pom.xml .

# Download dependencies
RUN mvn dependency:resolve

# Copy project source code
COPY . .

# Run Selenium tests
CMD ["mvn", "clean", "test"]
