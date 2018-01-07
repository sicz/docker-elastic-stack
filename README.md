# docker-elastic-stack

[![CircleCI Status Badge](https://circleci.com/gh/sicz/docker-elastic-stack.svg?style=shield&circle-token=8f1fee58b84d662697ade3075dafc79d694e008e)](https://circleci.com/gh/sicz/docker-elastic-stack)

**This project is not aimed at public consumption.
It exists to serve as a single endpoint for SICZ containers.**

[Elastic Stack](https://elastic.co) reliably and securely take data from any
source, in any format, and search, analyze, and visualize it in real time.

This project brings playground to experiment with full Elastic Stack. Simple
copy your Logstash configuration to `logstash` directory, publish logstash input
ports in `docker-compose.local.yml` and run Elastic Stack with command `make up`.

## Contents

This project use containers:
* [sicz/logstash](https://github.com/sicz/docker-logstash)
* [sicz/elasticsearch](https://github.com/sicz/docker-elasticsearch)
* [sicz/kibana](https://github.com/sicz/docker-kibana)
* [sicz/simple-ca](https://github.com/sicz/docker-simple-ca)

## Getting started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes. See deployment for notes
on how to deploy the project on a live system.

### Installing

Clone the GitHub repository into your working directory:
```bash
git clone https://github.com/sicz/docker-elastic-stack
```

### Usage

The project contains Docker image version directories:
* `x.y.z` - Elastic Stack version

Use the command `make` in the project directory:
```bash
make clean                    # Remove all containers and clean work files
make docker-pull              # Pull all images from Docker Registry
```

Use the command `make` in the image version directories:
```bash
make all                      # Build a new image and run the tests
make ci                       # Build a new image and run the tests
make config-file              # Display the configuration file for the current configuration
make vars                     # Display the make variables for the current configuration
make up                       # Remove the containers and then run them fresh
make create                   # Create the containers
make start                    # Start the containers
make stop                     # Stop the containers
make restart                  # Restart the containers
make rm                       # Remove the containers
make wait                     # Wait for the start of the containers
make ps                       # Display running containers
make logs                     # Display the container logs
make logs-tail                # Follow the container logs
make shell                    # Run the shell in the container
make test                     # Run the tests
make test-shell               # Run the shell in the test container
make clean                    # Remove all containers and work files
make docker-pull              # Pull all images from the Docker Registry
make docker-push              # Push the project image into the Docker Registry
```

Ports:
* `elasticsearch` container listens on TCP port 9200.
* `kibana` container listens on TCP port 5601.

## Deployment

Copy your Logstash filter configuration to `logstash` directory and publish
logstash input ports in `docker-compose.local.yml`, for example:
```yaml
version: "3.3"

services:
  ls:
    ports:
      - 5514:514/udp
      - 5514:514/tcp
      - 5044:5044/tcp
```
Run Elastic Stack with command `make up` and point your browser to Kibana on
TCP port 5601.

## Authors

* [Petr Řehoř](https://github.com/prehor) - Initial work.

See also the list of
[contributors](https://github.com/sicz/docker-elastic-stack/contributors)
who participated in this project.

## License

This project is licensed under the Apache License, Version 2.0 - see the
[LICENSE](LICENSE) file for details.
