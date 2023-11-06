env ?= dev
b ?= develop

export CI
export GITHUB_ACTION
export GITHUB_ACTIONS
export GITHUB_ACTOR
export GITHUB_API_URL
export GITHUB_BASE_REF
export GITHUB_EVENT_NAME
export GITHUB_EVENT_PATH
export GITHUB_GRAPHQL_URL
export GITHUB_HEAD_REF
export GITHUB_REF
export GITHUB_REPOSITORY
export GITHUB_RUN_ID
export GITHUB_RUN_NUMBER
export GITHUB_SERVER_URL
export GITHUB_SHA
export GITHUB_WORKFLOW
export GITHUB_WORKSPACE
export TF_CLI_ARGS
export TF_CLI_CONFIG_FILE
export TF_DATA_DIR
export TF_IGNORE
export TF_INPUT
export TF_IN_AUTOMATION
export TF_LOG
export TF_LOG_PATH
export TF_PLUGIN_CACHE_DIR=$(shell pwd)/.terraform/caches/plugins
export TF_REGISTRY_CLIENT_TIMEOUT
export TF_REGISTRY_DISCOVERY_RETRY
export TF_WORKSPACE

build: build-pre-provision build-post-provision
build-post-provision:
	@true
build-pre-plan:
	@true
build-pre-provision: build-pre-plan

deploy:
	@true

ensure-terraform-cache-dir:
	@mkdir -p $(TF_PLUGIN_CACHE_DIR)

generate: ## Generate and synchronize the source code using GenJS
	@yarn --silent genjs
generate-env-local:
	@true
generate-terraform: ensure-terraform-cache-dir generate-terraform-code
generate-terraform-code:
	@make -C infra/ generate

infra-apply: generate-terraform
	@make -C infra/ apply env=$(env)
infra-clean-dirs: generate-terraform
	@make -C infra/ clean-dirs env=$(env)
infra-destroy: generate-terraform
	@make -C infra/ destroy env=$(env) layer=$(layer)
infra-init: generate-terraform
	@make -C infra/ init env=$(env)
infra-init-full: generate-terraform
	@make -C infra/ init-full env=$(env)
infra-init-full-upgrade: generate-terraform
	@make -C infra/ init-full-upgrade env=$(env)
infra-init-upgrade: generate-terraform
	@make -C infra/ init-upgrade env=$(env)
infra-layer-plugins-upgrade:
	@echo "Cleaning Terraform plugins directory: $(layer)"
	@echo "Fetching Terraform plugins: $(layer)"
	@echo "Initializing: $(layer)"
infra-list-layers: generate-terraform
	@make -C infra/ list-layers env=$(env)
infra-lock-providers: generate-terraform
	@make -C infra/ lock-providers env=$(env)
infra-plan: generate-terraform
	@make -C infra/ plan env=$(env)
infra-refresh: generate-terraform
	@make -C infra/ refresh env=$(env)
infra-update: generate-terraform
	@make -C infra/ update env=$(env)

install: install-root
install-root: ## Install the Javascript dependencies
	@yarn --silent install
install-terraform: ## Install Terraform required version using tfenv
	@tfenv install

migrate:
	@true

output: generate-terraform
	@make -C infra/ output env=$(env) layer=$(layer)
output-json: generate-terraform
	@make -C infra/ output-json env=$(env) layer=$(layer)

outputs: generate-terraform
	@make -C infra/ outputs env=$(env)

pre-install: pre-install-root
pre-install-root: install-root

provision: generate-terraform
	@make -C infra/ provision env=$(env)
provision-full: generate-terraform
	@make -C infra/ provision-full env=$(env)

start:
	@npx concurrently -n  

test:
	@true

.DEFAULT_GOAL := install
.PHONY: build build-post-provision build-pre-plan build-pre-provision \
		deploy \
		ensure-terraform-cache-dir \
		generate generate-env-local generate-terraform generate-terraform-code \
		infra-apply infra-clean-dirs infra-destroy infra-init infra-init-full infra-init-full-upgrade infra-init-upgrade infra-layer-plugins-upgrade infra-list-layers infra-lock-providers infra-plan infra-refresh infra-update \
		install install-root install-terraform \
		migrate \
		output output-json \
		outputs \
		pre-install pre-install-root \
		provision provision-full \
		start \
		test