*** Settings ***
Library    KubeLibrary    kube_config=my_kubeconfig.yaml

Documentation    Example test suite to check for running pod status

*** Variables ***
${NAMESPACE}      kube-sample-namespace

*** Test Cases ***
Verify Sample App
    Kubernetes API responds
    Waited for sample app pods to be running
    
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

