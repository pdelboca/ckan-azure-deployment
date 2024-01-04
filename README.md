# Deploying CKAN in Azure

This repository documents some steps and considerations when deploying CKAN to an Azure Infrastructure using the official [ckan-docker-base](https://github.com/ckan/ckan-docker-base) image.

## Basic Services required
 - App Service for Solr
 - App Service for CKAN
 - Redis Instance
 - PostgreSQL
 - Container Registry to push images

## Notes on deploying
 - All containers needs to set `WEBSITES_PORT` variable in Configuration to set the listening port (`5000`).
 - We need to set up the CKAN_INI file at BUILD time, when creating the docker container.
 - SSH needs to be built in the Dockerfile https://learn.microsoft.com/en-us/azure/app-service/configure-custom-container?tabs=alpine&pivots=container-linux
 - In basic quick deployments, make sure to set `redirect_after_login` configuration so it does not redirect to localhost.
 - Adding `?sslmode=require` to the `SQLALCHEMY_URL` is required
 - Redis requires authentication, so URL config needs to have it. (check variables structure section)

## Basic Steps
#### Resource Creation
 - Create a resource group
 - Create a container registry.
 - Create an Azure Cache for Redis.
 - Create an Azure Database for Postgresql.
 - Create a Web App for Contaniers for Solr pointing to Docker Hub `ckan/ckan-solr:2.10`.
 - Create an Azure Storage

#### Resource Configuration
 - Go to the Solr App -> Add WEBSITES_PORT=8983 to the configuration and restart the app.
 - Go to the Container Registry -> Access Keys and allow Admin user so we can push our CKAN Dockerfile
 - Go to the Azure Database -> Create a database called `ckan`
 - Go to the Azure Storage -> Create a File Share (here CKAN will store all uploaded data and assets)

#### Deployment and Main App Configuration
 - Connect to the Container Registry (See Quick Start in Azure Portal for instructions).
 - Build locally the image in this Repository using `--build-arg` (See Basic variable structure in this README)
   - Having an image in ACR is a requirement to create an Azure Web App. We will set the `CKAN_SITE_URL` with the value that it is going to have later.
 - Push the image to the ACR
 - Create a Web App using the image pushed to the ACR container
 - Go to the newly created Web App -> Configuration -> Path mappings, and mount the Azure Storage File Share as a directory (example: `/storage`)
   - You must ensure that `ckan.storage_path` configuration option points to this mounted directory



## Basic variables Structure when Building the image
    docker build . \
        --build-arg CKAN_SQLALCHEMY_URL='postgresql://<user>:<pass>@<name>.postgres.database.azure.com/ckan?sslmode=require' \
        --build-arg SOLR_URL='https://<name>.azurewebsites.net/solr/ckan' \
        --build-arg CKAN_REDIS_URL='rediss://default:<pass>@<name>.redis.cache.windows.net:6380' \
        --build-arg CKAN_SITE_URL='https://<name>.azurewebsites.net'
        -t myckan:latest

Notes:
 - Double `s` in `rediss` is not a typo, is for Secure Connections
 - Get Redis password from Azure Portal
 - Get Postgres user and password from the portal as well


## Tutorials and Materials
- https://learn.microsoft.com/en-us/azure/container-apps/
- https://learn.microsoft.com/en-us/azure/app-service/configure-connect-to-azure-storage
- https://learn.microsoft.com/en-us/azure/app-service/configure-custom-container
