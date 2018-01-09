### DOCKER_IMAGE ###############################################################

DOCKER_PROJECT		?= sicz
DOCKER_PROJECT_DESC	?= An Elastic Stack playground in Docker
DOCKER_PROJECT_URL	?= https://www.elastic.co

# Elasticsearch
ELASTICSEARCH_NAME	?= $(DOCKER_PROJECT)/elasticsearch
ELASTICSEARCH_VERSION	?= $(ELASTIC_STACK_VERSION)
ELASTICSEARCH_TAG	?= $(ELASTICSEARCH_VERSION)-x-pack
ELASTICSEARCH_IMAGE	?= $(ELASTICSEARCH_NAME):$(ELASTICSEARCH_TAG)
DOCKER_IMAGE_DEPENDENCIES += $(ELASTICSEARCH_IMAGE)

# Kibana
KIBANA_NAME		?= $(DOCKER_PROJECT)/kibana
KIBANA_VERSION		?= $(ELASTIC_STACK_VERSION)
KIBANA_TAG		?= $(KIBANA_VERSION)-x-pack-basic
KIBANA_IMAGE		?= $(KIBANA_NAME):$(KIBANA_TAG)
DOCKER_IMAGE_DEPENDENCIES += $(KIBANA_IMAGE)

# Logstash
LOGSTASH_NAME		?= $(DOCKER_PROJECT)/logstash
LOGSTASH_VERSION	?= $(ELASTIC_STACK_VERSION)
LOGSTASH_TAG		?= $(LOGSTASH_VERSION)-x-pack
LOGSTASH_IMAGE		?= $(LOGSTASH_NAME):$(LOGSTASH_TAG)
DOCKER_IMAGE_DEPENDENCIES += $(LOGSTASH_IMAGE)

# Dummy args, they are not used but must be defined
BASE_IMAGE_NAME		?= $(ELASTICSEARCH_NAME)
BASE_IMAGE_TAG		?= $(ELASTICSEARCH_TAG)
DOCKER_NAME		?= elastic-stack
DOCKER_IMAGE_TAG	?= $(ELASTICSEARCH_TAG)

### EXECUTOR ###################################################################

# Use the Docker Compose executor
DOCKER_EXECUTOR		?= compose

# Overrride docker-compose.yml with docker-compose.local.yml if it exists
ifneq ($(wildcard $(PROJECT_DIR)/docker-compose.local.yml),)
ifeq ($(DOCKER_CONFIG),)
COMPOSE_FILES		?= docker-compose.yml \
			  docker-compose.local.yml
else
COMPOSE_FILES		?= docker-compose.yml \
			   docker-compose.$(DOCKER_CONFIG).yml \
			   docker-compose.local.yml
endif
endif

# Variables used in the Docker Compose file
COMPOSE_VARS		+= ELASTICSEARCH_VERSION \
			   ELASTICSEARCH_IMAGE \
			   KIBANA_VERSION \
			   KIBANA_IMAGE \
			   LOGSTASH_VERSION \
			   LOGSTASH_IMAGE

### MAKE_VARS ##################################################################

# Display the make variables
MAKE_VARS		?= GITHUB_MAKE_VARS \
			   CONFIG_MAKE_VARS \
			   EXECUTOR_MAKE_VARS \
			   SHELL_MAKE_VARS \
			   DOCKER_REGISTRY_MAKE_VARS

define CONFIG_MAKE_VARS
ELASTIC_STACK_VERSION:	$(ELASTIC_STACK_VERSION)

ELASTICSEARCH_TAG:	$(ELASTICSEARCH_TAG)
ELASTICSEARCH_IMAGE:	$(ELASTICSEARCH_IMAGE)

KIBANA_TAG:		$(KIBANA_TAG)
KIBANA_IMAGE:		$(KIBANA_IMAGE)

LOGSTASH_TAG:		$(LOGSTASH_TAG)
LOGSTASH_IMAGE:		$(LOGSTASH_IMAGE)
endef
export CONFIG_MAKE_VARS

### MAKE_TARGETS ###############################################################

# Build a new image and run the tests
.PHONY: all
all: clean start wait logs test

# Build a new image and run the tests
.PHONY: ci
ci: all
	@$(MAKE) clean

### EXECUTOR_TARGETS ###########################################################

# Display the configuration file
.PHONY: config-file
config-file: display-config-file

# Display the make variables
.PHONY: vars
vars: display-makevars

# Remove the containers and then run them fresh
.PHONY: run up
run up: docker-up

# Create the containers
.PHONY: create
create: docker-create
	@CONF_FILES="`find $(PROJECT_DIR)/logstash -type f -name '*.conf' | wc -l`"; \
	if [ $${CONF_FILES} -eq 0 ]; then \
		echo "Installing default logstash/logstash.conf"; \
		cp $(TEST_DIR)/spec/fixtures/logstash/logstash.conf $(PROJECT_DIR)/logstash; \
	fi

# Start the containers
.PHONY: start
start: create docker-start

# Wait for the start of the containers
.PHONY: wait
wait: start docker-wait

# Display running containers
.PHONY: ps
ps: docker-ps

# Display the container logs
.PHONY: logs
logs: docker-logs

# Follow the container logs
.PHONY: logs-tail tail
logs-tail tail: docker-logs-tail

# Run shell in the container
.PHONY: shell sh
shell sh: start docker-shell

# Run the tests
.PHONY: test
test: start docker-test

# Run the shell in the test container
.PHONY: test-shell tsh
test-shell tsh:
	@$(MAKE) test TEST_CMD=/bin/bash

# Stop the containers
.PHONY: stop
stop: docker-stop

# Restart the containers
.PHONY: restart
restart: stop start

# Remove the containers
.PHONY: down rm
down rm: docker-rm

# Remove all containers and work files
.PHONY: clean
clean: docker-clean

### MK_DOCKER_IMAGE ############################################################

MK_DIR			?= $(PROJECT_DIR)/../Mk
include $(MK_DIR)/docker.image.mk

################################################################################
