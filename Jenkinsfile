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
        // stage('AI Test Generation') {
        //     steps {
        //         withCredentials([string(credentialsId: 'ai-api-key', variable: 'GEMINI_API_KEY')]) {
        //             echo "Bypassing the plugin: Waking up Gemini directly via Shell..."
                    
        //             // We use standard Linux redirection ( > ) to save the AI's output into the file
        //             sh '''
        //                 gemini --model "gemini-2.5-flash" \
        //                        --yolo \
        //                        --prompt "Read index.js. Understand the 6 electricity API endpoints. Generate a comprehensive test suite using Jest and Supertest. 
        //                        CRITICAL INSTRUCTIONS:
        //                        1. To prevent Jest open handles, ensure the server is closed after tests. Use an afterAll() block to close the server instance if app.listen is active.
        //                        2. The tests must check for 200 OK statuses and ensure the response body is defined, but do not strictly assert exact data values since you cannot see the underlying JSON files.
        //                        3. Include a test to handle a 404 error case. 
        //                        Write the complete, executable JavaScript code. Output ONLY raw javascript code without markdown blockquotes." \
        //                        > tests/api.test.js
        //             '''
        //         }
        //     }
        //     post {
        //         always {
        //             archiveArtifacts artifacts: 'tests/api.test.js', fingerprint: true
        //         }
        //     }
        // }

        stage('AI Test Generation') {
            steps {
                // Pull your API key from Jenkins
                withCredentials([string(credentialsId: 'openai-api-key', variable: 'OPENAI_API_KEY')]) {
                    echo "Waking up the OpenAI Codex CLI with bug-fixes..."
                    
                    sh '''
                        # Failsafe 1: Ensure both standard variables hold the key
                        export CODEX_API_KEY=$OPENAI_API_KEY
                        
                        # Failsafe 2: Apply the config override to prevent the 401 fallback bug
                        # Failsafe 3: Add --skip-git-repo-check so it doesn't panic inside the Jenkins workspace
                        
                        codex exec \
                              --yolo \
                              --skip-git-repo-check \
                              --config features.remote_models=false \
                              "Read index.js. Understand the 6 electricity API endpoints. Generate a comprehensive test suite using Jest and Supertest. 
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

        // stage('Build Docker Image') {
        //     steps {
        //         // Packages the app ONLY if the tests passed
        //         echo "Building Docker Image: electricity-api:${DOCKER_TAG}"
        //         sh 'docker build -t electricity-api:${DOCKER_TAG} .'
        //     }
        // }
    }
    
    post {
        success {
            echo "Pipeline completed successfully!."
        }
        failure {
            echo "Pipeline failed. Check the logs above to see if the tests or build broke."
        }
    }
}