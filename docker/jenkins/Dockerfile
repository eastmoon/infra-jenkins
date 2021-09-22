FROM jenkins/jenkins:lts-jdk11

# Using root user
USER root

# Install common library
RUN \
    apt-get update && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates curl gnupg2 \
        software-properties-common

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce-cli

# Using jenkins user
USER jenkins

# Install docker plugin
RUN jenkins-plugin-cli --plugins "blueocean:1.25.0 docker-workflow:1.26"
