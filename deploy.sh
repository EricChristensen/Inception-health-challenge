terraform -chdir="./infrastructure/dependencies/terraform" init
terraform -chdir="./infrastructure/dependencies/terraform" plan
terraform -chdir="./infrastructure/dependencies/terraform" apply -auto-approve

cd app
./build_and_deploy_function.sh
cd ..

terraform -chdir="./infrastructure/terraform" init
terraform -chdir="./infrastructure/terraform" plan
terraform -chdir="./infrastructure/terraform" apply -auto-approve

