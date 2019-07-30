*** Settings ***
Documentation  Simple example using SeleniumLibrary.
Library        SeleniumLibrary    
Library        Collections
Library        OperatingSystem
Library        String
Library        DatabaseLibrary

*** Variables ***
${RUN_COUNTRY}    za
${DBHost}         localhost
${DBName}         chl
${DBPass}         
${DBPort}         3306
${DBUser}         root
${prod}
${mess}
${URLS}
${purchaseQuantity}
${un}

*** Test Cases ***    
MainProgramForInquiry
    Connect To Database        pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num}=       Row Count    SELECT * FROM inquiry_token WHERE COUNTRY = '${RUN_COUNTRY}'; 
    @{output}=    Query        SELECT * FROM inquiry_token WHERE COUNTRY = '${RUN_COUNTRY}';
	:FOR    ${index}	IN RANGE    ${num}
	\    Log    Loop ${index} of ${num}
	\    Set Test Variable               ${INQUIRY_ID}            ${output[${index}][0]}
	\    Set Test Variable               ${prodQuantitya}         ${output[${index}][1]}
	\    Set Test Variable               ${unit}                  ${output[${index}][2]}
	\    Set Test Variable               ${message}               ${output[${index}][3]}
	\    Set Test Variable               ${URLS}                  ${output[${index}][4]}
	\    Set Test Variable               ${URLCNT}                ${output[${index}][5]}
	\    Set Test Variable               ${COUNTRY}               ${output[${index}][6]}
	\    Set Test Variable               ${TOKEN}                 ${output[${index}][7]}
	\    Set Test Variable               ${prod}                  ${prodQuantitya}  
	\    Set Test Variable               ${mess}                  ${message}  
	\    Set Test Variable               ${un}                    ${unit}  
	\    ${URL}=                         Set Variable             http://${COUNTRY}.chinahomelife247.com/auth/2/${TOKEN}.html?jumpTo=/buyer/home/homeState.page
	\    Open Browser                    ${URL}                   ff  
	\    @{COLUMNS}=                     Split String             ${URLS}                        separator=,
	\    ${URL}=                         Get From List            ${COLUMNS}                     0
	\    Go To	                         ${URL}
    \    Set Browser Implicit Wait       10
    \    Click Element                   id=enquiry-dialog-btn
    \    ${value}=                       Evaluate                 random.randint(5, 7)             random
    \    sleep                           ${value} 
    \    InquiryGetWindow    ${prod}    ${un}    ${mess}
    \    InquiryUserDataInsert    ${prod}    ${un}    ${mess}
    \    Run Keyword And Ignore Error    InquiryMoreProductLoop    ${URLCNT}    ${prod}    ${un}    ${mess}
    \    InquiryUpdateMessage       ${INQUIRY_ID}    Submitted    Token
    \    Close All Browsers
    Disconnect From Database
    Connect To Database        pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num}=                    Row Count    SELECT * FROM inquiry_link WHERE COUNTRY = '${RUN_COUNTRY}';  
    @{output}=                 Query        SELECT * FROM inquiry_link WHERE COUNTRY = '${RUN_COUNTRY}';
	:FOR    ${index}	IN RANGE    ${num}
	\    Log    Loop ${index} of ${num}
	\    Set Test Variable               ${INQUIRY_ID}            ${output[${index}][0]}
	\    Set Test Variable               ${fn}                    ${output[${index}][1]}
	\    Set Test Variable               ${email}                 ${output[${index}][2]}
	\    Set Test Variable               ${name}                  ${output[${index}][3]}
	\    Set Test Variable               ${countryId}             ${output[${index}][4]}
	\    Set Test Variable               ${mobile}                ${output[${index}][5]}
	\    Set Test Variable               ${prodQuantitya}         ${output[${index}][6]}
	\    Set Test Variable               ${unit}                  ${output[${index}][7]}
	\    Set Test Variable               ${message}               ${output[${index}][8]}
	\    Set Test Variable               ${URLS}                  ${output[${index}][9]}
	\    Set Test Variable               ${URLCNT}                ${output[${index}][10]}
	\    Set Test Variable               ${website}               ${output[${index}][12]}
	\    ${firstName}=                   Get Substring    ${fn}    0    24
	\    ${pass1}                        Generate Random String   5                              [LETTERS][NUMBERS]
	\    ${pass2}                        Evaluate                 random.randint(10,999)         random
	\    ${pass}=                        Set Variable             ${pass1}${pass2}
	\    Set Test Variable               ${prod}                  ${prodQuantitya}  
	\    Set Test Variable               ${mess}                  ${message}  
	\    Set Test Variable               ${password}              ${pass}  
	\    Set Test Variable               ${un}                    ${unit}  
	\    @{COLUMNS}=                     Split String             ${URLS}                        separator=,
	\    ${URL}=                         Get From List            ${COLUMNS}                     0
	\    Open Browser                    ${URL}           ff  
    \    Set Browser Implicit Wait       10
    \    Click Element                   id=enquiry-dialog-btn
    \    Click Element                   id=register        
    \    Input Text                      id=firstName             ${firstName}
    \    Input Text                      id=email                 ${email}
    \    Input Text                      id=name                  ${name}
    \    Input Password                  id=password              ${password}
    \    Input Text                      id=mobile                ${mobile}
    \    Input Text                      id=website               ${website}
    \    ${value}=                       Evaluate                 random.randint(5, 7)             random
    \    sleep                           ${value} 
    \    ${nocategory}=                  Get Element Count        name=categoryWithNoSearchResult    
    \    Run Keyword If                  ${nocategory}>0          InquirySelectCategory
    \    Click Button                    id=id_save_button
    \    ${value}=                       Evaluate                 random.randint(1, 5)             random
    \    sleep                           ${value} 
    \    ${missingfield}=                Get Element Count        id=prodQuantitya
    \    Log    ${missingfield}
    \    Run Keyword If                  ${missingfield}<1        InquiryMissingFieldUser    ${INQUIRY_ID}    ${EMPTY}
    \    ${register}=                    Get Element Count        id=message_diaog    
    \    Run Keyword If                  ${register}>0            InquiryRegisteredUser    ${INQUIRY_ID}    ${EMPTY}   ELSE    InquiryUserDataInsert    ${prod}    ${un}    ${mess}    
    \    Run Keyword And Ignore Error    InquiryMoreProductLoop    ${URLCNT}    ${prod}    ${un}    ${mess}
    \    InquiryUpdateMessage            ${INQUIRY_ID}	Submitted	${password}
    \    Close All Browsers
    Disconnect From Database

