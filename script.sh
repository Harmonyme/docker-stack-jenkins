#!/bin/bash
docker service update \
--image=jenkins/jenkins:$1 \
--update-failure-action rollback \
jenkins_jenkins


