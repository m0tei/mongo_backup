# Use the official MongoDB image as the base image
FROM mongo:latest

# Install cron and required utilities
RUN apt-get update && apt-get -y install cron && apt-get install curl -y  && apt-get install vim -y && apt-get install -y gettext-base

##############################################################################################

# Download Duplicacy binary
RUN curl -LO https://github.com/gilbertchen/duplicacy/releases/download/v3.2.3/duplicacy_linux_x64_3.2.3

# Move Duplicacy binary to /usr/local/bin and make it executable
RUN mv duplicacy_linux_x64_3.2.3 /usr/local/bin/duplicacy && \
    chmod +x /usr/local/bin/duplicacy

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add directory containing Duplicacy binary to PATH
ENV PATH="/usr/local/bin:${PATH}"

##############################################################################################

# Create a directory for backup files
RUN mkdir -p /backup

# Copy the script that performs mongodump into the container
COPY mongodump_script.sh /mongodump_script.sh
COPY replace.sh /replace.sh

# Give execute permission to the script
RUN chmod +x /mongodump_script.sh
RUN chmod +x /replace.sh

# Create a cron job for mongodump
RUN echo "0 0 * * * /bin/bash /mongodump_script.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/mongodump-cron

RUN chmod 0644 /etc/cron.d/mongodump-cron

RUN touch /var/log/cron.log

RUN crontab /etc/cron.d/mongodump-cron

# Run the cron job in the foreground
CMD /replace.sh && cron && tail -f /var/log/cron.log
