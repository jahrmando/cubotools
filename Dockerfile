FROM debian:12-slim

WORKDIR /tmp/

RUN apt-get update

# Install MongoDB tools
RUN apt-get install gnupg curl unzip -y
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
RUN echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/7.0 main" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
RUN apt-get update && \ 
      apt-get install -y mongodb-org-tools

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip 
RUN ./aws/install

ENV AWS_DEFAULT_REGION=us-east-1
ENV AWS_DEFAULT_OUTPUT=json

RUN addgroup --system --gid 1001 runner
RUN adduser --system --uid 1001 runner --ingroup runner

#Extra tools
RUN apt-get install -y netcat-openbsd

# Create app directory
WORKDIR /opt/workspace
RUN chown runner:runner /opt/workspace

# Install app dependencies
COPY --chown=runner:runner files/mongo-backup.sh /usr/local/sbin/
RUN chmod +x /usr/local/sbin/mongo-backup.sh

USER runner
