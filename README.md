# Docker stack file for jenkins

* A docker stack file to implement jenkins on a worker nodes of a docker swarm. 
* Jenkins use its own volume in jenkins home directory. 
* Jenkins utilize 2048G RAM, and 2 Core CPUs. 

stack.yaml
```yaml
version: "3.3"
volumes:
  jenkins-data: {}

services: 
  jenkins:
    image: jenkins/jenkins:lts
    deploy:
      replicas: 2
      resources:
        reservations:
          cpus: '2'
          memory: 2048M
      restart_policy:
         condition: on-failure
      placement:
        constraints: 
          - "node.role==worker"
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins-data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
     
```
      
`docker stack deploy --compose-file stack.yaml  jenkins`

verify services were created:

'docker service ls'

to see Jenkins initial password
`docker service logs jenkins_jenkins`

# Script for rolling update

* Script to rolling update jenkins in the future with a version variable. 

* It will rollback in the event of the rolling update failure.

script.sh

```
#!/bin/bash
docker service update \
--image=jenkins/jenkins:$1 \
--update-failure-action rollback \
jenkins_jenkins
```

`bash script.sh [version]`
