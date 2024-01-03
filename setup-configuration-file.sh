# Starting CKAN requires a ckan.ini file.
# The main ckan.ini contains all the configuration options. Here we set the sensitive ones.

ckan config-tool ckan.ini "SECRET_KEY=pepe"
ckan config-tool ckan.ini "beaker.session.secret=g5qXJbukfPqsDekI-3APT1beQh8"
ckan config-tool ckan.ini "ckan.plugins = activity harvest ckan_harvester image_view datatables_view"

ckan config-tool ckan.ini "sqlalchemy.url = ${CKAN_SQLALCHEMY_URL}"
ckan config-tool ckan.ini "ckan.redis.url = ${CKAN_REDIS_URL}"
ckan config-tool ckan.ini "solr_url = ${SOLR_URL}"
ckan config-tool ckan.ini "ckan.site_url = ${CKAN_SITE_URL}"
ckan config-tool ckan.ini "ckan.storage_path = /storage/"