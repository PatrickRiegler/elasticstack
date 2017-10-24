properties([
  buildDiscarder(logRotator(numToKeepStr: '5'))
])

def dockerToken(String login = "serviceaccount") {
  node() {
    // Read the auth token from the file defined in the env variable AUTH_TOKEN
    String token = sh returnStdout: true, script: 'cat ${AUTH_TOKEN}'
    String prefix
    if (login) {
      prefix = "${login}:"
    } else {
      prefix = ''
    }
    return prefix + token
  }
} 

def imageMgmtNode(Closure body) {
    podTemplate(cloud: 'openshift', inheritFrom: 'maven', label: 'imageMgmt',
            containers: [containerTemplate(
                    name: 'jnlp',
                    image: 'artifactory.six-group.net/sdbi/jenkins-slave-image-mgmt',
                    alwaysPullImage: true,
                    args: '${computer.jnlpmac} ${computer.name}',
                    workingDir: '/tmp')]
    ) {
        node('imageMgmt') {
            body.call()
        }
    }
}

node() {
    stage("Build images") {
        openshiftBuild bldCfg: 'elasticsearch-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min'
        openshiftBuild bldCfg: 'kibana-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min'
        openshiftBuild bldCfg: 'logstash-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min'
        openshiftBuild bldCfg: 'metricbeat-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min'
        openshiftBuild bldCfg: 'packetbeat-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min'
        openshiftBuild bldCfg: 'topbeat-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min'
    }
}
imageMgmtNode() {
    stage("Promote images") {
    withCredentials([usernameColonPassword(credentialsId: 'artifactory', variable: 'SKOPEO_DEST_CREDENTIALS')]) {
        withEnv(["SKOPEO_SRC_CREDENTIALS=${dockerToken()}"]) {
            sh "promoteToArtifactory.sh -i sdbi/elasticsearch -t latest -r sdbi-docker-release-local -c"
            sh "promoteToArtifactory.sh -i sdbi/kibana -t latest -r sdbi-docker-release-local -c"
            sh "promoteToArtifactory.sh -i sdbi/logstash -t latest -r sdbi-docker-release-local -c"
            sh "promoteToArtifactory.sh -i sdbi/metricbeat -t latest -r sdbi-docker-release-local -c"
            sh "promoteToArtifactory.sh -i sdbi/packetbeat -t latest -r sdbi-docker-release-local -c"
            sh "promoteToArtifactory.sh -i sdbi/topbeat -t latest -r sdbi-docker-release-local -c"
        }
    }
}

