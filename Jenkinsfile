// load sdbi shared libraryssh://git@stash.six-group.net:22/sdbi/jenkins-shared-library.git
library identifier: 'sdbi-shared-lib@develop', retriever: modernSCM(
        [$class       : 'GitSCMSource',
         remote       : 'ssh://git@stash.six-group.net:22/sdbi/jenkins-shared-library.git',
         credentialsId: 'sdbi-elastic-bitbucket-secret'])

defaultProperties()

def jobContext = getInitialJobContext()

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

//if (params.product) {
	//images = [ "elasticsearch", "kibana", "logstash", "metricbeat", "packetbeat", "topbeat" ];
	images = [ "packetbeat" ];
/*
} else {
	images = [ params.product ];
}
*/

node() {
  for (i = 0; i < images.size(); i++) {
    stage("Build image: "+images[i]) {
      withCredentials([usernameColonPassword(credentialsId: 'artifactory', variable: 'ARTIFACTORY_CREDENTIALS')]) {
          openshiftBuild bldCfg: images[i]+'-build', showBuildLogs: 'true', verbose: 'false', waitTime: '5', waitUnit: 'min', env: [[name: 'ARTIFACTORY_CREDENTIALS', value: env.ARTIFACTORY_CREDENTIALS ]]
      }
    }
  }
}

node() {
  stage("Testing Elastic Stack") {
    sh "echo 'run tests'"
  }
}

imageMgmtNode('elasticstack') {
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
            sh "skopeoCopy.sh -f ${registry}/${project}/" + images[i] + "-build:tmp -t artifactory.six-group.net/sdbi/" + images[i] + "-snapshot:latest"
          }
        }
      }
    }
}
