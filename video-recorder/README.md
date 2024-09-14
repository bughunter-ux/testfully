# Video Recorder Robot Framework Test

This repository contains Robot Framework test for video-recorder app/web-service.

## Prerequisites

*   [Python](https://www.python.org/) (preferably 3.9 or higher)
*   [Node.js](https://nodejs.org/en/download/package-manager) (follow the instructions link)
*   [Robot Framework](https://robotframework.org/) (pip install robotframework)
*   [Browser Library](https://marketsquare.github.io/robotframework-browser/)
    + `pip install robotframework-browser`
    + `rfbrowser init`

## How to run

1. Clone the repository
2. Install required libraries with pip
3. Specify in test.robot:
	* `${LOGIN_URL}` - Video Recorder URL
	* `${EMAIL}` - Your mail address
	* `${PASSWORD}` - Your password
4. Run the test with the command `robot -d test-report test.robot`

## Documentation

Please refer to [doc/checklists.md](doc/checklists.md) for the full checklist of tests. Currently, the test suite only verifies the 1-6 from 15 checks that have to be done intially.
