pipeline {
    // This tells Jenkins to run on any available worker node
    agent any 

    

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
            tools {
                nodejs '18' // This MUST match the name you gave it in Step 2
            }
            steps {
                // Installs Express, Jest, Supertest, and other dependencies
                sh 'npm install'
            }
        }

        // --- NEW STAGE: The Agentic AI ---
        stage('AI Test Generation') {
            steps {
                withCredentials([string(credentialsId: 'ai-api-key', variable: 'GEMINI_API_KEY')]) {
                    echo "Bypassing the plugin: Waking up Gemini directly via Shell..."
                    
                    // We use standard Linux redirection ( > ) to save the AI's output into the file
                    sh '''
                        gemini --model "gemini-2.5-flash" \
                               --yolo \
                               --prompt "Read index.js. Understand the 6 electricity API endpoints. Generate a comprehensive test suite using Jest and Supertest. 
                               CRITICAL INSTRUCTIONS:
                               1. To prevent Jest open handles, ensure the server is closed after tests. Use an afterAll() block to close the server instance if app.listen is active.
                               2. The tests must check for 200 OK statuses and ensure the response body is defined, but do not strictly assert exact data values since you cannot see the underlying JSON files.
                               3. Include a test to handle a 404 error case. 
                               Write the complete, executable JavaScript code. Output ONLY raw javascript code without markdown blockquotes." \
                               > tests/api.test.js
                    '''
                }
            }
        }

        stage('Quality Gate: Unit Tests') {
            tools {
                nodejs '18' // This MUST match the name you gave it in Step 2
            }
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