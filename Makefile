MAKEFLAGS += -s
# Colors
LG :=\033[0;33m #Y
GR :=\033[0;32m #G
BL :=\033[0;31m #R
RE :=\033[0m

test:
	@echo "${LG}=====Test1 \n"
	@echo "${GR}~~~~~~~~~~~~~!!Tes2 ...${RE}\n"
	@echo "${BL}~~~~~~~~~~~~~!!Tes3 ...${RE}\n"
applyca:
	@echo "${LG}======>Deploying operator..${RE}\n"
	kubectl create namespace appdynamics
	kubectl -n appdynamics create secret generic cluster-agent-secret --from-literal=controller-key=<accesskey>
	@sleep 2
	@kubectl create -f cluster-agent-operator.yaml
	@sleep 2
	@echo "${RE}\n"
	@echo "${LG}======>Deploy CA...${RE}\n"
	kubectl -n appdynamics apply -f cluster-agent.yaml
	@sleep 3
	@echo "${LG}[Status] ${RE}\n"
	@echo "${LG}========= ${RE}\n"
	kubectl -n appdynamics get pods -o wide
deleteca:
	kubectl -n appdynamics delete -f cluster-agent.yaml
	kubectl -n appdynamics delete -f cluster-agent-operator.yaml
	kubectl -n appdynamics delete secret cluster-agent-secret
	#kubectl delete namespace appdynamics
build:
	eval $(minikube -p minikube docker-env)
	kubectl create namespace dev
	docker build --tag node-web-app-auto nodejs-web
	docker build --tag node-app-load load
rmi:
	docker rmi node-web-app-auto
	docker rmi node-app-load
create_key:
	kubectl -n dev create secret generic \
	appd-agent-secret \
	--from-literal=access-key=<accesskey>
apply:
	kubectl -n dev apply -f kube

status:
	@echo "${LG}"
	kubectl -n dev get pods
	kubectl -n appdynamics get pods
	@echo "${RE}\n"
delete:
	kubectl -n dev delete -f kube
	#kubectl delete namespace dev
deletens:
	kubectl delete namespace dev 
	kubectl delete namespace appdynamics
all:
	@echo "${LG}[step:1/4]======Starting CA deployment...${RE}\n"
	make applyca
	@sleep 2
	@echo "${LG}[step:2/4]======Starting ${RE}\n"
	make build # Image build
	@sleep 2 
	@echo "${LG}[step:3/4]======Build Completed!${RE}\n"
	make create_key # Create Key for agent 
	@echo "${LG}[step:4/4]======Deploying Application ...${RE}\n"
	make apply # Deploy
	@sleep 2
	@echo "${LG}[Status] ${RE}\n"
	@echo "${LG}========= ${RE}\n"
	@make status
clean:
	@echo "${LG}[Step:1/3]=====!!Deleting Application ...${RE}\n"
	make delete 
	@sleep 2
	@echo "${LG}[Step:2/3]=====!!Deleting CA ...${RE} \n"
	make deleteca # Remove CA
	@echo ". \n"
	@sleep 1
	@echo ". \n"
	@echo "${LG}[Step:3/3]=====!!Deleting namespaces ...${RE}"
	make deletens


