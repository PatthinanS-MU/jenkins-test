pipeline {
    // This tells Jenkins to run on any available worker node
    agent any 

    tools {
        nodejs '18' // This MUST match the name you gave it in Step 2
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

        // --- NEW STAGE: The Agentic AI ---
        stage('AI Test Generation') {
            steps {
                withCredentials([string(credentialsId: 'openrouter-api-key', variable: 'OPENAI_API_KEY')]) {
                    withEnv(['OPENAI_BASE_URL=https://openrouter.ai/api/v1']) {
                        
                        // NEW: Wrap the plugin call explicitly in the NodeJS environment
                        nodejs('NodeJS-18') {
                            echo "Waking up the AI Agent via OpenRouter..."
                            
                            aiAgent(
                                model: 'google/gemini-2.5-flash',
                                prompt: '''
                                    Read the file `index.js`. 
                                    Understand the 6 electricity API endpoints and their expected JSON structures.
                                    Generate a comprehensive test suite using Jest and Supertest.
                                    The tests must check for 200 OK statuses, correct data types, and handle a 404 error case.
                                    Write the complete, executable JavaScript code into a new file located at `tests/api.test.js`.
                                    CRITICAL: Output ONLY raw javascript code. Do not wrap it in markdown blockquotes.
                                ''',
                                yoloMode: true 
                            )
                        }
                        
                    }
                }
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