base-image:
	docker build -t jalien-base -f base/Dockerfile base

dev-image: base-image
	docker build -t jalien-dev -f dev/Dockerfile dev

all: dev-image
