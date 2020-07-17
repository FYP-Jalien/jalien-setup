local_image=jalien-dev
gitlab_dev_image=gitlab-registry.cern.ch/jalien/jalien-setup/jalien-dev
gitlab_base_image=gitlab-registry.cern.ch/jalien/jalien-setup/jalien-base
gitlab_xrootd_image=gitlab-registry.cern.ch/jalien/jalien-setup/xrootd-se

base-image:
	docker build -t jalien-base -f base/Dockerfile base

xrootd-image:
	docker build -t xrootd-se -f xrootd/Dockerfile xrootd

dev-image: base-image xrootd-image
	docker build -t jalien-dev -f dev/Dockerfile dev

push-base: base-image
	docker tag jalien-base ${gitlab_base_image}
	docker push ${gitlab_base_image}

push-dev: push-base dev-image
	docker tag jalien-dev ${gitlab_dev_image}
	docker push ${gitlab_dev_image}

shell: dev-image
	docker run -it -v$(shell pwd):/jalien-setup:ro jalien-dev bash

all: dev-image
