FROM jenkins/jenkins:lts
USER root

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    python3 \
    python3-pip \
    python3-venv \
    ansible \
    python3-docker \
    sshpass \
    openssh-client

# Install Docker CLI
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli

# Create virtual environment and install Python packages
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install docker ansible

# Create docker group and add jenkins user
RUN groupadd -g 999 docker || true && \
    usermod -aG docker jenkins

# Ensure proper permissions for Docker socket
RUN mkdir -p /var/run && \
    touch /var/run/docker.sock && \
    chmod 666 /var/run/docker.sock

USER jenkins
ENV PATH="/opt/venv/bin:${PATH}"