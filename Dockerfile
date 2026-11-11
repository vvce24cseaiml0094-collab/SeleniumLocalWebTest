
FROM maven:3.9.9-eclipse-temurin-21

WORKDIR /app

# Install dependencies required for Chrome
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    ca-certificates \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
       | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg \
    && chmod 644 /etc/apt/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" \
       > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Copy Maven project
COPY pom.xml .

# Download Maven dependencies
RUN mvn dependency:resolve

# Copy remaining project files
COPY . .

# Run Selenium tests
CMD ["mvn", "clean", "test"]
