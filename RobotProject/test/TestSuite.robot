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
MainProgramForInquiry
    Connect To Database        pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num}=                    Row Count    SELECT * FROM inquiry_link; 
    @{output}=                 Query        SELECT * FROM inquiry_link;
	:FOR    ${index}	IN RANGE    ${num}
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
	\    ${pass1}                        Generate Random String   5                              [LETTERS][NUMBERS]
	\    ${pass2}                        Evaluate                 random.randint(10,999)         random
	\    ${pass}=                        Set Variable             ${pass1}${pass2}
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
    \    Run Keyword If                  ${register}>0            RegisteredUser    ${INQUIRY_ID}   ELSE                    UserInquiryDataInsert
    \    Run Keyword And Ignore Error    MoreProductLoop          ${URLCNT}
    \    UpdateInquiryMessage            ${INQUIRY_ID}	Submitted	${password}
    \    Close All Browsers
    Disconnect From Database
    
MainProgramForTokenInquiry
    Connect To Database        pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num}=       Row Count    SELECT * FROM inquiry_token; 
    @{output}=    Query        SELECT * FROM inquiry_token;
	:FOR    ${index}	IN RANGE    ${num}
	\    Set Test Variable               ${INQUIRY_ID}            ${output[${index}][0]}
	\    Set Test Variable               ${prodQuantitya}         ${output[${index}][1]}
	\    Set Test Variable               ${message}               ${output[${index}][2]}
	\    Set Test Variable               ${URLS}                  ${output[${index}][3]}
	\    Set Test Variable               ${URLCNT}                ${output[${index}][4]}
	\    Set Test Variable               ${COUNTRY}               ${output[${index}][5]}
	\    Set Test Variable               ${TOKEN}                 ${output[${index}][6]}
	\    Set Test Variable               ${prod}                  ${prodQuantitya}  
	\    Set Test Variable               ${mess}                  ${message}  
	\    ${URL}=                         Set Variable             http://${COUNTRY}.chinahomelife247.com/auth/2/${TOKEN}.html?jumpTo=/buyer/home/homeState.page
	\    Open Browser                    ${URL}                   ff  
    \    ${value}=                       Evaluate                 random.randint(1, 5)             random
    \    sleep                           ${value} 
	\    @{COLUMNS}=                     Split String             ${URLS}                        separator=,
	\    ${URL}=                         Get From List            ${COLUMNS}                     0
	\    Go To	                         ${URL} 
    \    Set Browser Implicit Wait       10
    \    Click Element                   id=enquiry-dialog-btn
    \    ${value}=                       Evaluate                 random.randint(5, 7)             random
    \    sleep                           ${value} 
    \    GetInquiryWindow
    \    UserInquiryDataInsert
    \    ${value}=                       Evaluate                 random.randint(1, 5)             random
    \    sleep                           ${value} 
    \    Run Keyword And Ignore Error    MoreProductLoop          ${URLCNT}
    \    UpdateInquiryTokenMessage       ${INQUIRY_ID}    Submitted	
    \    Close All Browsers
    Disconnect From Database

