# Starting CKAN requires a ckan.ini file.
# The ckan.ini file is created by the ckan-docker-base but in this script we will
# setup the ckan.ini file with the correct values for our instance.

ckan config-tool ${CKAN_INI} "SECRET_KEY=pepe"
ckan config-tool ${CKAN_INI} "beaker.session.secret=g5qXJbukfPqsDekI-3APT1beQh8"
ckan config-tool ${CKAN_INI} "ckan.plugins = activity harvest ckan_harvester image_view datatables_view"

ckan config-tool ${CKAN_INI} "sqlalchemy.url = ${SQLALCHEMY_URL}"
ckan config-tool ${CKAN_INI} "ckan.redis.url = ${CKAN_REDIS_URL}"
ckan config-tool ${CKAN_INI} "solr_url = ${SOLR_URL}"
ckan config-tool ${CKAN_INI} "ckan.site_url = ${CKAN_SITE_URL}"