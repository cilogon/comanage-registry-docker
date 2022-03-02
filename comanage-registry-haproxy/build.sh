#!/bin/bash

if [[ -z "${HAPROXY_VERSION}" ]] ; then
   echo "Please set HAPROXY_VERSION environment variable."
   echo "E.g., 'export HAPROXY_VERSION=2.5.4'"
   exit;
fi

docker build --no-cache -t cilogon-haproxy:${HAPROXY_VERSION} .

echo
echo "Now you can tag and upload the image to AWS ECR:"
echo "docker tag cilogon-haproxy:${HAPROXY_VERSION} 495649616520.dkr.ecr.us-east-2.amazonaws.com/cilogon-haproxy:${HAPROXY_VERSION}"
echo "docker push 495649616520.dkr.ecr.us-east-2.amazonaws.com/cilogon-haproxy:${HAPROXY_VERSION}"
