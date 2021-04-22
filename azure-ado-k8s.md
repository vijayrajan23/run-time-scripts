-------

    kubectl config view --minify -o jsonpath={.clusters[0].cluster.server}
    kubectl create serviceaccount ado-serviceaccount -n kube-system
    kubectl get serviceaccount ado-serviceaccount -n kube-system -o=jsonpath={.secrets[*].name}
    kubectl get secret ado-serviceaccount-token-xxxx -n kube-system -o json

-------



azure-pipelines.yml
-------

```yml
trigger: none

resources:
- repo: self

pool: 
  name: miga
  demands:  
  - Agent.ComputerName -equals access-server

steps:
  - task: KubernetesManifest@0
    displayName: kubernetes-deploy
    inputs:
      kubernetesServiceConnection: dev-aks-ado-service-account
      namespace: nifi-dev
      manifests: deployment/file.yml
```
-------


build

azure-pipelines.yml

```yml
name: $(Date:yyyyMMdd)$(Hours)$(Minutes)$(Rev:.r)

trigger:
  branches:
    include:
      - master
pr:
- master

resources:
- repo: self

variables:
  repositoryName: acriodemoslockdev.azurecr.io
  imageName: api-one

pool: 
  name: miga
  demands:  
  - Agent.ComputerName -equals access-server
- job: development
  steps:
    - task: Docker@2
      displayName: Build Docker Image
      condition: contains(variables['build.sourceBranch'], 'refs/heads/master')
      inputs:
        command: build
        containerRegistry: docker-service
        repository: $(imageName)
        Dockerfile: source/BackendService/Dockerfile
        tags: $(Build.BuildNumber)
        arguments: '--no-cache'



    - script: |
        docker run -d --name $(imageName)  $(repositoryName)/$(imageName):$(Build.BuildNumber)
        CID=$(docker ps -q -f status=running -f name=$(imageName))
        if [ ! "${CID}" ]; then
          echo "Container doesn't exist"
          exit 1
        else
          echo "Container Running"
        fi
        unset CID
      displayName: Verify Docker Image Running State
      condition: contains(variables['build.sourceBranch'], 'refs/heads/master')

    - script: |
        docker rm $(docker ps -aq --filter name=$(imageName))  -f
      displayName: Delete Running State Container
      condition: contains(variables['build.sourceBranch'], 'refs/heads/master')

    - task: Docker@2
      displayName: Push Docker Image to ACR
      inputs:
        command: push
        containerRegistry: docker-service
        repository: $(imageName)
        # Dockerfile: source/BackendService/Dockerfile
        tags: $(Build.BuildNumber)
      condition: contains(variables['build.sourceBranch'], 'refs/heads/master')

    - script: |
        Size=$(docker image inspect $(repositoryName)/$(imageName):$(Build.BuildNumber) --format='{{.Size}}')
        DockerSize=$((($Size/1024)/1024))
        echo "$(repositoryName)/$(imageName):$(Build.BuildNumber) image size: $DockerSize Mb"
        unset Size
        docker rmi $(repositoryName)/$(imageName):$(Build.BuildNumber)
      displayName: Remove Last Build Image
      condition: contains(variables['build.sourceBranch'], 'refs/heads/master')

    - script: |
        tag=$(Build.BuildNumber)
        imageNameandversion=$(imageName):$tag
        repositoryName=$(repositoryName)
        sed -i 's/containerImageName/'"$repositoryName\/$imageNameandversion"'/g' source/kubernetes-deployment/api-one.yml
      displayName: Preparing the k8s deployment file
      condition: contains(variables['build.sourceBranch'], 'refs/heads/master')

    - task: PublishPipelineArtifact@1
      inputs:
        targetPath: source/kubernetes-deployment/api-one.yml
        artifact: drop
      displayName: Publish Pipeline Artifact
      condition: contains(variables['build.sourceBranch'], 'refs/heads/master')
```