MainProgramForRFQ
    Connect To Database        pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num}=       Row Count    SELECT * FROM rfq_token where COUNTRY = '${RUN_COUNTRY}'; 
    @{output}=    Query        SELECT * FROM rfq_token where COUNTRY = '${RUN_COUNTRY}';
	:FOR	      ${index}     IN RANGE	    ${num}
	\    Log    Loop ${index} of ${num}
	\    Set Test Variable               ${RFQ_ID}                ${output[${index}][0]}
	\    Set Test Variable               ${URL}                   ${output[${index}][1]}
	\    Set Test Variable               ${goodsName}             ${output[${index}][2]}
	\    Set Test Variable               ${purchaseQuantity}      ${output[${index}][3]}
	\    Set Test Variable               ${unit}                  ${output[${index}][4]}
	\    Set Test Variable               ${description}           ${output[${index}][5]}
	\    Set Test Variable               ${TOKEN}                 ${output[${index}][6]}
	\    Set Test Variable               ${COUNTRY}               ${output[${index}][7]}
	\    Run Keyword If                  '${goodsName}'=='${EMPTY}'        RFQNoProduct    ${RFQ_ID}    ${EMPTY}
	\    ${URLTOKEN}=                    Set Variable             http://${COUNTRY}.chinahomelife247.com/auth/2/${TOKEN}.html?jumpTo=/buyer/home/homeState.page
	\    Open Browser                    ${URLTOKEN}              ff  
	\    Go To	                         ${URL}
    \    Set Browser Implicit Wait       10
    \    Input Text                      id=goodsName             ${goodsName}
    \    Click Element                   class=button190213
    \    Sleep                           10
    \    Run Keyword And Ignore Error    RFQNoCategoryFoundAlert    ${RFQ_ID}    Token
    \    Run Keyword And Ignore Error    RFQNoCloseBanner
    \    Input Text                      id=purchaseQuantity      ${purchaseQuantity}
    \    Input Text                      id=description           ${description}
    \    Click Element                   name=unit
    \    Select From List By Value       name=unit                ${unit}
    \    ${value}=                       Evaluate                 random.randint(15, 20)            random
    \    sleep                           ${value}
    \    Click Element                   id=submitBtn0
    \    ${value}=                       Evaluate                 random.randint(15, 20)           random
    \    sleep                           ${value} 
    \    ${Windowtitles}                 Get Window Titles
    \    Run Keyword If                  '${Windowtitles[0]}' == 'China Homelife & Machinex 247 / O2O - Buyer Center'   RFQUpdateMessage    ${RFQ_ID}    Submitted    Token     ELSE  RFQUpdateMessage    ${RFQ_ID}    NotSubmitted    Token
    \    Close All Browsers
    Disconnect From Database
    Connect To Database        pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num}=       Row Count    SELECT * FROM rfq_link where COUNTRY = '${RUN_COUNTRY}'; 
    @{output}=    Query        SELECT * FROM rfq_link where COUNTRY = '${RUN_COUNTRY}';
	:FOR	      ${index}     IN RANGE	    ${num}
	\    Log    Loop ${index} of ${num}
	\    Set Test Variable               ${RFQ_ID}                ${output[${index}][0]}
	\    Set Test Variable               ${fn}                    ${output[${index}][1]}
	\    Set Test Variable               ${email}                 ${output[${index}][2]}
	\    Set Test Variable               ${name}                  ${output[${index}][3]}
	\    Set Test Variable               ${countryId}             ${output[${index}][4]}
	\    Set Test Variable               ${mobile}                ${output[${index}][5]}
	\    Set Test Variable               ${URL}                   ${output[${index}][6]}
	\    Set Test Variable               ${goodsName}             ${output[${index}][7]}
	\    Set Test Variable               ${purchaseQuantity}      ${output[${index}][8]}
	\    Set Test Variable               ${unit}                  ${output[${index}][9]}
	\    Set Test Variable               ${description}           ${output[${index}][10]}
	\    Set Test Variable               ${website}               ${output[${index}][12]}
	\    ${firstName}=                   Get Substring    ${fn}    0    24
	\    Run Keyword If                  '${goodsName}'=='${EMPTY}'        RFQNoProduct    ${RFQ_ID}    ${EMPTY}
	\    ${pass1}                        Generate Random String   5                              [LETTERS][NUMBERS]
	\    ${pass2}                        Evaluate                 random.randint(10,999)         random
	\    ${password}=                    Set Variable             ${pass1}${pass2}
	\    Open Browser                    ${URL}                   ff  
    \    Set Browser Implicit Wait       10
    \    Input Text                      id=goodsName             ${goodsName}
    \    Click Element                   class=button190213
    \    sleep                           10
    \    Run Keyword And Ignore Error    RFQNoCategoryFoundAlert    ${RFQ_ID}    ${EMPTY}
    \    Run Keyword And Ignore Error    RFQNoCloseBanner
    \    Input Text                      id=purchaseQuantity      ${purchaseQuantity}
    \    Input Text                      id=description           ${description}
    \    Click Element                   name=unit
    \    Select From List By Value       name=unit                ${unit}
    \    ${value}=                       Evaluate                 random.randint(15, 20)            random
    \    sleep                           ${value}
    \    Click Element                   id=submitBtn0
    \    sleep                           5
    \    ${error}=                       Get Element Count        id=firstName    
    \    Run Keyword If                  ${error}<1               RFQDataError    ${RFQ_ID}    ${EMPTY}
    \    ${signupbutton}=                Run Keyword And Return Status    RfqClickSignup    
    \    Run Keyword Unless              ${signupbutton}    RFQDataError    ${RFQ_ID}    ${EMPTY}
    \    Input Text                      id=firstName             ${firstName}
    \    Input Text                      id=email                 ${email}
    \    Input Text                      id=name                  ${name}
    \    Input Password                  id=password              ${password}
    \    Input Text                      id=mobile                ${mobile}
    \    Input Text                      id=website               ${website}
    \    Click Element                   id=id_save_button
    \    ${value}=                       Evaluate                 random.randint(20, 25)           random
    \    sleep                           ${value} 
    \    ${Windowtitles}                 Get Window Titles
    \    Run Keyword If                  '${Windowtitles[0]}' == 'China Homelife & Machinex 247 / O2O - Buyer Center'   RFQUpdateMessage    ${RFQ_ID}    Submitted    ${password}     ELSE  RFQUpdateMessage    ${RFQ_ID}    NotSubmitted    ${password}
    \    Close All Browsers
    Disconnect From Database

