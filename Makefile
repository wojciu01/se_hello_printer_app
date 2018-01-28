SERVICE_NAME=hello-world-printer
MY_DOCKER_NAME=$(SERVICE_NAME)

.PHONY: test
.DEFAULT_GOAL := test

deps:
	pip install -r requirements.txt; \
	pip install -r test_requirements.txt

lint:
	flake8 hello_world test

test:
	python -m pytest --verbose -s

run:
	python main.py

docker_build:
	docker build -t $(SERVICE_NAME)-dev .

docker_run: docker_build
			docker run \
				--name $(SERVICE_NAME)-dev \
				 -p 5000:5000 \
				 -d $(MY_DOCKER_NAME)

docker_stop:
	docker stop $(SERVICE_NAME)-dev

USERNAME=brzeczunio
TAG=$(USERNAME)/$(MYDOCKER_NAME)

docker_push: docker_build
	@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
	docker tag $(MY_DOCKER_NAME) $(TAG); \
	docker push $(TAG); \
	docker logout;
