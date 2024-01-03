FROM debian:12.4

ARG CKAN_VERSION=ckan-2.10.3
ARG CKAN_SQLALCHEMY_URL
ARG CKAN_DATASTORE_WRITE_URL
ARG CKAN_REDIS_URL
ARG SOLR_URL
ARG CKAN_SITE_URL

# Install necessary packages to run CKAN
#  - git-core to allow installing from git
#  - libmagic1 is a dependency of python-magic, required by CKAN uploader
RUN apt-get update && apt-get install -y python3-dev python3-venv libpq-dev python3-pip git-core libmagic1

RUN mkdir -p /code
WORKDIR /code

# Create virtualenv for CKAN and activate it (add it to the PATH)
RUN /usr/bin/python3 -m venv /code/venv
ENV PATH="/code/venv/bin:$PATH"

COPY install-ckan.sh .
RUN ./install-ckan.sh

COPY install-ckan-extensions.sh .
RUN ./install-ckan-extensions.sh

COPY ckan.ini .
COPY setup-configuration-file.sh .
RUN ./setup-configuration-file.sh

COPY entrypoint.sh .

# Optional: Use SSH support with custom Docker images
# Requires also to EXPOSE 2222 and run `service ssh start` in entrypoint
# https://learn.microsoft.com/en-us/azure/app-service/configure-custom-container
RUN apt-get install -y --no-install-recommends dialog \
    && apt-get install -y --no-install-recommends openssh-server \
    && echo "root:Docker!" | chpasswd \
    && chmod u+x ./entrypoint.sh
COPY sshd_config /etc/ssh/

EXPOSE 80 2222

RUN pip install gunicorn
RUN cp /code/ckan/wsgi.py .
ENTRYPOINT [ "./entrypoint.sh" ]
