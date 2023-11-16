prefix ?= g8w
env ?= dev
layer ?= "all"
layers ?= $(shell AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) list-layers)
AWS_PROFILE ?= $(prefix)-$(env)

export AWS_STS_REGIONAL_ENDPOINTS
export CI
export TF_CLI_ARGS
export TF_CLI_CONFIG_FILE
export TF_DATA_DIR
export TF_IGNORE
export TF_INPUT
export TF_IN_AUTOMATION
export TF_LOG
export TF_LOG_PATH
export TF_PLUGIN_CACHE_DIR
export TF_REGISTRY_CLIENT_TIMEOUT
export TF_REGISTRY_DISCOVERY_RETRY
export TF_WORKSPACE

all:
	@true

apply: ## Execute terraform-apply on all the specified layers of the specified env
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) apply $(layer)

clean-dirs: ## Remove all generated directory for terraform
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) clean-dirs $(layer)

delete-provider-lock-file: ## Delete the terraform lock-file on all the specified layers of the specified env
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) providers-lock-delete $(layer)

destroy: ## Execute terraform-destroy on all the specified layers of the specified env
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) destroy $(layer)

generate: ## Generate the Terraform source code using tfgen
	@../node_modules/.bin/tfgen ./config.json layers environments

get: ## Execute terraform-get on all the specified layers of the specified env
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) get $(layer)

init: ## Execute terraform-init on all the specified layers of the specified env
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) init $(layer)
init-full: ## Execute terraform-init on all the specified layers of the specified env
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) init-full $(layer)
init-full-upgrade: ## Execute terraform-init on all the specified layers of the specified env (with upgrade)
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) init-full-upgrade $(layer)
init-upgrade: ## Execute terraform-init on all the specified layers of the specified env (with upgrade)
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) init-upgrade $(layer)

list-layers: ## List all terraform layers
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) list-layers

lock-providers: delete-provider-lock-file lock-providers-base
lock-providers-base: ## Regenerate the terraform lock-file on all the specified layers of the specified env
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) providers-lock $(layer)

output: ## Display all the outputs of the specified terraform layer
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) output $(layer)
output-json: ## Export all the outputs of the specified terraform layer in JSON
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) output-json $(layer)

outputs: ## Generate the outputs directory from all the Terraform outputs
	@mkdir -p ../outputs/$(env)
	@$(foreach l,$(layers),echo "[$(env)] Saving outputs of layer '$(l)'..." && AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) output-json $l > ../outputs/$(env)/$(l).json;)

plan: ## Execute terraform-plan on all the specified layers of the specified env
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) plan $(layer)

provision: init sync
provision-full: init-full sync-full

refresh: ## Execute terraform init/plan/apply on all the specified layers of the specified env
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) refresh $(layer)

sync: ## Execute init/plan/apply(if need) on all the specified layers of the specified env
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) sync $(layer)
sync-full: ## Execute init/plan/apply(if need) on all the specified layers of the specified env
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) sync-full $(layer)

update: ## Execute terraform-update on all the specified layers of the specified env
	@AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=$(AWS_PROFILE) ../node_modules/.bin/tflayer $(env) update $(layer)

.PHONY: all \
		apply \
		clean-dirs \
		delete-provider-lock-file \
		destroy \
		generate \
		get \
		init init-full init-full-upgrade init-upgrade \
		list-layers \
		lock-providers lock-providers-base \
		output output-json \
		outputs \
		plan \
		provision provision-full \
		refresh \
		sync sync-full \
		update