MainProgramForRFQ
    Connect To Database        pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num}=       Row Count    SELECT * FROM rfq_link; 
    @{output}=    Query        SELECT * FROM rfq_link;
	:FOR	      ${index}     IN RANGE	    ${num}
	\    Set Test Variable               ${RFQ_ID}                ${output[${index}][0]}
	\    Set Test Variable               ${firstName}             ${output[${index}][1]}
	\    Set Test Variable               ${email}                 ${output[${index}][2]}
	\    Set Test Variable               ${name}                  ${output[${index}][3]}
	\    Set Test Variable               ${countryId}             ${output[${index}][4]}
	\    Set Test Variable               ${mobile}                ${output[${index}][5]}
	\    Set Test Variable               ${URL}                   ${output[${index}][6]}
	\    Set Test Variable               ${goodsName}             ${output[${index}][7]}
	\    ${pass1}                        Generate Random String   5                              [LETTERS][NUMBERS]
	\    ${pass2}                        Evaluate                 random.randint(10,999)         random
	\    ${pass}=                        Set Variable             ${pass1}${pass2}
	\    Open Browser                    ${URL}                   ff  
    \    Set Browser Implicit Wait       10
    \    Input Text                      id=goodsName             ${goodsName}
    \    ${value}=                       Evaluate                 random.randint(1, 5)           random
    # \    sleep                           ${value} 
    \    Click Element                   class=button190213
    \    ${value}=                       Evaluate                 random.randint(5, 7)           random
    \    sleep                           ${value} 
    \    ${purchaseQuantity}=            Evaluate                 random.randint(100, 1000)      random
    \    Input Text                      id=purchaseQuantity      ${purchaseQuantity}
    \    Input Text                      id=description           ${goodsName}
    \    Click Element                   name=unit
    \    Select From List By Label       name=unit                Unit
    # \    sleep                           ${value} 
    \    Click Element                   id=submitBtn0
    \    Set Browser Implicit Wait       10
    \    sleep                           ${value} 
    \    Click Element                   id=t20190328215607
    \    ${pass1}                        Generate Random String   5                              [LETTERS][NUMBERS]
	\    ${pass2}                        Evaluate                 random.randint(10,999)         random
	\    ${password}=                    Set Variable             ${pass1}${pass2}
    \    Input Text                      id=firstName             ${firstName}
    \    Input Text                      id=email                 ${email}
    \    Input Text                      id=name                  ${name}
    \    Input Password                  id=password              ${password}
    \    Input Text                      id=mobile                ${mobile}
    \    ${value}=                       Evaluate                 random.randint(5, 7)             random
    # \    sleep                           ${value} 
    \    Click Element                   id=id_save_button
    \    sleep    	                     20
    \    ${Windowtitles}                 Get Window Titles
    \    Run Keyword If                  '${Windowtitles[0]}' == 'China Homelife & Machinex 247 / O2O - Buyer Center'   UpdateRfqMessage    ${RFQ_ID}    Submitted    ${pass}     ELSE  UpdateRfqMessage    ${RFQ_ID}    NotSubmitted    ${pass}
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
    Open Browser    https://za.chinahomelife247.com/buyer/main.page?jumpto=%2Fbuyer%2Fhome%2FhomeState.page    ff
    sleep     15       
    ${Windowtitles}                 Get Window Titles
    Log    ${Windowtitles[0]}
    Run Keyword If                  '${Windowtitles[0]}' == 'China Homelife & Machinex 247 / O2O - Buyer Center'   Testing    t    ELSE  Testing    f    
    

*** Keywords ***
Testing
    [Arguments]    ${inquiry_id}
    Log 	       ${inquiry_id}

RegisteredUser
    [Arguments]    ${inquiry_id}
    ${err}=                         Get Text    id=message_diaog
    UpdateInquiryMessage            ${inquiry_id}    ${err}    ${password}
    Close All Browsers
    Continue For Loop
    
UserInquiryDataInsert
    Input Text                      id=prodQuantitya              ${prod}
    Input Text                      id=bottomInfoTextarea         ${mess}
    ${value}=  Evaluate             random.randint(5, 15)        random
    sleep    ${value} 
    Click Element                   id=submitBtn        
    ${value}=  Evaluate             random.randint(5, 15)        random
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
    GetInquiryWindow
    
GetInquiryWindow
    ${value}=                       Evaluate                 random.randint(5, 15)             random
    Sleep                           ${value}
	Get Window Titles
	Select Window                   title=Smart Sourcing from China, the largest Online to Offline B2B Foreign Trade Marketplace, China Homelife 247
	Set Browser Implicit Wait       10
    UserInquiryDataInsert
    
SelectCategory
    Click Element                   name=categoryWithNoSearchResult
    Select From List By Label       name=categoryWithNoSearchResult           Other
    
UpdateInquiryMessage
    [Arguments]    ${inquiry_id}    ${message}    ${password}
    Connect To Database            pymysql               ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    Execute SQL String             replace into inquiry_message values ('${inquiry_id}','${password}','${message}','NONE');
    
UpdateInquiryTokenMessage
    [Arguments]    ${inquiry_id}    ${message}
    Connect To Database            pymysql               ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    Execute SQL String             update inquiry_message set MESSAGE2 = '${message}' where INQUIRY_ID = '${inquiry_id}';
    
UpdateRfqMessage
    [Arguments]    ${rfq_id}    ${message}    ${password}
    Connect To Database            pymysql               ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    Execute SQL String             replace into inquiry_message values ('${rfq_id}','${password}','${message}','NONE');
    
    