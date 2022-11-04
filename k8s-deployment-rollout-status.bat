@echo off
@REM set deploymentName=%1

timeout /t 60

SET kubernetsResult=''

FOR /F "delims=" %%F IN ('kubectl -n default rollout status deploy %deploymentName% --timeout 5s') DO SET var=%%F

IF "%var%" equ "deployment "%deploymentName%" successfully rolled out" (
    echo "Deployment %deploymentName% Rollout is Success"
) ELSE (
    echo "Deployment %deploymentName% Rollout has Failed"
    kubectl -n default rollout undo deploy %deploymentName%
    exit 1;
)