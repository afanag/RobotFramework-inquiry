*** Settings ***
Documentation  Simple example using SeleniumLibrary.
Library        SeleniumLibrary    
Library        Collections
Library        OperatingSystem
Library        String
Library        DatabaseLibrary

*** Variables ***
# ${DBHost}         chl2019.com
# ${DBName}         a33d41d6_chl
# ${DBPass}         PrewarPramLispsSneeze
# ${DBPort}         3306
# ${DBUser}         a33d41d6_chl
${DBHost}         localhost
${DBName}         chl
${DBPass}         
${DBPort}         3306
${DBUser}         root
${prod}
${mess}
${URLS}

*** Test Cases ***
MainProgram
    Connect To Database    pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num} =    Row Count    SELECT * FROM inquiries_link; 
    @{output} =    Query    SELECT * FROM inquiries_link;
	:FOR    ${index}    IN RANGE    ${num}
	# \    @{COLUMNS}=                     Split String             ${LINE}                    separator=,
	# \    ${URL}=                         Get From List            ${COLUMNS}                 1
	\    Set Test Variable               ${INQUIRY_ID}            ${output[${index}][0]}
	\    Set Test Variable               ${firstName}             ${output[${index}][1]}
	\    Set Test Variable               ${email}                 ${output[${index}][2]}
	\    Set Test Variable               ${name}                  ${output[${index}][3]}
	\    Set Test Variable               ${countryId}             ${output[${index}][4]}
	\    Set Test Variable               ${mobile}                ${output[${index}][5]}
	\    Set Test Variable               ${prodQuantitya}         ${output[${index}][6]}
	\    Set Test Variable               ${message}               ${output[${index}][7]}
	\    Set Test Variable               ${URLS}                  ${output[${index}][8]}
	\    Set Test Variable               ${URLCNT}                ${output[${index}][9]}
	\    ${password}                     Generate Random String   8                              [LETTERS]
	\    Set Test Variable               ${prod}                  ${prodQuantitya}  
	\    Set Test Variable               ${mess}                  ${message}  
	\    @{COLUMNS}=                     Split String             ${URLS}                        separator=,
	\    ${URL}=                         Get From List            ${COLUMNS}                     0
	\    Open Browser                    ${URL}                   ff  
    \    Set Browser Implicit Wait       10
    \    Click Element                   id=enquiry-dialog-btn
    \    Click Element                   id=register        
    \    Input Text                      id=firstName             ${firstName}
    \    Input Text                      id=email                 ${email}
    \    Input Text                      id=name                  ${name}
    \    Input Password                  id=password              ${password}
    \    Click Element                   name=countryId
    \    Select From List By Label       name=countryId           ${countryId}
    \    Input Text                      id=mobile                ${mobile}
    \    ${value}=                       Evaluate                 random.randint(5, 7)      random
    \    sleep                           ${value} 
    \    Click Button                    id=id_save_button
    \    ${value}=                       Evaluate                 random.randint(1, 5)      random
    \    sleep                           ${value} 
    \    ${register}=                    Get Element Count        id=message_diaog    
    \    Log                             ${register}
    \    Run Keyword If                  ${register}>0            RegisteredUser            ELSE                    NewUser
    \    MoreProductLoop                 ${URLCNT}
    \    Log    Finish
    \    Close Browser


DBTesting
    Connect To Database    pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num} =    Row Count    SELECT * FROM inquiries_link; 
    @{output} =    Query    SELECT * FROM inquiries_link; 
    Log    ${num}
    FOR    ${index}    IN RANGE    ${num}
    \    Set Test Variable    ${country}                        ${output[${index}][4]}+
    \    @{countryId}=    Split String    ${country}    +
    \    Log    ${countryId[0]}
    \    ${type} =    Evaluate    type(${countryId[0]}).__name__
    Disconnect From Database
    
DBTesting1
    Connect To Database    pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num} =    Row Count    SELECT * FROM inquiries_link; 
    @{output} =    Query    SELECT * FROM inquiries_link; 
    Log    ${num}
    :FOR    ${index}    IN RANGE    ${num}
    \    Set Test Variable               ${INQUIRY_ID}            ${output[${index}][0]}
    \    Set Test Variable               ${URLS}                  ${output[${index}][8]}
    \    Set Test Variable               ${n}                  ${output[${index}][9]}
    \    Log    ${INQUIRY_ID}
	\    @{COLUMNS}=                     Split String             ${URLS}                        separator=,
	\    ${URL}=                         Get From List            ${COLUMNS}                     0
	\    Log                             ${URL}
	\    Run Keyword If                  ${n}>1            MoreProductLoop    ${n}             
	\        
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
	
*** Keywords ***
RegisteredUser
    ${err}=    Get Text    id=message_diaog
    Log    ${err}
    Close Browser
    Continue For Loop
    
NewUser
    Input Text                      id=prodQuantitya         ${prod}
    Click Element                   id=submitBtn        
    ${value}=  Evaluate             random.randint(5, 15)    random
    sleep    ${value} 
    
MoreProductLoop
    [Arguments]    ${n}
    :FOR    ${index}    IN RANGE    1    ${n}
    \    MoreProduct    ${index}
        
MoreProduct
    [Arguments]    ${i}
    @{COLUMNS}=                     Split String             ${URLS}                        separator=,
    ${URL}=                         Get From List            ${COLUMNS}                     ${i}
    Open Browser                    ${URL}                   ff  
    Set Browser Implicit Wait       10
    Click Element                   id=enquiry-dialog-btn
    NewUser
    