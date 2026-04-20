# Start with the official Jenkins image
FROM jenkins/jenkins:lts

# Switch to the root user to install things
USER root

# Install Node.js 18 and Docker CLI
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs docker.io

# Install the AI CLI
RUN npm i -g @openai/codex

# Drop back to the safe Jenkins user
USER jenkins