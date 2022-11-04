@echo off
@REM set deploymentName=%1

kubectl -n default get deployment %deploymentName%

IF %errorLevel% == 0 (
    echo "deployment %deploymentName% doesnt exist"
    kubectl -n default apply -f k8s_deployment_service.yaml
) ELSE (    
    echo "deployment %deploymentName% exist"
    echo "image name - %imageName%"
    kubectl -n default set image deploy %deploymentName% %containerName%=%imageName% --record=true
)

@REM echo 'error level: %errorLevel%'