// def node = 'Build-d001_EJ-019-64W10-12' //Node on which build should execute
def node = 'spf01_build-d001-cent7-x64-v' //Node on which build should execute
def source_files = "src"  // directory in which python source files exist
def test_files = "test"  // directory in which python source files exist
def req_txt = "config/python/requirements.txt" // requirements.txt location

// Jenkins specific configurations
def sonar_scanner_toolname = 'sonar-scanner-cli-4.6.0.2311-windows' // Scanner toolname as configured in Jenkins
def sonar_server_instance = 'sonar-ee' //instance name configured on Jenkins

//Sonar properties
def sonar_projectKey =  "spf-python-sw"
def sonar_projectName = "spf-python-sw"
def sonar_projectBaseDir= "." 
def sonar_sources="." 
def sonar_exclusions="**/coverage_html/**"
def sonar_coverage_exclusions="**/test/**"
def sonar_python_reportPath="pytest.xml"
def sonar_python_coverage_reportPath="coverage.xml"
def sonar_python_pylint_report = "pylint.xml"
sonar_parameters=" -X -Dsonar.projectKey=$sonar_projectKey -Dsonar.projectName=$sonar_projectName -Dsonar.projectBaseDir=$sonar_projectBaseDir -Dsonar.sources=$source_files -Dsonar.exclusions=$sonar_exclusions  -Dsonar.coverage.exclusions=$sonar_coverage_exclusions -Dsonar.python.xunit.reportPath=$sonar_python_reportPath -Dsonar.python.coverage.reportPaths=$sonar_python_coverage_reportPath -Dsonar.python.pylint.reportPath=$sonar_python_pylint_report "

						
pipeline {
    agent { label "${node}" }
    environment {
    sonarscanner = tool name: "${sonar_scanner_toolname}"
  }

    stages {
        stage('Init') {
            parallel {
                stage('PR') {
                    when { changeRequest() }
                    steps {
                        echo "This is a Pull Request. Passing this information to SonarQube"
                        script {
                            sonar_parameters = sonar_parameters + " -Dsonar.pullrequest.key=$CHANGE_ID -Dsonar.pullrequest.branch=$CHANGE_BRANCH -Dsonar.pullrequest.base=$CHANGE_TARGET "
                        }
                    }
                }
                stage ('Branch'){
                    when { not { changeRequest() } }
                    steps {
                        echo "This is a normal Branch. Passing this information to SonarQube"
                        script {
                            sonar_parameters = sonar_parameters + " -Dsonar.branch.name=$BRANCH_NAME "
                        }
                    }
                }
            }
        }
        stage('pipeline start') {
            parallel{
                stage ('Linux'){
                    when { expression { return isUnix() != 'True';}}
                    stages {
                        stage ('stage1'){
                            steps {
                                 echo "This is linux pipeline"
                            }
                        }
                        stage ('stage2'){
                            steps {
                                 echo "This is linux pipeline"
                            }
                        }
                    }
                    
                }
                stage ('Windows'){
                    when { expression { return isUnix() != 'False';}}
                    stages {
                        stage ('stage1'){
                            steps {
                                 echo "This is linux pipeline"
                            }
                        }
                        stage ('stage2'){
                            steps {
                                 echo "This is linux pipeline"
                            }
                        }
                    }
                }
            }
            // steps {
            //     script {
            //         if ( isUnix()) {
            //             echo 'Setup python env on Linux'
            //             sh '''
            //             module load python/3.9
            //             python -m pip install -r ${req_txt}
            //             '''
            //         }
            //         else {
            //             echo 'Setup python env on Windows'
            //             bat "python -m pip install -r ${req_txt}"
            //         }
            //     }
            // }
        }
        stage('Build project') {
            steps {
                script {
                    echo 'Generating Built artifact'  // Placeholder. May not be required for python
                }
            }
        }
        stage('Test and Coverage'){
            steps {
                script {
					bat """
                    coverage run --omit=*/test/* --source ${source_files} --branch -m pytest --cache-clear --junitxml ${sonar_python_reportPath} ${test_files}
                    coverage html -d coverage_html
                    coverage xml -o ${sonar_python_coverage_reportPath}
                    """
                }
            }
        }
        stage('Static Code Analysis - PyLint'){
            steps {
                script {
					bat """
                    python -m pylint -r n --msg-template="{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}" ./${source_files} > ${sonar_python_pylint_report}
                    exit 0
                    """
                }
            }
        }
		stage("StaticCodeAnalyser - SonarQube"){
			steps {
				script {
					withSonarQubeEnv ("${sonar_server_instance}") {
						bat """
						    $sonarscanner\\bin\\sonar-scanner.bat  $sonar_parameters
						    """
					}
				}
			}
		}
        stage("Quality Gate"){  // this should be enabled in conjunction with SonarQube Webhooks
            steps {
                timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
                    script {
                        def qg = waitForQualityGate abortPipeline: true// Reuse taskId previously collected by withSonarQubeEnv
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
       stage('Upload Artifacts') {
            steps {
                script {
                    echo 'Uploading Built artifact' // Placeholder. May not be required for python
                }
            }
        }
        stage('Release') {
            when { branch 'master' }
            stages {
                stage('Git Tagging') {
                    steps {
                        echo "git tag"
                    }
                }
                stage('Promotion') {
                    steps {
                        script {
                            echo 'Promote to BETA state'
                        }
                    }
                }
            }
        }
    }
}
