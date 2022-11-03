@echo off

SET dockerImageName=openjdk:8-jdk-alpine
echo "%dockerImageName%"

docker run --rm -v D:\volumes\trivy:/root/.cache/ aquasec/trivy:0.34.0 -q image --exit-code 0 --severity HIGH --light %dockerImageName%
docker run --rm -v D:\volumes\trivy:/root/.cache/ aquasec/trivy:0.34.0 -q image --exit-code 1 --severity CRITICAL --light %dockerImageName%

SET exit_code=%errorLevel%
echo "Exit Code : %exit_code%"

IF %exit_code% == 1 (
  echo "Image scanning failed. Vulnerabilities found"
  exit 1
) ELSE (
  echo "Image scanning passed. No CRITICAL vulnerabilities found"
)