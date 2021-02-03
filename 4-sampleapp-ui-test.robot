*** Settings ***
Library  SeleniumLibrary
Library  String

Resource  ./4-kube-keywords.resource

Suite Setup     Verify Kubernetes Setup of Sample App
Test Setup      Open URL in Chrome Browser
Test Teardown   Close Browser

Documentation  Example to combine the vaildation of kubernetes objects
...            and the UI of a sample app in one test suite

*** Variables ***
${URL}            https://sawaynoreillykonopelskischmeler.newapp.io/
${BROWSER}        Chrome

*** Test Cases ***
Sample App UI test
    Title Should Be  Task list
    Create a task
    Task is saved

*** Keywords ***
Open URL in Chrome Browser
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed   0.5 seconds

Create a task
    ${random_title}=  Generate Random String  8  	[LOWER]
    Set Global Variable  ${random_title}  ${random_title}
    Input Text   css:.title  ${random_title}

    ${random_body}=  Generate Random String  20  	[LOWER]
    Set Global Variable  ${random_body}  ${random_body}
    Input Text   css:.content  ${random_body}

    Click Button  Post Task

Task is saved
    Page Should Contain  ${random_title}
    Page Should Contain  ${random_body}