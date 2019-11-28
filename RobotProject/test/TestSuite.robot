*** Settings ***
Documentation  Simple example using SeleniumLibrary.
Library        SeleniumLibrary        5.0    15.0    NOTHING    NONE
Library        Collections
Library        OperatingSystem
Library        String
Library        DatabaseLibrary
*** Variables ***
${DBHost}         localhost
${DBName}         chl
${DBPass}         
${DBPort}         3306
${DBUser}         root
*** Test Cases ***
DBTesting
    Connect To Database    pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    Execute SQL String             replace into inquiry_message values ('76','Token','Submitted',current_timestamp());  
    # ${num} =    Row Count    SELECT * FROM inquiries_link; 
    # @{output} =    Query    SELECT * FROM inquiries_link; 
    # Log    ${num}
    # FOR    ${index}    IN RANGE    ${num}
    # \    Set Test Variable    ${country}                        ${output[${index}][4]}+
    # \    @{countryId}=    Split String    ${country}    +
    # \    Log    ${countryId[0]}
    # \    ${type} =    Evaluate    type(${countryId[0]}).__name__
    Disconnect From Database
    
CSVFileTesting
	${contents}=     Get File    data.csv
    @{lines}=        Split to lines  ${contents}
	:FOR       ${line}  IN  @{lines}
	\    @{COLUMNS}=                     Split String             ${LINE}        separator=,
	\    ${URL}=                         Get From List            ${COLUMNS}     0
	\    ${firstName}=                   Get From List            ${COLUMNS}     1
	\    ${email}=                       Get From List            ${COLUMNS}     2
	\    Log    ${URL}
	\    Log    ${firstName}
	\    Log    ${email}
	
BrowserTesting
    Open Browser    http://bz.chinahomelife247.com/auth/2/1DBEF328B1206FEDB024C07AE0803177.html?jumpTo=/buyer/home/homeState.page?lang=en    ff
    ${Windowtitles}                 Get Window Titles
    Log    ${Windowtitles[0]}
    Go To    https://bz.chinahomelife247.com/product/10202234.html?lang=en
    Run Keyword If                  '${Windowtitles[0]}' == 'China Homelife & Machinex 247 / O2O - Buyer Center'   Testing    t    ELSE  Testing    f    
    
*** Keywords ***
Testing
    [Arguments]    ${inquiry_id}
    Log 	       ${inquiry_id}