*** Keywords ***

InquiryRegisteredUser
    [Arguments]    ${inquiry_id}    ${password}
    ${err}=                         Get Text    id=message_diaog
    InquiryUpdateMessage            ${inquiry_id}    ${err}    ${password}
    Close All Browsers
    Continue For Loop
    
InquiryMissingFieldUser
    [Arguments]    ${inquiry_id}    ${password}
    InquiryUpdateMessage            ${inquiry_id}    MissingField    ${password}
    Close All Browsers
    Continue For Loop
    
InquiryUserDataInsert
    [Arguments]    ${prod}    ${un}    ${mess}
    Input Text                      id=prodQuantitya               ${prod}
    Click Element                   name=purchaseUom
    Select From List By Value       name=purchaseUom               ${un}
    Input Text                      id=bottomInfoTextarea          ${mess}
    Click Element                   id=submitBtn        
    Sleep                           5
    
InquiryMoreProductLoop
    [Arguments]    ${n}    ${prod}    ${un}    ${mess}
    :FOR    ${index}    IN RANGE    1    ${n}
    \    Log    Product Loop ${index} of ${n}
    \    InquiryMoreProduct	${index}    ${prod}    ${un}    ${mess}
        
InquiryMoreProduct
    [Arguments]    ${i}    ${prod}    ${un}    ${mess}
    @{COLUMNS}=                     Split String             ${URLS}                        separator=,
    ${URL}=                         Get From List            ${COLUMNS}                     ${i}
    Go To	                        ${URL}
    Set Browser Implicit Wait       10
    Click Element                   id=enquiry-dialog-btn
    InquiryGetWindow    ${prod}    ${un}    ${mess}
    
