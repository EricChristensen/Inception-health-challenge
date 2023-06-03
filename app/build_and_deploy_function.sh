
# Build the Dockerfile into a docker image
docker build -f Dockerfile.lambda -t 478135184665.dkr.ecr.us-east-1.amazonaws.com/inception_health_repository:latest . --no-cache

# Login to ecr.
aws ecr get-login-password \
  --region us-east-1 --profile inception-health \
  | docker login --username AWS --password-stdin 478135184665.dkr.ecr.us-east-1.amazonaws.com

# Push the built image to ecr
docker push 478135184665.dkr.ecr.us-east-1.amazonaws.com/inception_health_repository:latest

# The Lambda points to the latest image, but it will not replace the image/code it is currently
# using until you update the lambda.
aws lambda update-function-code \
  --profile inception-health \
  --function-name inception_backend_lambda \
  --image-uri 478135184665.dkr.ecr.us-east-1.amazonaws.com/inception_health_repository:latest \
  2>&1 > /dev/null

aws lambda update-function-code \
  --profile inception-health \
  --function-name inception_checkin_lambda \
  --image-uri 478135184665.dkr.ecr.us-east-1.amazonaws.com/inception_health_repository:latest \
  2>&1 > /dev/null
