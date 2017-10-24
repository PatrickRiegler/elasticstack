properties([
  buildDiscarder(logRotator(numToKeepStr: '5'))
])


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
node('jenkins-slave-image-mgmt') {
    stage("Promote images") {
        withCredentials([string(credentialsId: 'SECRET_ARTIFACTORY_TOKEN', variable: 'ARTIFACTORY_API_KEY')]) {
            sh "promoteToArtifactory.sh -i sdbi/elasticsearch -t latest -r sdbi-docker-release-local -c"
            sh "promoteToArtifactory.sh -i sdbi/kibana -t latest -r sdbi-docker-release-local -c"
            sh "promoteToArtifactory.sh -i sdbi/logstash -t latest -r sdbi-docker-release-local -c"
            sh "promoteToArtifactory.sh -i sdbi/metricbeat -t latest -r sdbi-docker-release-local -c"
            sh "promoteToArtifactory.sh -i sdbi/packetbeat -t latest -r sdbi-docker-release-local -c"
            sh "promoteToArtifactory.sh -i sdbi/topbeat -t latest -r sdbi-docker-release-local -c"
        }
    }
}
