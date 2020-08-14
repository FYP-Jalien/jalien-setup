gitlab_base_image=gitlab-registry.cern.ch/jalien/jalien-setup/jalien-base
gitlab_xrootd_image=gitlab-registry.cern.ch/jalien/jalien-setup/xrootd-se

base-image:
	docker build -t jalien-base -f base/Dockerfile base

xrootd-image:
	docker build -t xrootd-se -f xrootd/Dockerfile xrootd

push-base: base-image
	docker tag jalien-base ${gitlab_base_image}
	docker push ${gitlab_base_image}

all: base-image xrootd-image
