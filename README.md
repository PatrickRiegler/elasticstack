# remove project
export USR=...
export PW=...
oc delete project sdbi-elastic
sleep 5

# create project
oc new-project sdbi-elastic --description="Build and testing for SIX Base Images for the Elastic Stack" --display-name="SIX Docker Base Image - Elastic Stack"
sleep 3

# add secrets
oc project sdbi-elastic
oc secrets new-sshauth bitbucket-secret --ssh-privatekey=$HOME/.ssh/id_rsa

oc secrets new-basicauth artifactory --username=${USR} --password=${PW} 
oc label secrets artifactory jenkins-secret=true jenkins-secret-id=artifactory

sleep 3

# create required image streams
oc create -f https://${USR}:${PW}@stash.six-group.net/projects/SDBI/repos/elasticstack/raw/jenkins.json?at=refs%2Fheads%2Fdevelop
oc create -f https://${USR}:${PW}@stash.six-group.net/projects/SDBI/repos/elasticstack/raw/oracle-java-server-jre-8.json?at=refs%2Fheads%2Fdevelop
sleep 3

# create jenkins 
oc new-app --template=jenkins-ephemeral -p NAMESPACE="sdbi-elastic" -p JENKINS_IMAGE_STREAM_TAG="six-jenkins:latest" -p MEMORY_LIMIT=1024Mi 
sleep 5

# create build pipelines and s2i builds
oc create -f https://${USR}:${PW}@stash.six-group.net/projects/SDBI/repos/elasticstack/raw/setup.json?at=refs%2Fheads%2Fdevelop#




