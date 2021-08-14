```yml
image: node
pipelines:
  branches:
    current-deployment-branch:
      - step:
          deployment: Production
          name: build and deployment
          size: 2x
          services:
            - docker
          script:
            - apt update
            - apt install python3 python3-pip -y
            - pip3 install awscli
            - IMAGE_NAME="xxxxxx.dkr.ecr.ap-southeast-2.amazonaws.com/ance-prod:ui-$BITBUCKET_BUILD_NUMBER"
            - ENVIRONMENT="prod"
            - REGION="ap-southeast-2"
            - docker build -t $IMAGE_NAME .
            - sed -i "s|containerImageName|$IMAGE_NAME|"  deployments/ui.yml
            - echo ${IMAGE_NAME}
            - aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}"
            - aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}"
            - eval $(aws ecr get-login --no-include-email --region ap-southeast-2 | sed 's;https://;;g')
            - docker push ${IMAGE_NAME}
            - pipe: atlassian/aws-eks-kubectl-run:1.2.0
              variables:
                AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
                AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
                AWS_DEFAULT_REGION: ${REGION}
                CLUSTER_NAME: ance-prod
                KUBECTL_COMMAND: apply
                RESOURCE_PATH:  deployments/
                DEBUG: "true"
definitions:
  services:
    docker:
      memory: 4096
```
