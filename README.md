## The project
This project aims to create a simple VM, using Vagrant, with Docker and Jenkins configured.

## The structure
The structure contains:
- a vagrant folder -> here you can find the VM information (Vagrantfile), configure the number of VMs, memory, and CPUs. 
Also, there are some args to choose the Jenkins version.

- Jenkins folder -> here there are three types of Jenkins installation.
1 - basic -> as its name says, a basic version of the Jenkins
2 - blue-ocean -> a custom image with docker and blue ocean plugins installed
3 - custom -> a custom image where you can add more plugins to the end of the DockerFile file

## Requirements
To run the project, will you need:
a. [Virtual Box](https://www.virtualbox.org/wiki/Linux_Downloads)
b. [Vagrant](https://www.vagrantup.com/downloads)

## Running
To run the project follow the steps:
1 - go to the vagrant folder using your terminal
2 - run the command
```
vagrant up
```
3 - The process will provision a VM and all necessary things to Docker and Jenkins
4 - At the end of the process an IP will be shown, take note of it
5 - Open your browser http://192.168.2.150:8080/ and paste the initial password

> If you run vagrant provision, the Vagrant will rerun the scripts replacing the Docker and Jenkins installation.

## Cleaning up
To clear the project just run:
```
vagrant destroy
```

## Customizing
### Jenkins
To change the Jenkins image, go to the "jenkins/custom/Dockerfile"
There, you can change the base Jenkins image and add or remove plugins
Once the change is made, need to build a new image and push it to the docker hub:
```  
docker build -t greinvinicios/jenkins-custom:lts . &&
docker push greinvinicios/jenkins-custom:lts
```

### Vagrant
To change the number of VMs, memory, or CPU, go to vagrant/Vagrantfile
The variable NUM_VMs changes the number of VMs to create
The "public_network" section is possible to change the VM IP and the default bridge network
In the "setup-jenkins" section, it is possible to change the Jenkins image and the docker container image that runs Jenkins