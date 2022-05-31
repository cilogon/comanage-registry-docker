VERSION=7
IMAGE=comanage-registry-getssl

if [[ -z "${HTTPD_VERSION}" ]] ; then
   echo "Please set HTTPD_VERSION environment variable."
   echo "E.g., 'export HTTPD_VERSION=2.4.53'"
   exit;
fi

docker build --build-arg HTTPD_VERSION --no-cache -t ${IMAGE}:${VERSION} .

echo
echo "If image built successfully, do the following."
echo
echo "First log in to AWS:"
echo
echo "    aws ecr get-login-password --region us-east-2 | \\"
echo "    docker login --username AWS --password-stdin \\"
echo "           495649616520.dkr.ecr.us-east-2.amazonaws.com"
echo
echo "Then tag and push the newly build image to AWS ECR:"
echo
echo "    docker tag ${IMAGE}:${VERSION} 495649616520.dkr.ecr.us-east-2.amazonaws.com/${IMAGE}:${VERSION}"
echo "    docker push 495649616520.dkr.ecr.us-east-2.amazonaws.com/${IMAGE}:${VERSION}"

