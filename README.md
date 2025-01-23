# node-auto-using-ca
Node.js app using auto-instr. method using AppD's Cluster agent.

`Note:` This is a test application to see nodejs `auto` instrumentation in action, the configuration may not be ideal for your application or prodcution env. 

### [1] Update Configuration

- #### Update env varaibles and accesskey for the project.

Update the following env variables.

```sh
apiVersion: v1
data:
  APPDYNAMICS_AGENT_APPLICATION_NAME: "<app_name>"
  APPDYNAMICS_CONTROLLER_PORT: "443"
  APPDYNAMICS_AGENT_ACCOUNT_NAME: "<account_name>"
  APPDYNAMICS_CONTROLLER_HOST_NAME: "<controller_host_name>"
  APPDYNAMICS_CONTROLLER_SSL_ENABLED: "true"
  APPDYNAMICS_AGENT_TIER_NAME: "<tier_name>"
  APPDYNAMICS_AGENT_REUSE_NODE_NAME_PREFIX: "<prefix_name>" 
kind: ConfigMap
metadata:
  name: appd-python-config
```
- #### Provide AccessKey 
Search & replace the placeholder `<accesskey>` with required access key.

- #### Updated account details in cluster-agent.yaml

```yaml

  appName: "<cluster_name>"
  controllerUrl: "<controller_host_name>"
  account: "<account_name>"
```

### [3]Build & Run

Make sure namespaces `dev` & `appdynamics` is not there in your env.
The build step will take care of end-to-end installing cluster agent (`ns:appdynamics`) and deploy a sample Node.js application to `dev` namespace accessible at http://localhost:3000. 
```sh
make all
```

#### Delete and remove deployment
```sh
make cleanall
```

### [4] Check deploy Status
```
make status
```

### Resources
[Install the Cluster Agent](https://docs.appdynamics.com/appd/24.x/latest/en/infrastructure-visibility/monitor-kubernetes-with-the-cluster-agent/install-the-cluster-agent/install-the-cluster-agent-with-the-kubernetes-cli)

[Auto-instrumentation using Cluster Agent](https://docs.appdynamics.com/appd/24.x/latest/en/infrastructure-visibility/monitor-kubernetes-with-the-cluster-agent/auto-instrument-applications-with-the-cluster-agent)