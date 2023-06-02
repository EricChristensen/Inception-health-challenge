# Inception Health Technical Challenge
This project contains a public facing API for viewing the "checkins" of patients. Checkins are automatically added to the Checkin database to simulate patient checkins.


## Deploying
Run `./deploy.sh` from the root of the repository to stand up the infrastructure and begin triggering checkings.

Run `./destroy.sh` to tear down all the infrastructure created.

## Validating and Interacting with the API
After running the deploy command, the last line of output will be the url that GETs from the Checkin table. 

![api output](./docs/API_Output.png)
![empty patients](./docs/empty_patients.png)

Hitting this url after a few minutes, more and more patients will have checkins recorded. 
![filled patients](./docs/filled_patients.png)

## Architecture
For communicating with the DyanmoDB Checkins table, two lambda functions were used: `backend` and `checkin`. For exposing the backend lambda's retrieval of the Checkin information, an API Gateway is used to integrate with the `backend` lambda. For triggering the checkins to be added to the database, a cloudwatch rule was created triggering the `checkin` lambda every two minutes.

![General Architecture](./docs/IH_General_Architecture.png)

There is an interesting dependency for building the a lambda using a docker image and Amazon's Elastic Container Repository for storing the function code. Before the lambda infrastructure can be created, both the Elastic Container Repository and the image containing the function code must exists. We cannot simply specify a `depends on` relationship with the lambda and ECR in our terraform code, because the Image also needs to be uploaded to ECR, which will not be the case if we bundle the ECR and Lambda terraform code together. Because of this, to deploy all the necessary code together in one script, a `dependencies` infrastructure folder is created containing the ECR terraform code. Once we know the ECR is deployed we build our function image and push it to ECR. Then we can proceed with deploying the lambda infrastructure as well as the rest of the infrastructure necessary for the project. This is how the `./deploy.sh` script works to deploy all infrastructure and function code in a single script.

![ecr dependency](./docs/LambdaImageDependency.png)
