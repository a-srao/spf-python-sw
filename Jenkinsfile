def win_node = 'Build-d001_EJ-019-64W10-12' //Node on which build should execute
def linux_node = 'spf01_build-d001-cent7-x64-v' //Node on which build should execute
def source_files = "src"  // directory in which python source files exist
def test_files = "test"  // directory in which python source files exist
def req_txt = "config/python/requirements.txt" // requirements.txt location

// Jenkins specific configurations
def sonar_scanner_toolname_windows = 'sonar-scanner-cli-4.6.0.2311-windows' // Scanner toolname as configured in Jenkins for windows
def sonar_scanner_toolname_linux = 'sonar-scanner-cli-4.6.0.2311-linux' // Scanner toolname as configured in Jenkins for linux
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
    agent any
	environment {
    graphviz= tool 'graphviz'
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
        stage('Pipeline Execution') {
            parallel{
                stage ('Linux'){
                    agent { label "${linux_node}" }
                    when { environment name: 'OS', value: '' }  //Check is the running node is non-windows
                    stages {
                        stage('Build project') {
                            steps {
                                echo 'Generating Built artifact'  // Placeholder. May not be required for python
                            }
                        }         
                        stage('Test and Coverage'){
                            steps {
                                sh 'scripts/linux/unittest.sh'  // Placeholder. May not be required for python
                            }
                        }
                        stage('SCA - PyLint'){
                            steps {
                                script {
                                    echo 'Execute pylint on Linux enviornment'
                                    sh """
                                    ./scripts/linux/runPylint.sh  $source_files $sonar_python_pylint_report
                                    """
                                }
                            }
                        }
                        stage("SCA - SonarQube"){
                            environment {
                                sonarscanner = tool name: "${sonar_scanner_toolname_linux}"
                            }
                            steps {
                                script {
                                    withSonarQubeEnv ("${sonar_server_instance}") {
                                        echo "analyse sonarqube"
                                        sh """
                                        $sonarscanner\\bin\\sonar-scanner  $sonar_parameters
                                        """
                                    }
                                }
                            }
                        }
                    }
                    
                }
                stage ('Windows'){
                    agent { label "${win_node}" }
                    when { environment name: 'OS', value: 'Windows_NT' } //Check is the running node is windows
                    stages {
                        stage('Build project') {
                            steps {
                                script {
                                    echo 'Generating Built artifact'  // Placeholder. May not be required for python
                                }
                            }
                        }
						stage('Profile'){
							steps{
									bat """
									python -m cProfile -o profile.pstats src/hello_world.py
									gprof2dot -f pstats profile.pstats | ${graphviz}\\bin\\dot -Tpng -o out1.png
								    """
				                }
		
		                }
                        stage('Test and Coverage'){
                            steps {
									bat """
					
									.\\scripts\\windows\\unittest.bat
                    
									"""
							}
                        }
                        stage('Static Code Analysis - PyLint'){
                            steps {
                                script {
                                    echo 'Execute pylint on Windows enviornment'
                                    bat """
                                    .\\scripts\\windows\\runPylint.bat $source_files $sonar_python_pylint_report
                                    """
                                }
                            }
                        }
                        stage("SCA - SonarQube"){
                            environment {
                                sonarscanner = tool name: "${sonar_scanner_toolname_windows}"
                            }
                            steps {
                                script {
                                    withSonarQubeEnv ("${sonar_server_instance}") {
                                        echo "analyse sonarqube"
                                        bat """
                                        $sonarscanner\\bin\\sonar-scanner.bat  $sonar_parameters
                                        """
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        // Uncomment this code for production
        // stage('SonarQube Quality Gate') {
        //     steps {
        //         timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
        //             script {
        //                 def qg = waitForQualityGate abortPipeline: true// Reuse taskId previously collected by withSonarQubeEnv
        //                 if (qg.status != 'OK') {
        //                     error "Pipeline aborted due to quality gate failure: ${qg.status}"
        //                 }
        //             }
        //         }
        //     }
        // }
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
