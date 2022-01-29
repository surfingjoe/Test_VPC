import hudson.tasks.test.AbstractTestResultAction

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

                    }
                }
            }

    post{
        success {
            script {
                statusComment = "[${env.JOB_NAME}] <${env.BUILD_URL}|#${env.BUILD_NUMBER}> completed succesfully for ${env.GIT_BRANCH} :tada:"
                slackSend color: 'good', message: 'VPC for Test Environment'
            }
        }
        failure {
            script {
                statusComment = getTestResultsMessage()
                slackSend color: 'danger', message: 'Build failure'
            }
        }
        aborted {
            script {
                statusComment = "[${env.JOB_NAME}] <${env.BUILD_URL}|#${env.BUILD_NUMBER}> for ${env.GIT_BRANCH} was aborted by ${getBuildUser()}"
                slackSend color: 'danger', message: 'Build Aborted'

        }
    }
}

String getTestResultsMessage() {
    AbstractTestResultAction testResultAction = currentBuild.rawBuild.getAction(AbstractTestResultAction.class)
    if (testResultAction != null) {
        def total = testResultAction.totalCount
        def failed = testResultAction.failCount
        def skipped = testResultAction.skipCount
        return "[${env.JOB_NAME}] <${env.BUILD_URL}|#${env.BUILD_NUMBER}> had test failures for ${env.GIT_BRANCH}.\n  Total: ${total}, Failed: ${failed}, Skipped: ${skipped}"
    } else {
        return "[${env.JOB_NAME}] <${env.BUILD_URL}|#${env.BUILD_NUMBER}> failed for ${env.GIT_BRANCH}"
    }
}

String getBuildUser() {
    return currentBuild.rawBuild.getCause(Cause.UserIdCause).getUserId()
}