InquiryGetWindow
    [Arguments]    ${prod}    ${un}    ${mess}
    ${value}=                       Evaluate                 random.randint(5, 7)             random
    Sleep                           ${value}
	Get Window Titles
	Select Window                   title=Smart Sourcing from China, the largest Online to Offline B2B Foreign Trade Marketplace, China Homelife 247
	Set Browser Implicit Wait       10
    InquiryUserDataInsert    ${prod}    ${un}    ${mess}
    
InquirySelectCategory
    Click Element                   name=categoryWithNoSearchResult
    Select From List By Label       name=categoryWithNoSearchResult           Other
    
InquiryUpdateMessage
    [Arguments]    ${inquiry_id}    ${message}    ${password}
    Connect To Database            pymysql               ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    Execute SQL String             replace into inquiry_message values ('${inquiry_id}','${password}','${message}',current_timestamp());    
    
RFQUpdateMessage
    [Arguments]    ${rfq_id}    ${message}    ${password}
    Connect To Database            pymysql               ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    Execute SQL String             replace into rfq_message values ('${rfq_id}','${password}','${message}',current_timestamp());
    
RFQNoCategoryFoundAlert
    [Arguments]    ${RFQ_ID}    ${password}
    ${message}=	                 Handle Alert             ACCEPT
    Run Keyword If               '${message}' == 'No category information was obtained'   RFQNoCategoryFound    ${RFQ_ID}    ${message}    ${password}
    
RFQNoCategoryFound
    [Arguments]    ${RFQ_ID}    ${message}    ${password}
    RFQUpdateMessage	${RFQ_ID}    ${message}    ${password}
    Close All Browsers
    Continue For Loop
    
RFQDataError
    [Arguments]    ${RFQ_ID}    ${password}
    RFQUpdateMessage	${RFQ_ID}    Quantity or Description Error    ${password}
    Close All Browsers
    Continue For Loop
    
RFQNoProduct
    [Arguments]    ${RFQ_ID}    ${password}
    RFQUpdateMessage	${RFQ_ID}    No Product Error    ${password}
    Close All Browsers
    Continue For Loop
    
RFQQntyRandom
    ${Quantity}=            Evaluate                 random.randint(25, 150)          random
    [Return]    ${Quantity}
    
RFQNoCloseBanner
    Click Element                   class=pret-close
    
RfqClickSignup
    Click Element                   id=t20190328215607