#!/bin/bash
VENDOR="ibm"
ARCH="x86_64"
TYPE="jre"
VERSION="0.0.0.0"
for i in "$@"
do
case $i in
  -d=* | --distributor=*)
  VENDOR="${i#*=}"
  shift               # past argument value
  ;;
  -a=* | --architecture=*)
  ARCH="${i#*=}"
  shift               # past argument value
  ;;
  -t=* | --type=*)
  TYPE="${i#*=}"
  shift               # past argument value
  ;;
  -v=* | --version=*)
  VERSION="${i#*=}"
  shift               # past argument value
  ;;
  *)
                      # Unknown
  ;;
esac
done
echo "Java Distribution = ${VENDOR}"
echo "Architecture      = ${ARCH}"
echo "Java type         = ${TYPE}"
echo "Java release      = ${VERSION} "

# Usage
java_file="${VENDOR}-java-${ARCH}-${TYPE}-${VERSION}.bin"
echo "Checking for file $java_file"
if [ -f "/dockerstore/tars/$java_file" ]
then
  echo "$java_file found"
  echo "Createing Dockerfile for $java_file"
  cp /dockerstore/tars/$java_file /dockerrepo/tars/$java_file

  docker_file="java_${TYPE}_base_${VENDOR}_v${VERSION}.dkf_centos71"
  echo "Createing $docker_file"

  cp /dockerrepo/dkf/java_ibm_base.dkf_centos71 /dockerrepo/dkf/$docker_file
  echo "%s/default_distribution/${VENDOR}/g
  w
  q
  " | ex /dockerrepo/dkf/$docker_file
  echo "%s/default_architecture/${ARCH}/g
  w
  q
  " | ex /dockerrepo/dkf/$docker_file
  echo "%s/default_type/${TYPE}/g
  w
  q
  " | ex /dockerrepo/dkf/$docker_file
  echo "%s/default_version/${VERSION}/g
  w
  q
  " | ex /dockerrepo/dkf/$docker_file  

  docker_image="cos71_java_"${TYPE}"_base_"${VENDOR}":v1."${VERSION}
  echo "Now building docker image $docker_image"
  cd /dockerrepo
  docker build -f dkf/$docker_file -t=$docker_image .

  rm -rf /dockerrepo/tars/$java_file

else
  echo "$java_file not found in /dockerstore/tars - please check"
fi
