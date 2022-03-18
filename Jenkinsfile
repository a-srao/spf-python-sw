def node = 'Build-d001_EJ-019-64W10-12' //Node on which build should execute
def source_files = "src"  // directory in which python source files exist
def req_txt = "config/python/requirements.txt" // requirements.txt location

// Jenkins specific configurations
def sonar_scanner_toolname = 'sonar-scanner-cli-4.6.0.2311-windows' // Scanner toolname as configured in Jenkins
def sonar_server_instance = 'sonar-ee' //instance name configured on Jenkins

//Sonar properties
def sonar_projectKey="${params.ProjectName}"
def sonar_projectName="${params.ProjectName}"
def sonar_projectBaseDir="." 
def sonar_sources="." 
def sonar_exclusions="**/coverage_html/**"
def sonar_coverage_exclusions="**/test/**"
def sonar_python_reportPath="pytest.xml"
def sonar_python_coverage_reportPath="coverage.xml"
def sonar_python_pylint_report = "pylint.xml"
						
pipeline {
    agent { label "${node}" }
    stages {
        stage('Setup python env ') {
            steps {
                script {
                    echo 'Setup python env'
                    bat "python -m pip install -r ${req_txt}"
                }
            }
        }
        stage('Build project') {
            steps {
                script {
                    echo 'Generating Built artifact'  // Placeholder. May not be required for python
                }
            }
        }
        // stage("Pytest"){
        //     steps {
        //         script {
		// 			bat """
		// 			cd ${source_files}
		// 			echo "Testing Python files in ${source_files}"
		// 			REM pytest --rootdir=. test --with-xunit --xunit-file=pyunit.xml
        //             pytest --rootdir=. ../test/test_hello_world
        //             junit 'pyunit.xml'
		// 			"""
        //         }
        //     }
        // }
        stage('Coverage'){
            steps {
                script {
					bat """
					REM cd ${source_files}
                    coverage run --omit=*/test/* --source ${source_files} --branch -m pytest --cache-clear --junitxml pytest.xml "test"
                    REM coverage html -d coverage_html
                    REM coverage run --source . --branch -m py.test --junitxml pytest.xml test
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
					cd ${source_files}
                    pylint -r n --msg-template="{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}" > pylint.xml
                    """
                }
            }
        }
        
        
		stage("StaticCodeAnalyser - SonarQube"){
			steps {
				script {
					def scannerHome = tool name: ${sonar_scanner_toolname}, type: 'hudson.plugins.sonar.SonarRunnerInstallation';
                    echo "hello"
					// withSonarQubeEnv("${sonar_server_instance}" {
					// 	bat """
					// 	    cd ${source_files}
					// 	    $scannerHome\\bin\\sonar-scanner.bat -D sonar-project.properties=$workspace\\config\\sonarqube\\sonar-project.properties -D sonar.projectKey=$sonar_projectKey -D sonar.projectName=$sonar_projectName -D sonar.projectBaseDir=$sonar.projectBaseDir -D sonar.sources=$sonar_sources -D sonar.exclusions=$sonar_exclusions  -D sonar.coverage.exclusions=$sonar_coverage_exclusions -D sonar.python.xunit.reportPath=$sonar_python_xunit_reportPath -D sonar.python.coverage.reportPath=$sonar_python_coverage_reportPath -D sonar.python.pylint.reportPath=$sonar_python_pylint_report
					// 	"""
					// }
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
