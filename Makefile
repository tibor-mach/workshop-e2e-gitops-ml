ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.PHONY: help venv

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-z%A-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

venv: ## set up a simple python virtual environment and install requirements
	python3 -m venv .venv \
	&& source .venv/bin/activate \
	&& python3 -m pip install --upgrade pip wheel \
	&& python3 -m pip install -r requirements.txt

s3_credentials: ## uses the AWS S3 credentials in the .env file to store them in a local (ignored by git) config file for DVC
	source .venv/bin/activate \
	&& dvc remote modify --local storage secret_access_key $(AWS_SECRET_ACCESS_KEY) \
	&& dvc remote modify --local storage access_key_id $(AWS_ACCESS_KEY_ID)