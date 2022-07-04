This folder executes Jenkins using Docker with additional of blue-ocean plugin.
To run it, execute the "run.sh" script.
After, open: http://127.0.0.1:8080


Usage: ./runJenkins.sh {dockerhub_username}

Where:
  dockerhub_username   (optional): Uses remote dockerhub repository when informed

> Note: update JENKINS_VERSION variable to the same as used on Dockerfile