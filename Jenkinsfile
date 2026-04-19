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
                // 1. Pull the key from Jenkins credentials
                withCredentials([string(credentialsId: 'ai-api-key', variable: 'GOOGLE_API_KEY')]) {
                    
                    // 2. Duplicate the key into GEMINI_API_KEY just to be safe
                    withEnv(["GEMINI_API_KEY=${GOOGLE_API_KEY}"]) {
                        
                        // 3. Keep the NodeJS wrapper so the plugin can find 'npx'
                            echo "Waking up Gemini via AI Studio..."
                            
                            aiAgent(
                                agent: geminiCli(),
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