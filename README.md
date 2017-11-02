# remove project
export USR=...
export PW=...
oc delete project sdbi-elastic

while true; do if ! oc project sdbi-elastic >/dev/null; then break; fi; sleep 1; done

# create project
oc new-project sdbi-elastic --description="Build and testing for SIX Base Images for the Elastic Stack" --display-name="SIX Docker Base Image - Elastic Stack"
oc adm policy add-role-to-user admin tkr6q tkb16 tk9mv tkisj tksu3 tkbip tk2he tkkaf tkba4 

sleep 3

# add secrets
oc project sdbi-elastic
oc secrets new-sshauth bitbucket-secret --ssh-privatekey=$HOME/.ssh/id_rsa

oc secrets new-basicauth artifactory --username=${USR} --password=${PW} 
oc label secrets artifactory jenkins-secret=true jenkins-secret-id=artifactory

sleep 3

# create required prerequisites
oc create -f https://${USR}:${PW}@stash.six-group.net/projects/SDBI/repos/elasticstack/raw/prerequisites.json?at=refs%2Fheads%2Fdevelop
oc new-app --template=jenkins-ephemeral -p NAMESPACE="sdbi-elastic" -p JENKINS_IMAGE_STREAM_TAG="six-jenkins:latest" -p MEMORY_LIMIT=1024Mi 

sleep 3

# create build pipelines and s2i builds
oc create -f https://${USR}:${PW}@stash.six-group.net/projects/SDBI/repos/elasticstack/raw/setup.json?at=refs%2Fheads%2Fdevelop#

sleep 10

# create deployment configs
oc create -f https://${USR}:${PW}@stash.six-group.net/projects/SDBI/repos/elasticstack/raw/deploy.json?at=refs%2Fheads%2Fdevelop#

# wait on jenkins to be ready
while true; do if oc describe dc/jenkins | grep Status | grep Complete >/dev/null; then break; fi; sleep 1; done

# run the first build
oc start-build elasticstack-pipeline



