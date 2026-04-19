pipeline {
    // This tells Jenkins to run on any available worker node
    agent any 

    tools {
        nodejs 'NodeJS-18' // This MUST match the name you gave it in Step 2
    }

    // Defines the environment variables, similar to github.sha
    environment {
        DOCKER_TAG = "prod-${GIT_COMMIT[0..7]}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Pulls the latest code from your Git repository
                checkout scm
            }
        }

        stage('Setup & Install') {
            steps {
                // Installs Express, Jest, Supertest, and other dependencies
                sh 'npm install'
            }
        }

        stage('Quality Gate: Unit Tests') {
            steps {
                // Runs api.test.js. If this fails, the pipeline stops immediately.
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Packages the app ONLY if the tests passed
                echo "Building Docker Image: electricity-api:${DOCKER_TAG}"
                sh 'docker build -t electricity-api:${DOCKER_TAG} .'
            }
        }
    }
    
    post {
        success {
            echo "Pipeline completed successfully! The Docker image is ready."
        }
        failure {
            echo "Pipeline failed. Check the logs above to see if the tests or build broke."
        }
    }
}