terraform -chdir="./infrastructure/dependencies/terraform" destroy -auto-approve

terraform -chdir="./infrastructure/terraform" destroy -auto-approve