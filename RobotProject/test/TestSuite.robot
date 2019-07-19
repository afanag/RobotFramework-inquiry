*** Settings ***
Documentation  Simple example using SeleniumLibrary.
Library        SeleniumLibrary    
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
${prod}
${mess}
${URLS}
${password}

*** Test Cases ***
MainProgram
    Connect To Database        pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num}=       Row Count    SELECT * FROM inquiries_link; 
    @{output}=    Query        SELECT * FROM inquiries_link;
	:FOR	      ${index}     IN RANGE                        ${num}
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
	\    ${pass}                         Generate Random String   8                              [LETTERS]
	\    Set Test Variable               ${prod}                  ${prodQuantitya}  
	\    Set Test Variable               ${mess}                  ${message}  
	\    Set Test Variable               ${password}              ${pass}  
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
    \    ${value}=                       Evaluate                 random.randint(5, 7)             random
    \    sleep                           ${value} 
    \    ${nocategory}=                  Get Element Count        name=categoryWithNoSearchResult    
    \    Run Keyword If                  ${nocategory}>0          SelectCategory
    \    Click Button                    id=id_save_button
    \    ${value}=                       Evaluate                 random.randint(1, 5)             random
    \    sleep                           ${value} 
    \    ${register}=                    Get Element Count        id=message_diaog    
    \    Log                             ${register}
    \    Run Keyword If                  ${register}>0            RegisteredUser    ${INQUIRY_ID}   ELSE                    NewUser
    \    MoreProductLoop                 ${URLCNT}
    \    UpdateInquiryMessage            ${INQUIRY_ID}	Submitted	${password}
    \    Close All Browsers
    Disconnect From Database


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
	Open Browser                    https://za.chinahomelife247.com/product/Handheld-Shower-Head-Unique-Design-of-Add-Shower-Gel-10125295.html?st=0&title=Handheld%20Shower%20Head%20Unique%20Design%20of%20Add%20Shower%20Gel                   ff  
    Set Browser Implicit Wait       10
    Click Element                   id=enquiry-dialog-btn
    Click Element                   id=register
    ${value}=                       Evaluate                 random.randint(5, 7)             random
    sleep                           ${value} 
    ${nocategory}=                  Get Element Count        name=categoryWithNoSearchResult    
    Run Keyword If                  ${nocategory}>0          SelectCategory


*** Keywords ***
RegisteredUser
    [Arguments]    ${inquiry_id}
    ${err}=                         Get Text    id=message_diaog
    UpdateInquiryMessage            ${inquiry_id}    ${err}    ${password}
    Close All Browsers
    Continue For Loop
    
NewUser
    Input Text                      id=prodQuantitya         ${prod}
    Click Element                   id=submitBtn        
    ${value}=  Evaluate             random.randint(5, 15)    random
    sleep    ${value} 
    
MoreProductLoop
    [Arguments]    ${n}
    :FOR    ${index}    IN RANGE    1    ${n}
    \    MoreProduct	${index}
        
MoreProduct
    [Arguments]    ${i}
    @{COLUMNS}=                     Split String             ${URLS}                        separator=,
    ${URL}=                         Get From List            ${COLUMNS}                     ${i}
    Go To	                        ${URL}
    Set Browser Implicit Wait       10
    Click Element                   id=enquiry-dialog-btn
    Sleep                           5
	Get Window Titles
	Select Window                   title=Smart Sourcing from China, the largest Online to Offline B2B Foreign Trade Marketplace, China Homelife 247
    NewUser
    
SelectCategory
    Click Element                   name=categoryWithNoSearchResult
    Select From List By Label       name=categoryWithNoSearchResult           Other
    
UpdateInquiryMessage
    [Arguments]    ${inquiry_id}    ${message}    ${password}
    Connect To Database            pymysql               ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    Execute SQL String             insert into inquiry_message values ('${inquiry_id}','${message}','${password}')
    
    