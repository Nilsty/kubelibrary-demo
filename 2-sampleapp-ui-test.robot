*** Settings ***
Library  SeleniumLibrary
Library  String
Library  DebugLibrary

Test Setup      Init
Test Teardown   Close Browser

*** Variables ***
${URL}            https://brownnewton-watsonwolf.newapp.io/
${BROWSER}        Chrome
${HEADLESS_BROWSER_ENABLED}    False

*** Test Cases ***
Sample App UI test
    Title Should Be  Task list
    Create a task
    Task is saved

*** Keywords ***
Init
    Run keyword if  ${HEADLESS_BROWSER_ENABLED}
    ...  Start Headless Browser
    ...  ELSE
    ...  Open URL in Chrome Browser

Start Headless Browser
    ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}   add_argument    headless
    Call Method    ${chrome_options}   add_argument    disable-gpu
    ${options}=     Call Method     ${chrome_options}    to_capabilities

    ${chrome_options}=    Set Chrome Options
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Go To    ${URL}

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