def win_node = 'Build-d001_EJ-019-64W10-12' //Node on which build should execute
def linux_node = 'spf02_build-d002-cent7-x64-v' //Node on which build should execute
def source_files = "src"  // directory in which python source files exist
def test_files = "test"  // directory in which python source files exist
def req_txt = "config/python/requirements.txt" // requirements.txt location
def reports_dir="reports"  // folder where test, sca reports will be generated.
// Jenkins specific configurations
def sonar_scanner_toolname_windows = 'sonar-scanner-cli-4.6.0.2311-windows' // Scanner toolname as configured in Jenkins for windows
def sonar_scanner_toolname_linux = 'sonar-scanner-cli-4.6.0.2311-linux' // Scanner toolname as configured in Jenkins for linux
def sonar_server_instance = 'sonar-ee' //instance name configured on Jenkins

//Sonar properties
def sonar_projectKey =  "spf-python-sw"
def sonar_projectName = "spf-python-sw"
def sonar_projectBaseDir= "." 
def sonar_sources="." 
def sonar_exclusions="**/$reports_dir/**"
def sonar_coverage_exclusions="**/$test_files/**"
def sonar_python_reportPath="$reports_dir/pytest.xml"
def sonar_python_coverage_reportPath="$reports_dir/coverage.xml"
def sonar_python_pylint_report = "$reports_dir/pylint.xml"
sonar_parameters=" -X -Dsonar.projectKey=$sonar_projectKey -Dsonar.projectName=$sonar_projectName -Dsonar.projectBaseDir=$sonar_projectBaseDir -Dsonar.sources=$source_files -Dsonar.exclusions=$sonar_exclusions  -Dsonar.coverage.exclusions=$sonar_coverage_exclusions -Dsonar.python.xunit.reportPath=$sonar_python_reportPath -Dsonar.python.coverage.reportPaths=$sonar_python_coverage_reportPath -Dsonar.python.pylint.reportPath=$sonar_python_pylint_report "
						
pipeline {
    agent any
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
                    when { environment name: 'OS', value: '' }  //Check if the running node is non-windows
                    stages {
                        stage('Build project') {
                            steps {
                                echo 'Generating Built artifact'  // Placeholder. May not be required for python
                            }
                        }         
                        stage('Test and Coverage'){
                            steps {
                                sh 'scripts/linux/unittest.sh'  
                            }
                        }
                        stage('Regression Tests'){         // This may be removed from CI
                            steps {
                                sh 'scripts/linux/regressiontest.sh'
                            }
                        }
                        stage('SCA - PyLint'){
                            steps {
                                sh "scripts/linux/runPylint.sh  $source_files $sonar_python_pylint_report"
                            }
                        }
                        stage("SCA - SonarQube"){
                            environment {
                                sonarscanner = tool name: "${sonar_scanner_toolname_linux}"
                            }
                            steps {
                                withSonarQubeEnv ("${sonar_server_instance}") {
                                    echo "analyse sonarqube"
                                    sh "$sonarscanner/bin/sonar-scanner  $sonar_parameters"
                                }
                            }
                        }
                        stage('SonarQube Quality Gate') {
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
                    }
                }
                stage ('Windows'){
                    agent { label "${win_node}" }
                  	environment {
                      graphviz= tool 'graphviz'
                    }
                    when { environment name: 'OS', value: 'Windows_NT' } //Check is the running node is windows
                    stages {
                        stage('Build project') {
                            steps {
                                bat "type NUL > build-0.3.txt "	
                            }
                        }
						stage('Test and Coverage'){
                            steps {
                                bat "scripts\\windows\\unittest.bat"
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
                        stage('Regression Tests'){         // This may be removed from CI
                            steps {
                                bat "scripts\\windows\\regressiontest.bat"
                            }
                        }
                        stage('Static Code Analysis - PyLint'){   // this is used along with sonar properties for static analysis
                            steps {
                                bat "scripts\\windows\\runPylint.bat $source_files $sonar_python_pylint_report"
                            }
                        }
						stage('Archive Test Report'){
                            steps {
                                     zip zipFile: 'report.zip', archive: false , dir: 'reports'
                                
                            }
                        }	
                        stage("SCA - SonarQube"){
                            environment {
                                sonarscanner = tool name: "${sonar_scanner_toolname_windows}"
                            }
                            steps {
                                withSonarQubeEnv ("${sonar_server_instance}") {
                                    echo "analyse sonarqube"
                                    bat "$sonarscanner\\bin\\sonar-scanner.bat  $sonar_parameters"
                                }
                            }
                        }
                    
                        stage('Upload Artifacts') {
                            steps {
                                script{
                                    server = Artifactory.server 'Artifactory'  // name configured in Manage Jenkins-> Configuration
                                        def copy = """{
                                            "files": [
                                                    {
                                                    "pattern": "build-0.3.txt", 
                                                    "target": "gen-des-spf-local/artifacts/",
                                                    "recursive": "false"
                                                },
												{
                                                    "pattern": "report.zip", 
                                                    "target": "gen-des-spf-local/test/",
                                                    "recursive": "false"
                                                }
												
                                            ]}""" 
                                server.upload(copy)
                                }
                            }
                        }
                    }    
                }
                
            }
        }
        stage('Release') {
            when { branch 'master' }
            agent { label "${win_node}" } 
            stages {
                stage ('Generate Technical Doc'){
                    steps {
                        bat "scripts\\windows\\runSphinx.bat" //for windows nodes
                        // sh "scripts/linux/runSphinx.bat" // for linux nodes 
                        
                    }
                }
                stage('Promotion') {
                    steps {
                        echo 'Promote to BETA state'
                    }
                }
            }
        }
    }

    post {
        success{
                emailext body: '${SCRIPT, template="groovy-html.template"}',
                recipientProviders: [developers(), brokenBuildSuspects()],
                subject: 'Build was successful for project "$PROJECT_NAME" and branch "$BRANCH_NAME"',mimeType: 'text/html'
            }
        failure{
                emailext body: '${SCRIPT, template="groovy-html.template"}',
                recipientProviders: [developers(), brokenBuildSuspects()],
                subject: 'Build Failed for project "$PROJECT_NAME" and branch "$BRANCH_NAME"',mimeType: 'text/html'
            }
        fixed{  // this will execute only if current build is success and previous build failed
                emailext body: '${SCRIPT, template="groovy-html.template"}',
                recipientProviders: [developers(), brokenBuildSuspects()],
                subject: 'Build is back to normal state "$PROJECT_NAME" and branch "$BRANCH_NAME"',mimeType: 'text/html'
            }

        }
}
