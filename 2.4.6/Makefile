### DOCKER_IMAGE ###############################################################

ELASTIC_STACK_VERSION	= 2.4.6

ELASTICSEARCH_VERSION	= $(ELASTIC_STACK_VERSION)
ELASTICSEARCH_TAG	=$(ELASTICSEARCH_VERSION)

KIBANA_VERSION		= 4.6.6
KIBANA_TAG		= $(KIBANA_VERSION)

LOGSTASH_VERSION	= 2.4.1
LOGSTASH_TAG		= $(LOGSTASH_VERSION)

DOCKER_CONFIG		?= elastic-stack-2

### MK_DOCKER_IMAGE ############################################################

PROJECT_DIR		?= $(abspath ..)
include $(PROJECT_DIR)/docker.version.mk

################################################################################
