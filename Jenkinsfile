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
images = [ "elasticsearch" ];

node() {
    stage("Build images") {
      withCredentials([usernameColonPassword(credentialsId: 'artifactory', variable: 'ARTIFACTORY_CREDENTIALS')]) {
        for (i = 0; i < images.size(); i++) {
          openshiftBuild bldCfg: images[i]+'-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min', env: [[name: 'ARTIFACTORY_CREDENTIALS', value: env.ARTIFACTORY_CREDENTIALS ]]
        }
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
            sh "skopeoCopy.sh -f ${registry}/${project}/" + images[i] + "-build:tmp -t artifactory.six-group.net/sdbi/" + images[i] + "-build:latest"
          }
        }
      }
    }
}
