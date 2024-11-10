docker run -d --name jenkins-server -p 8080:8080 -p 50000:50000 \
-v $(pwd)/jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
jenkins-server