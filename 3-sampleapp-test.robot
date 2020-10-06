*** Settings ***
Library    KubeLibrary    kube_config=my_kubeconfig.yaml
Library    Collections

*** Variables ***
${NAMESPACE}      d25f3564-16c3-4ba6-8c08-ca5a77339779
${CONFIGMAP}      sample-app-configmap-sample-app

*** Test Cases ***
Verify Sample App
    Kubernetes API responds
    Waited for sample app pods to be running
    Configmap contains correct PUBLIC_SERVER_URL
    
*** Keywords ***
Kubernetes API responds
    [Documentation]  Check if API response code is 200
    @{ping}=    k8s_api_ping
    Should Be Equal As integers    ${ping}[1]    200

Waited for sample app pods to be running
    Wait Until Keyword Succeeds    1min    5sec   Sample app pods are running

Sample app pods are running 
    @{namespace_pods}=    Get Pod Names In Namespace    .*sample.*    ${NAMESPACE}
    ${num_of_pods}=    Get Length    ${namespace_pods}
    Should Be True    ${num_of_pods} >= 1    No pods matching "sample" found
    FOR    ${pod}    IN    @{namespace_pods}
        ${status}=    Get Pod Status In Namespace    ${pod}    ${namespace}
        Should Be True     '${status}'=='Running'
    END

Configmap contains correct PUBLIC_SERVER_URL
    @{namespace_configmaps}=  Get Configmaps In Namespace    ${CONFIGMAP}  ${NAMESPACE}
    FOR  ${configmap}  IN  @{namespace_configmaps}
        Dictionary Should Contain Item    ${configmap.data}    PUBLIC_SERVER_URL    http://my-sample-service:8080
        ...  msg=PUBLIC_SERVER_URL not configured correctly.
    END

