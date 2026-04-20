curl -fsSL https://deb.nodesource.com/setup_18.x | bash -


docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
docker exec -u root -it flamboyant_kepler bash
docker exec -u root -it condescending_antonelli bash

condescending_antonelli

npm install -g @google/gemini-cli
gemini --version

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs
node -v