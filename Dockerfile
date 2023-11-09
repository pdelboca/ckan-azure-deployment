FROM ckan/ckan-base:2.10.1

COPY install-ckan-extensions.sh .
RUN ./install-ckan-extensions.sh

ARG SQLALCHEMY_URL
ARG CKAN_REDIS_URL
ARG SOLR_URL
ARG CKAN_SITE_URL

COPY setup-configuration-file.sh .
RUN ./setup-configuration-file.sh


# Optional: Use SSH support with custom Docker images
# Requires also to EXPOSE 2222 and run `service ssh start` in entrypoint
# COPY sshd_config /etc/ssh/
# RUN apk add openssh \
#     && echo "root:Docker!" | chpasswd \
#     && cd /etc/ssh/ \
#     && ssh-keygen -A


# We need to set the HOME variable to /home/ckan
# See:https://github.com/ckan/ckan-docker-base/issues/35
ARG HOME
ENV HOME=/home/ckan

RUN chown -R ckan:ckan /root/
