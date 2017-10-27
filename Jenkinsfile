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

// images = [ "elasticsearch", "kibana", "logstash", "metricbeat", "packetbeat", "topbeat" ];
images = [ "elasticsearch", "kibana", "logstash", "metricbeat", "packetbeat", "topbeat" ];

node() {
    stage("Build images") {
      withCredentials([usernameColonPassword(credentialsId: 'artifactory', variable: 'ARTIFACTORY_CREDENTIALS')]) {
        for (i = 0; i < images.size(); i++) {
          openshiftBuild bldCfg: images[i]+'-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min', env: [[name: 'ARTIFACTORY_CREDENTIALS', value: env.ARTIFACTORY_CREDENTIALS ]]
        }
	/*
        openshiftBuild bldCfg: 'elasticsearch-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min', env: [[name: 'ARTIFACTORY_CREDENTIALS', value: env.ARTIFACTORY_CREDENTIALS ]]
        openshiftBuild bldCfg: 'kibana-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min', env: [[name: 'ARTIFACTORY_CREDENTIALS', value: env.ARTIFACTORY_CREDENTIALS ]]
        openshiftBuild bldCfg: 'logstash-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min', env: [[name: 'ARTIFACTORY_CREDENTIALS', value: env.ARTIFACTORY_CREDENTIALS ]]
        openshiftBuild bldCfg: 'metricbeat-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min', env: [[name: 'ARTIFACTORY_CREDENTIALS', value: env.ARTIFACTORY_CREDENTIALS ]]
        openshiftBuild bldCfg: 'packetbeat-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min', env: [[name: 'ARTIFACTORY_CREDENTIALS', value: env.ARTIFACTORY_CREDENTIALS ]]
        openshiftBuild bldCfg: 'topbeat-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min', env: [[name: 'ARTIFACTORY_CREDENTIALS', value: env.ARTIFACTORY_CREDENTIALS ]]
        */
      }
    }
}
imageMgmtNode() {
    stage("Promote images") {
      def registry
      def project
      //registry = sh returnStdout: true, script: "oc get is elasticsearch-build --template='{{ .status.dockerImageRepository }}' | cut -d/ -f1"
      //project = sh returnStdout: true, script: "oc get is elasticsearch-build --template='{{ .status.dockerImageRepository }}' | cut -d/ -f2"
      registry = sh(returnStdout: true, script: "oc get is elasticsearch-build --template='{{ .status.dockerImageRepository }}' | cut -d/ -f1").trim()
      project = sh(returnStdout: true, script: "oc get is elasticsearch-build --template='{{ .status.dockerImageRepository }}' | cut -d/ -f2").trim()
      withCredentials([usernameColonPassword(credentialsId: 'artifactory', variable: 'SKOPEO_DEST_CREDENTIALS')]) {
        withEnv(["SKOPEO_SRC_CREDENTIALS=${dockerToken()}"]) {
          for (i = 0; i < images.size(); i++) {
            sh "echo skopeoCopy.sh -f ${registry}/${project}/' + images[i] + '-build:tmp -t artifactory.six-group.net/sdbi/' + images[i] + '-build:latest"
          }
            /*
            sh "skopeoCopy.sh -f ${registry}/${project}/elasticsearch-build:tmp -t artifactory.six-group.net/sdbi/elasticsearch-build:latest"
            sh "promoteToArtifactory.sh -i sdbi/elasticsearch -t latest -r sdbi-docker-release-local -c"
            sh "skopeoCopy.sh -f ${registry}/${project}/kibana-build:tmp -t artifactory.six-group.net/sdbi/kibana-build:latest"
            sh "promoteToArtifactory.sh -i sdbi/kibana -t latest -r sdbi-docker-release-local -c"
            sh "skopeoCopy.sh -f ${registry}/${project}/logstash-build:tmp -t artifactory.six-group.net/sdbi/logstash-build:latest"
            sh "promoteToArtifactory.sh -i sdbi/logstash -t latest -r sdbi-docker-release-local -c"
            sh "skopeoCopy.sh -f ${registry}/${project}/metricbeat-build:tmp -t artifactory.six-group.net/sdbi/metricbeat-build:latest"
            sh "promoteToArtifactory.sh -i sdbi/metricbeat -t latest -r sdbi-docker-release-local -c"
            sh "skopeoCopy.sh -f ${registry}/${project}/packetbeat-build:tmp -t artifactory.six-group.net/sdbi/packetbeat-build:latest"
            sh "promoteToArtifactory.sh -i sdbi/packetbeat -t latest -r sdbi-docker-release-local -c"
            sh "skopeoCopy.sh -f ${registry}/${project}/topbeat-build:tmp -t artifactory.six-group.net/sdbi/topbeat-build:latest"
            sh "promoteToArtifactory.sh -i sdbi/topbeat -t latest -r sdbi-docker-release-local -c"
            */
        }
      }
    }
}
