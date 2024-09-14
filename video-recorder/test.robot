*** Settings ***
Library    Browser

*** Variables ***
${LOGIN_URL}    https://specify_video_recorder_site/login/email
${EMAIL}        your_mail@gmail.com
${PASSWORD}     your_password
@{PERMISSIONS}  camera    microphone

${CHECKS_TIMEOUT}    3s
# Could vary depending on the video size but here it is 60s for simplicity
${UPLOAD_TIMEOUT}    60s
${MODIFIED_VIDEO_NAME}    NewHappyVideoName

*** Test Cases ***
Test Video Recording And Video Editing
    Open Browser And Login

    Click    xpath=//button[contains(text(), 'Add video')]
    Click    xpath=//button[contains(text(), 'Record')]

    ${intial_videos_count}=    Get Videos Count

    #1 Check that the web-service page can successfully record the video
    Wait For Elements State    xpath=//button[contains(text(), 'Start recording')]    enabled    timeout=${CHECKS_TIMEOUT}
    Click    xpath=//button[contains(text(), 'Start recording')]

    Record Video

    Click    xpath=(//button[contains(@class, 'recording-controls__control')])[1]

    # Let JS some time to run and connect Upload button with handlers
    Sleep    2s
    Click    xpath=//button[contains(text(), 'Upload')]

    #2 Check that the video is recorded and uploaded to the web service
    Wait For Elements State  text="has been successfully uploaded to Reflectivity and is ready for use"    timeout=${UPLOAD_TIMEOUT}

    Click    xpath=//button[contains(text(), 'Save')]

    ${current_videos_count}=    Get Videos Count

    #3 Verify that the uploaded video is displaced on the web-service page after successful uploading
    Verify If One Is Greater By One    ${current_videos_count}    ${intial_videos_count}

    Open Video Editor

    #4 Check whether the user can change the video's title using the text field on the web-service page
    Fill Text    id=name    ${MODIFIED_VIDEO_NAME}

    Click    xpath=//button[contains(text(), 'Cancel')]

    #6 Сheck that the name of the video remains unchanged after clicking the button "Cancel"
    Verify If Video Name Was Not Changed

    Open Video Editor

    Fill Text    id=name    ${MODIFIED_VIDEO_NAME}

    Click    xpath=//button[contains(text(), 'Save')]

    #5 Check if the name of the video is updated after clicking the button "Save"
    Verify If Video Name Was Changed

    # Just some waiting time to see the changed video result before the test exits
    Sleep    4s

    Close Browser

*** Keywords ***
Open Browser And Login
    [Documentation]    Login using custom credentials
    New Browser    headless=false
    New Context    permissions=${PERMISSIONS}
    New Page       ${LOGIN_URL}

    Fill Text    id=username    ${EMAIL}
    Fill Text    id=password    ${PASSWORD}

    Click    id=_submit

Record Video
    [Documentation]    Video will occupy 3 seconds for simplicity
    Sleep    3s

Get Videos Count
    [Documentation]    Returns current videos count on the web-service page
    ${videos}=    Get Elements    css=.video-card
    ${count}=    Evaluate    len(${videos})
    RETURN    ${count}

Verify If One Is Greater By One
    [Arguments]    ${first}    ${second}
    ${expected}=    Evaluate   ${second} + 1
    Should Be Equal As Numbers    ${first}    ${expected}

Open Video Editor
    [Documentation]    Always opens the latest uploaded video
    ${video_properties_buttons}=  Get Elements  css=button[title='Open actions menu']
    Click    ${video_properties_buttons[0]}
    Click    xpath=//button[contains(text(), 'Edit video info')]

Verify If Video Name Was Changed
    [Documentation]    Verifies if the latest video name was changed
    # Give some time for getting title updated
    Sleep    ${CHECKS_TIMEOUT}
    ${videos}=    Get Elements    css=.card-info__headline
    ${video_name}=    Get Attribute    ${videos[0]}    title
    Should Be Equal As Strings   ${MODIFIED_VIDEO_NAME}    ${video_name}

Verify If Video Name Was Not Changed
    [Documentation]    Verifies if the latest video name was not changed
    # Give some time for making sure title was not updated
    Sleep    ${CHECKS_TIMEOUT}
    ${videos}=    Get Elements    css=.card-info__headline
    ${video_name}=    Get Attribute    ${videos[0]}    title
    Should Not Be Equal As Strings   ${MODIFIED_VIDEO_NAME}    ${video_name}
