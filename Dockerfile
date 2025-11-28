FROM mongo:7.0.16

# Install awscli (v2) from Debian packages
RUN apt-get update && \
    apt-get install -y curl unzip groff less && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /var/lib/apt/lists/* /tmp/aws /tmp/awscliv2.zip

# Optional: show versions at build time
RUN mongo --version && aws --version
