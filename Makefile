base-image:
	docker build -t jalien-base -f base/Dockerfile base

dev-image: base-image
	docker build -t jalien-dev -f dev/Dockerfile dev

shell: dev-image
	docker run -it -v$(shell pwd):/jalien-setup:ro jalien-dev bash

all: dev-image
