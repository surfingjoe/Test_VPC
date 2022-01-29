pipeline{
    agent {label 'build_slave1'}
    tools {
        terraform 'Terraform'
    }

    parameters {
        // string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')

    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    
    stages{
        stage('Git Checkout'){
           steps{
               git branch: 'master', credentialsId: 'Github', url: 'https://github.com/surfingjoe/test_vpc'
                    script {
                        CI_ERROR = "Failed while checking out SCM"
                        ... ### Code for SCM Checkout
				    }
           }
        }
        stage('Terraform Init'){
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            steps{
                sh label: '', script: 'terraform init'
                // sh 'terraform workspace select ${environment} || terraform workspace new ${environment}'

                sh "terraform plan -input=false -out tfplan "
                sh 'terraform show -no-color tfplan > tfplan.txt'
                    script {
                        CI_ERROR = "Failed Terraform INIT"
                        ... ### Code for Terraform_init
				    }
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
               not {
                    equals expected: true, actual: params.destroy
                }
           }

            steps {
               script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
        }
         stage('Apply') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }

            steps {
                sh "terraform apply -input=false tfplan"
                slackSend color: 'good', message: 'Test VPC Deployment successfully Applied'
                    script {
                        CI_ERROR = "Failed Terraform INIT"
                        ... ### Code for Terraform_Apply
				    }
            }
        }

        stage('Destroy') {
            when {
                equals expected: true, actual: params.destroy
            }

        steps {
            sh 'terraform init -input=false'
            sh "terraform destroy --auto-approve"
            slackSend color: 'good', message: 'Test VPC Deployment Destroyed'
                script {
                        CI_ERROR = "Failed Terraform INIT"
                        ... ### Code for Terraform_Destroy
				    }
        }
    }
  post {
		always {
			script {
				CONSOLE_LOG = "${env.BUILD_URL}/console"
				BUILD_STATUS = currentBuild.currentResult
				if (currentBuild.currentResult == 'SUCCESS') {
					CI_ERROR = "NA"
					}
				}
				sh """
					TODAY=`date +"%b %d"`
					sed -i "s/%%JOBNAME%%/${env.JOB_NAME}/g" report.html
					sed -i "s/%%BUILDNO%%/${env.BUILD_NUMBER}/g" report.html
					sed -i "s/%%DATE%%/\${TODAY}/g" report.html
					sed -i "s/%%BUILD_STATUS%%/${BUILD_STATUS}/g" report.html
					sed -i "s/%%ERROR%%/${CI_ERROR}/g" report.html
					sed -i "s|%%CONSOLE_LOG%%|${CONSOLE_LOG}|g" report.html
				"""
				publishHTML(target:[
					allowMissing: true,
					alwaysLinkToLastBuild: true, 
					keepAll: true, 
					reportDir: "${WORKSPACE}", 
					reportFiles: 'report.html', 
					reportName: 'CI-Build-HTML-Report', 
					reportTitles: 'CI-Build-HTML-Report'
					])
				sendSlackNotifcation()
  
        }
    }
}

{ 
	if ( currentBuild.currentResult == "SUCCESS" ) {
		buildSummary = "Job:  ${env.JOB_NAME}\n Status: *SUCCESS*\n Build Report: ${env.BUILD_URL}CI-Build-HTML-Report"

		slackSend color : "good", message: "${buildSummary}", channel: '#test-ci-alerts'
		}
	else {
		buildSummary = "Job:  ${env.JOB_NAME}\n Status: *FAILURE*\n Error description: *${CI_ERROR}* \nBuild Report :${env.BUILD_URL}CI-Build-HTML-Report"
		slackSend color : "danger", message: "${buildSummary}", channel: '#test-ci-alerts'
		}
}