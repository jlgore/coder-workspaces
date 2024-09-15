# Start from the Coder enterprise base image
FROM codercom/enterprise-base:ubuntu

# Use bash as the default shell
SHELL ["/bin/bash", "-c"]

USER root

# Install additional system packages
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    unzip \
    htop \
    jq \
    vim \
    tmux \
    sudo \
    python3 \
    python3-pip \
    nodejs \
    npm
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install

# Install Docker (for Docker-in-Docker scenarios, if needed)
RUN curl -fsSL https://get.docker.com | sh

# Add a non-root user (if not already present)
RUN sudo echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

# Set up a welcome message
RUN echo 'echo "Welcome to your custom Coder workspace!"' >> /etc/bash.bashrc

# Set the default user
USER coder

# Set the working directory
WORKDIR /home/coder

# You can add more customizations here, such as:
# - Cloning specific repositories
# - Setting up configuration files
# - Installing language-specific version managers (e.g., pyenv, nvm)
# - Adding custom scripts or tools

# Set the entrypoint to run your custom script and then execute the original entrypoint
ENTRYPOINT ["/bin/bash", "-c", "/home/coder/setup-workspace.sh && /coder/entry.sh"]
