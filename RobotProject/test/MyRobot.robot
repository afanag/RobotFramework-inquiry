*** Settings ***
Documentation  CHL Inquiry and RFQ
Library        SeleniumLibrary    5.0    15.0    NOTHING    NONE
# timeout=5.0, implicit_wait=0.0, run_on_failure=Capture Page Screenshot, screenshot_root_directory=None, plugins=None, event_firing_webdriver=None
Library        Collections
Library        OperatingSystem
Library        String
Library        DatabaseLibrary

*** Variables ***
${RUN_COUNTRY}    in
${DBHost}         localhost
${DBName}         chl
${DBPass}         ${EMPTY}
${DBPort}         3306
${DBUser}         root

*** Test Cases ***    
MainProgramForInquiry
    Connect To Database        pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num}=       Row Count    SELECT * FROM inquiry_token WHERE COUNTRY LIKE '${RUN_COUNTRY}%';
    @{output}=    Query        SELECT * FROM inquiry_token WHERE COUNTRY LIKE '${RUN_COUNTRY}%';
    Log To Console    Loop Token, ${RUN_COUNTRY}, ${num}    STDOUT
	:FOR    ${index}	IN RANGE    ${num}
	\    Log    Loop Token ${index} of ${num}    
	\    Set Test Variable               ${INQUIRY_ID}            ${output[${index}][0]}
	\    Set Test Variable               ${purchaseQuantity}      ${output[${index}][1]}
	\    Set Test Variable               ${unit}                  ${output[${index}][2]}
	\    Set Test Variable               ${message}               ${output[${index}][3]}
	\    Set Test Variable               ${URLS}                  ${output[${index}][4]}
	\    Set Test Variable               ${URLCNT}                ${output[${index}][5]}
	\    Set Test Variable               ${COUNTRY}               ${output[${index}][6]}
	\    Set Test Variable               ${TOKEN}                 ${output[${index}][7]}
	\    ${attachLink}=                  Set Variable             ${output[${index}][8]}
	\    Run Keyword If                  ${purchaseQuantity} == 1    GetRandomQuantity
	\    ${URL}=                         Set Variable             http://${COUNTRY}.chinahomelife247.com/auth/2/${TOKEN}.html?jumpTo=/buyer/home/homeState.page
	\    Open Browser                    ${URL}                   ff    service_log_path=/Users/Alfan/Documents/eclipse-workspace/RobotProject/geckodriver.log
    \    Run Keyword And Ignore Error    JoinBanner
	\    @{COLUMNS}=                     Split String             ${URLS}                        separator=,
	\    ${URL}=                         Get From List            ${COLUMNS}                     0
	\    Go To	                         ${URL}${attachLink}
    \    Set Browser Implicit Wait       15
    \    Click Element                   id=enquiry-dialog-btn
    \    InquiryGetWindow    ${purchaseQuantity}    ${unit}    ${message}
    \    InquiryUpdateMessage	${INQUIRY_ID}    Updated    Token
    \    Run Keyword And Ignore Error	InquiryMoreProductLoop    ${URLS}    ${URLCNT}    ${purchaseQuantity}    ${unit}    ${message}    ${attachLink}    ${INQUIRY_ID}    Token
    \    Sleep    7
    \    Run Keyword And Ignore Error	JoinMeetingAlert
    \    Sleep    3
    \    InquiryUpdateMessage	${INQUIRY_ID}    Submitted    Token
    \    Close All Browsers
    Disconnect From Database
    Connect To Database        pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num}=                    Row Count    SELECT * FROM inquiry_link WHERE COUNTRY LIKE '${RUN_COUNTRY}%';  
    @{output}=                 Query        SELECT * FROM inquiry_link WHERE COUNTRY LIKE '${RUN_COUNTRY}%' ORDER BY INQUIRY_ID DESC;
    Log To Console    Loop Without Token, ${RUN_COUNTRY}, ${num}    STDOUT
	:FOR    ${index}	IN RANGE    ${num}
	\    Log    Loop Without Token ${index} of ${num}    
	\    Set Test Variable               ${INQUIRY_ID}            ${output[${index}][0]}
	\    Set Test Variable               ${fn}                    ${output[${index}][1]}
	\    Set Test Variable               ${email}                 ${output[${index}][2]}
	\    Set Test Variable               ${name}                  ${output[${index}][3]}
	\    Set Test Variable               ${countryId}             ${output[${index}][4]}
	\    Set Test Variable               ${mobile}                ${output[${index}][5]}
	\    Set Test Variable               ${purchaseQuantity}      ${output[${index}][6]}
	\    Set Test Variable               ${unit}                  ${output[${index}][7]}
	\    Set Test Variable               ${message}               ${output[${index}][8]}
	\    Set Test Variable               ${URLS}                  ${output[${index}][9]}
	\    Set Test Variable               ${URLCNT}                ${output[${index}][10]}
	\    Set Test Variable               ${website}               ${output[${index}][12]}
	\    ${attachLink}=                  Set Variable             ${output[${index}][13]}
	\    Set Test Variable               ${product}               ${output[${index}][14]}
	\    ${firstName}=                   Get Substring    ${fn}    0    22
	\    ${pass1}                        Generate Random String    5	[LETTERS][NUMBERS]
	\    ${pass2}                        Evaluate	random.randint(10,999)    random
	\    ${password}=                    Set Variable             ${pass1}${pass2}
	\    Run Keyword If                  ${purchaseQuantity} == 1    GetRandomQuantity
	\    @{COLUMNS}=                     Split String	${URLS}	    separator=,
	\    ${URL}=                         Get From List    ${COLUMNS}    0
	\    Open Browser                    ${URL}${attachLink}	ff    service_log_path=/Users/Alfan/Documents/eclipse-workspace/RobotProject/geckodriver.log
    \    Set Browser Implicit Wait       15
    \    Click Element                   id=enquiry-dialog-btn
    \    Click Element                   id=register        
    \    BuyerRegister    ${firstName}    ${email}    ${name}    ${password}    ${website}    ${countryId}    ${mobile}    ${product}
    \    Sleep                           15
    \    ${register}=                    Get Element Count        id=message_diaog    
    \    Run Keyword If                  ${register}>0            InquiryRegisteredUser    ${INQUIRY_ID}    ${EMPTY}
    \    ${missingfield}=                Get Element Count        id=prodQuantitya
    \    Run Keyword If                  ${missingfield}<1        InquiryMissingFieldUser    ${INQUIRY_ID}    ${EMPTY}
    \    InquiryUserDataInsert    ${purchaseQuantity}    ${unit}    ${message}  
    \    InquiryUpdateMessage	${INQUIRY_ID}    Updated    ${password}
    \    Run Keyword And Ignore Error    InquiryMoreProductLoop    ${URLS}    ${URLCNT}    ${purchaseQuantity}    ${unit}    ${message}    ${attachLink}    ${INQUIRY_ID}    ${password}
    \    Sleep    7
    \    Run Keyword And Ignore Error    JoinMeetingAlert
    \    Sleep    3
    \    InquiryUpdateMessage            ${INQUIRY_ID}	Submitted	${password}
    \    Close All Browsers
    Disconnect From Database

MainProgramForRFQ
    Connect To Database        pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num}=       Row Count    SELECT * FROM rfq_token where COUNTRY LIKE '${RUN_COUNTRY}%';
    @{output}=    Query        SELECT * FROM rfq_token where COUNTRY LIKE '${RUN_COUNTRY}%';
    Log To Console    Loop Token, ${RUN_COUNTRY}, ${num}    STDOUT
	:FOR	      ${index}     IN RANGE	    ${num}
	\    Log    Loop Token ${index} of ${num}    
	\    Set Test Variable               ${RFQ_ID}                ${output[${index}][0]}
	\    Set Test Variable               ${URL}                   ${output[${index}][1]}
	\    Set Test Variable               ${goodsName}             ${output[${index}][2]}
	\    Set Test Variable               ${purchaseQuantity}      ${output[${index}][3]}
	\    Set Test Variable               ${unit}                  ${output[${index}][4]}
	\    Set Test Variable               ${description}           ${output[${index}][5]}
	\    Set Test Variable               ${TOKEN}                 ${output[${index}][6]}
	\    Set Test Variable               ${COUNTRY}               ${output[${index}][7]}
	\    Set Test Variable               ${SUPPLIER_QUESTION}     ${output[${index}][8]}
	\    Run Keyword If                  ${purchaseQuantity} == 1    GetRandomQuantity
	\    ${URLTOKEN}=                    Set Variable             http://${COUNTRY}.chinahomelife247.com/auth/2/${TOKEN}.html?jumpTo=/buyer/home/homeState.page
	\    Open Browser                    ${URLTOKEN}              ff    service_log_path=/Users/Alfan/Documents/eclipse-workspace/RobotProject/geckodriver.log
	\    Go To	                         ${URL}
    \    Set Browser Implicit Wait       15
    \    Run Keyword And Ignore Error    JoinBanner
    \    Click Element                   id=categoryPlaceholder    
    \    ${msg} =    Run Keyword And Return Status    Wait Until Element Is Visible   class=category1    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Sleep                           8
    \    Click Element                   class=category1    
    \    ${msg} =    Run Keyword And Return Status    Wait Until Element Is Visible   class=category2    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Sleep                           1
    \    ${msg} =    Run Keyword And Return Status    Click Element                   class=category2    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Sleep                           1
    \    ${msg} =    Run Keyword And Return Status    Click Element                   xpath=//div[@class='category3-box']/p[@class='category3-tip']/span[@class='tag_check']    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    ${msg} =    Run Keyword And Return Status    Input Text                      class=category3-input    ${goodsName}
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Click Element                   class=category3-confirm    
    \    Input Text                      id=description           ${description}${\n}${SUPPLIER_QUESTION}
    \    Sleep                           10
    \    Run Keyword And Ignore Error    RFQAlert    ${RFQ_ID}    ${RFQ_ID}    Token
    \    Input Text                      id=purchaseQuantity      ${purchaseQuantity}
    \    Click Element                   name=unit
    \    Run Keyword And Ignore Error    UnitSelectByValue    ${unit}
    \    Click Element                   id=submitBtn0
    \    RFQUpdateMessage    ${RFQ_ID}    ${RFQ_ID}    Updated    Token
    \    Sleep                           5
    \    Run Keyword And Ignore Error    JoinMeetingAlert
    \    Sleep                           10
    \    ${Windowtitles}                 Get Window Titles
    \    Run Keyword If                  '${Windowtitles[0]}' != 'Smart Sourcing from China, the largest Online to Offline B2B Foreign Trade Marketplace, China Homelife 247'   RFQUpdateMessage    ${RFQ_ID}    ${RFQ_ID}    Submitted    Token     ELSE  RFQUpdateMessage    ${RFQ_ID}    ${RFQ_ID}    Quantity or Description Error    Token
    \    Close All Browsers
    Disconnect From Database
    Connect To Database        pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num}=       Row Count    SELECT * FROM rfq_link where COUNTRY LIKE '${RUN_COUNTRY}%';
    @{output}=    Query        SELECT * FROM rfq_link where COUNTRY LIKE '${RUN_COUNTRY}%' ORDER BY RFQ_ID DESC;
    Log To Console    Loop Without Token, ${RUN_COUNTRY}, ${num}    STDOUT
	:FOR	      ${index}     IN RANGE	    ${num}
	\    Log    Loop Without Token ${index} of ${num}    
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
	\    Set Test Variable               ${SUPPLIER_QUESTION}     ${output[${index}][13]}
	\    ${firstName}=                   Get Substring    ${fn}    0    22
	\    Run Keyword If                  ${purchaseQuantity} == 1    GetRandomQuantity
	\    ${pass1}                        Generate Random String    5	[LETTERS][NUMBERS]
	\    ${pass2}                        Evaluate	random.randint(10,999)	random
	\    ${password}=                    Set Variable             ${pass1}${pass2}
	\    Open Browser                    ${URL}                   ff    service_log_path=/Users/Alfan/Documents/eclipse-workspace/RobotProject/geckodriver.log
    \    Set Browser Implicit Wait       15
    \    Click Element                   id=categoryPlaceholder    
    \    ${msg} =    Run Keyword And Return Status    Wait Until Element Is Visible   class=category1    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Sleep                           8
    \    Click Element                   class=category1    
    \    ${msg} =    Run Keyword And Return Status    Wait Until Element Is Visible   class=category2    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Sleep                           1
    \    ${msg} =    Run Keyword And Return Status    Click Element                   class=category2    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Sleep                           1
    \    ${msg} =    Run Keyword And Return Status    Click Element                   xpath=//div[@class='category3-box']/p[@class='category3-tip']/span[@class='tag_check']    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    ${msg} =    Run Keyword And Return Status    Input Text                      class=category3-input    ${goodsName}
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Click Element                   class=category3-confirm    
    \    Input Text                      id=description           ${description}${\n}${SUPPLIER_QUESTION}
    \    ${value}=                       Evaluate                 random.randint(8, 10)            random
    \    Sleep                           ${value}
    \    Run Keyword And Ignore Error    RFQAlert    ${RFQ_ID}    ${RFQ_ID}    ${EMPTY}
    \    Input Text                      id=purchaseQuantity      ${purchaseQuantity}
    \    Click Element                   name=unit
    \    Run Keyword And Ignore Error    UnitSelectByValue    ${unit}
    \    Click Element                   id=submitBtn0
    \    Sleep                           3
    \    ${signupbutton}=                Run Keyword And Return Status    RfqClickSignup    
    \    Run Keyword Unless              ${signupbutton}    RFQDataError    ${RFQ_ID}    ${RFQ_ID}    ${EMPTY}
    \    Sleep    15
    \    Select Frame                    xpath=//iframe
    \    BuyerRegister    ${firstName}    ${email}    ${name}    ${password}    ${website}    ${countryId}    ${mobile}    ${goodsName}
    \    RFQUpdateMessage    ${RFQ_ID}    ${RFQ_ID}    Updated    ${password}
    \    Sleep                           5
    \    Run Keyword And Ignore Error    JoinMeetingAlert
    \    Sleep                           10
    \    ${Windowtitles}                 Get Window Titles
    \    Run Keyword And Ignore Error    JoinBanner
    \    Run Keyword If                  '${Windowtitles[0]}' != 'Smart Sourcing from China, the largest Online to Offline B2B Foreign Trade Marketplace, China Homelife 247'   RFQUpdateMessage    ${RFQ_ID}    ${RFQ_ID}    Submitted    ${password}     ELSE  RFQUpdateMessage    ${RFQ_ID}    ${RFQ_ID}    NotSubmitted    ${EMPTY}
    \    Close All Browsers
    Disconnect From Database

MainProgramForRFQMultipleProduct
    Connect To Database        pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num}=       Row Count    SELECT * FROM rfq_multiple_token where COUNTRY LIKE '${RUN_COUNTRY}%';
    @{output}=    Query        SELECT * FROM rfq_multiple_token where COUNTRY LIKE '${RUN_COUNTRY}%';
    ${counter}=    Set Variable    1
    Log To Console    Loop Token, ${RUN_COUNTRY}, ${num}    STDOUT
	:FOR	      ${index}     IN RANGE	    ${num}
	\    Log    Loop Token ${index} of ${num}    
    \    @{RFQ_ID_pre}=    Run Keyword And Ignore Error    RfqMultipleSavePreviousValue    ${output[${index-1}][1]}
	\    Set Test Variable               ${rfq_product_id}        ${output[${index}][0]}
	\    Set Test Variable               ${RFQ_ID}                ${output[${index}][1]}
	\    Set Test Variable               ${URL}                   ${output[${index}][2]}
	\    Set Test Variable               ${good}                  ${output[${index}][3]}
	\    Set Test Variable               ${purchaseQuantity}      ${output[${index}][4]}
	\    Set Test Variable               ${unit}                  ${output[${index}][5]}
	\    Set Test Variable               ${description}           ${output[${index}][6]}
	\    Set Test Variable               ${TOKEN}                 ${output[${index}][7]}
	\    Set Test Variable               ${COUNTRY}               ${output[${index}][8]}
	\    ${counter}    Set Variable If    '${RFQ_ID_pre[1]}'!='${RFQ_ID}'    1    ${counter}+1
    \    Run Keyword If 	${counter} > 3    RfqMultipeStopCounter
	\    Run Keyword If                  ${purchaseQuantity} == 1    GetRandomQuantity
	\    ${URLTOKEN}=                    Set Variable             http://${COUNTRY}.chinahomelife247.com/auth/2/${TOKEN}.html?jumpTo=/buyer/home/homeState.page
	\    Open Browser                    ${URLTOKEN}              ff    service_log_path=/Users/Alfan/Documents/eclipse-workspace/RobotProject/geckodriver.log
	\    Go To	                         ${URL}
    \    Set Browser Implicit Wait       15
    \    Run Keyword And Ignore Error    JoinBanner
    \    Click Element                   id=categoryPlaceholder    
    \    ${msg} =    Run Keyword And Return Status    Wait Until Element Is Visible   class=category1    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Sleep                           8
    \    Click Element                   class=category1    
    \    ${msg} =    Run Keyword And Return Status    Wait Until Element Is Visible   class=category2    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Sleep                           1
    \    ${msg} =    Run Keyword And Return Status    Click Element                   class=category2    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Sleep                           1
    \    ${msg} =    Run Keyword And Return Status    Click Element                   xpath=//div[@class='category3-box']/p[@class='category3-tip']/span[@class='tag_check']    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    ${msg} =    Run Keyword And Return Status    Input Text                      class=category3-input    ${good}
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Click Element                   class=category3-confirm    
    \    Input Text                      id=description           ${description}    # ${\n}${SUPPLIER_QUESTION}
    \    ${value}=                       Evaluate                 random.randint(8, 10)            random
    \    Sleep                           8
    \    Run Keyword And Ignore Error    RFQMultipleProductAlert    ${rfq_product_id}    ${RFQ_ID}
    \    Input Text                      id=purchaseQuantity      ${purchaseQuantity}
    \    Click Element                   name=unit
    \    Run Keyword And Ignore Error    UnitSelectByValue    ${unit}
    \    Click Element                   id=submitBtn0
    \    Sleep                           5
    \    Run Keyword And Ignore Error    JoinMeetingAlert
    \    Sleep                           10
    \    ${Windowtitles}                 Get Window Titles
    \    Run Keyword And Ignore Error    JoinBanner
    \    Run Keyword If                  '${Windowtitles[0]}' != 'Smart Sourcing from China, the largest Online to Offline B2B Foreign Trade Marketplace, China Homelife 247'   RFQUpdateMessage    ${rfq_product_id}    ${RFQ_ID}    Submitted    Token     ELSE  RFQUpdateMessage    ${rfq_product_id}    ${RFQ_ID}    Quantity or Description Error    Token
	\    Close All Browsers
    Disconnect From Database
    Connect To Database        pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    ${num}=       Row Count    SELECT * FROM rfq_multiple_link where COUNTRY = '${RUN_COUNTRY}';
    @{output}=    Query        SELECT * FROM rfq_multiple_link where COUNTRY = '${RUN_COUNTRY}';  
	Set Test Variable    ${login}    0
	Set Test Variable    ${password}    ${EMPTY}
    Log To Console    Loop Without Token, ${RUN_COUNTRY}, ${num}    STDOUT
	:FOR	      ${index}     IN RANGE	    ${num}
	\    Log    Loop Without Token ${index} of ${num}  
    \    @{RFQ_ID_pre}=    Run Keyword And Ignore Error    RfqMultipleSavePreviousValue    ${output[${index-1}][1]}
    \    @{RFQ_ID_next}=    Run Keyword And Ignore Error    RfqMultipleSaveNextValue    ${output[${index+1}][1]}
	\    Set Test Variable               ${rfq_product_id}        ${output[${index}][0]}
	\    Set Test Variable               ${RFQ_ID}                ${output[${index}][1]}
	\    Set Test Variable               ${fn}                    ${output[${index}][2]}
	\    Set Test Variable               ${email}                 ${output[${index}][3]}
	\    Set Test Variable               ${name}                  ${output[${index}][4]}
	\    Set Test Variable               ${countryId}             ${output[${index}][5]}
	\    Set Test Variable               ${mobile}                ${output[${index}][6]}
	\    Set Test Variable               ${URL}                   ${output[${index}][7]}
	\    Set Test Variable               ${good}                  ${output[${index}][8]}
	\    Set Test Variable               ${purchaseQuantity}      ${output[${index}][9]}
	\    Set Test Variable               ${unit}                  ${output[${index}][10]}
	\    Set Test Variable               ${description}           ${output[${index}][11]}
	\    Set Test Variable               ${website}               ${output[${index}][13]}
	\    ${counter}    Set Variable If    '${RFQ_ID_pre[1]}'!='${RFQ_ID}'    1    ${counter}+1
    \    Run Keyword If 	${counter} > 3    RfqMultipeStopCounter
    \    Run Keyword If 	${counter} > 1    Go To    ${URL}
         ...                ELSE    Open Browser	${URL}	ff    service_log_path=/Users/Alfan/Documents/eclipse-workspace/RobotProject/geckodriver.log
	\    ${firstName}=                   Get Substring    ${fn}    0    22
	\    Run Keyword If                  ${purchaseQuantity} == 1    GetRandomQuantity
    \    Set Browser Implicit Wait       15
    \    Click Element                   id=categoryPlaceholder    
    \    ${msg} =    Run Keyword And Return Status    Wait Until Element Is Visible   class=category1    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Sleep                           8
    \    Click Element                   class=category1    
    \    ${msg} =    Run Keyword And Return Status    Wait Until Element Is Visible   class=category2    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Sleep                           1
    \    ${msg} =    Run Keyword And Return Status    Click Element                   class=category2    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Sleep                           1
    \    ${msg} =    Run Keyword And Return Status    Click Element                   xpath=//div[@class='category3-box']/p[@class='category3-tip']/span[@class='tag_check']    
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    ${msg} =    Run Keyword And Return Status    Input Text                      class=category3-input    ${good}
    \    Run Keyword If    '${msg}'=='False'    RfqSelectCategoryProductFail    
    \    Click Element                   class=category3-confirm    
    \    Input Text                      id=description           ${description}
    \    Sleep                           15
    \    Run Keyword And Ignore Error    RFQMultipleProductAlert    ${rfq_product_id}    ${RFQ_ID}
    \    Input Text                      id=purchaseQuantity      ${purchaseQuantity}
    \    Click Element                   name=unit
    \    Run Keyword And Ignore Error    UnitSelectByValue    ${unit}
    \    Click Element                   id=submitBtn0
    \    Sleep                           3
    \    Run Keyword If    '${RFQ_ID}' != '${RFQ_ID_pre[1]}' or '${login}' == '0'    RfqSubmitPersonalInformation    ${rfq_product_id}    ${RFQ_ID}    ${firstName}    ${email}    ${name}    ${mobile}    ${website}    ${countryId}    ${good}
    \    Sleep                           5
    \    Run Keyword And Ignore Error    JoinMeetingAlert
    \    Sleep                           10
    \    ${Windowtitles}                 Get Window Titles
    \    Run Keyword And Ignore Error    JoinBanner
    \    Run Keyword If                  '${Windowtitles[0]}' != 'Smart Sourcing from China, the largest Online to Offline B2B Foreign Trade Marketplace, China Homelife 247'   RFQUpdateMessage    ${rfq_product_id}    ${RFQ_ID}    Submitted    ${password}     ELSE  RFQMultipleNotSubmitted    ${rfq_product_id}    ${RFQ_ID}
    \    Run Keyword If    '${RFQ_ID}' != '${RFQ_ID_next[1]}'    Close All Browsers
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
    Run Keyword If                  "${mess}"!="${EMPTY}"    InquiryPutMessage    ${mess}
    Click Element                   id=submitBtn     
    
InquiryPutMessage
    [Arguments]    ${mess}
    Input Text                      id=bottomInfoTextarea          ${mess}
    
InquiryMoreProductLoop
    [Arguments]    ${URLS}    ${n}    ${prod}    ${un}    ${mess}    ${attachLink}    ${INQUIRY_ID}    ${password}
    :FOR    ${index}    IN RANGE    1    ${n}
    \    Log    Product Loop ${index} of ${n}        
    \    InquiryUpdateMessage       ${INQUIRY_ID}    Updated-Product Loop ${index} of ${n}    ${password}
    \    InquiryMoreProduct    ${URLS}    ${index}    ${prod}    ${un}    ${mess}    ${attachLink}
        
InquiryMoreProduct
    [Arguments]    ${URLS}    ${i}    ${prod}    ${un}    ${mess}    ${attachLink}
    @{COLUMNS}=                     Split String             ${URLS}                        separator=,
    ${URL}=                         Get From List            ${COLUMNS}                     ${i}
    Sleep                           10
    Go To	                        ${URL}${attachLink}
    Set Browser Implicit Wait       15
    Click Element                   id=enquiry-dialog-btn
    InquiryGetWindow    ${prod}    ${un}    ${mess}
    
InquiryGetWindow
    [Arguments]    ${prod}    ${un}    ${mess}
    Sleep                           15
	Get Window Titles
	Select Window                   title:Smart Sourcing from China, the largest Online to Offline B2B Foreign Trade Marketplace, China Homelife 247
    InquiryUserDataInsert    ${prod}    ${un}    ${mess}
    
InquirySelectCategory
    Run Keyword And Ignore Error    InquiryClickSelectCategory    
    
InquiryClickSelectCategory
    Click Element                   name=categoryWithNoSearchResult
    Select From List By Value       name=categoryWithNoSearchResult           16544
    
InquiryUpdateMessage
    [Arguments]    ${inquiry_id}    ${message}    ${password}
    Connect To Database            pymysql               ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    Execute SQL String             REPLACE INTO inquiry_message values ('${inquiry_id}','${password}','${message}',current_timestamp());    
    
RFQUpdateMessage
    [Arguments]    ${rfq_product_id}    ${rfq_id}    ${message}    ${password}
    Connect To Database            pymysql               ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    Execute SQL String             REPLACE INTO rfq_message values ('${rfq_product_id}','${rfq_id}','${password}','${message}',current_timestamp());
    
RFQMPUpdateMessage
    [Arguments]    ${rfq_product_id}    ${rfq_id}    ${message}
    Connect To Database            pymysql               ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    Execute SQL String             REPLACE INTO rfq_message values ('${rfq_product_id}','${rfq_id}','','${message}',current_timestamp());
    Continue For Loop
    
RFQProductUpdate
    [Arguments]    ${rfq_id}    ${rfqproduct}
    Connect To Database            pymysql               ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    Execute SQL String             UPDATE rfq SET RFQ_COUNT='${rfqproduct}' WHERE RFQ_ID = '${rfq_id}';
    
RFQAlert
    [Arguments]    ${rfq_product_id}    ${RFQ_ID}    ${password}
    ${message}=	                 Handle Alert             ACCEPT
    Run Keyword                  RFQNoCategoryFound    ${rfq_product_id}    ${RFQ_ID}    ${message}    ${password}
    
RFQMultipleProductAlert
    [Arguments]    ${rfq_product_id}    ${RFQ_ID}
    ${message}=	                 Handle Alert             ACCEPT
    Run Keyword                  RFQMPUpdateMessage    ${rfq_product_id}    ${RFQ_ID}    Quantity or Description Error
    
RFQNoCategoryFound
    [Arguments]    ${rfq_product_id}    ${RFQ_ID}    ${message}    ${password}
    RFQUpdateMessage	${rfq_product_id}    ${RFQ_ID}    ${message}    ${password}
    Close All Browsers
    Continue For Loop
    
RFQDataError
    [Arguments]    ${rfq_product_id}    ${RFQ_ID}    ${password}
    RFQUpdateMessage	${rfq_product_id}    ${RFQ_ID}    Quantity or Description Error    ${password}
    Close All Browsers
    Continue For Loop
    
RFQMultipleNotSubmitted
    [Arguments]    ${rfq_product_id}    ${RFQ_ID}
    Set Test Variable    ${login}    0
    Run Keyword                  RFQMPUpdateMessage    ${rfq_product_id}    ${RFQ_ID}    NotSubmitted
    
GetRandomQuantity
    ${Quantity}=    Evaluate    random.randint(1,10)*5    random
    Set Test Variable    ${purchaseQuantity}    ${Quantity}
    
RfqClickSignup
    Click Element                   id=t20190328215607    
    
RfqSelectUnit
    [Arguments]    ${unit}
    Run Keyword And Ignore Error    UnitSelectByLabel    ${unit}
    Run Keyword And Ignore Error    UnitSelectByValue    ${unit}
    
UnitSelectByValue
    [Arguments]    ${unit}
    Select From List By Value       name=unit                ${unit}
    
UnitSelectByLabel
    [Arguments]    ${unit}
    Select From List By Label       name=unit                ${unit}

RfqMultipeStopCounter
    Set Test Variable    ${login}    0
    Close All Browsers
    Continue For Loop
    
RfqSelectCategoryProductFail
    Close All Browsers
    Continue For Loop
    
RfqMultipleSavePreviousValue
    [Arguments]    ${RFQ_ID_p}
    Set Test Variable               ${RFQ_ID_pre}                ${RFQ_ID_p}
	[Return]    ${RFQ_ID_pre}
    
RfqMultipleSaveNextValue
    [Arguments]    ${RFQ_ID_n}
    Set Test Variable               ${RFQ_ID_next}                ${RFQ_ID_n}
	[Return]    ${RFQ_ID_next}
	
RfqSubmitPersonalInformation
    [Arguments]    ${rfq_product_id}    ${RFQ_ID}    ${firstName}    ${email}    ${name}    ${mobile}    ${website}    ${countryId}    ${good}
    Log    RfqSubmitPersonalInformation
    ${pass1}                        Generate Random String   5                              [LETTERS][NUMBERS]
	${pass2}                        Evaluate                 random.randint(10,999)         random
	Set Test Variable    ${password}	${pass1}${pass2}
    ${error}=                       Get Element Count        id=firstName    
    Run Keyword If                  ${error}<1               RFQMPUpdateMessage    ${rfq_product_id}    ${RFQ_ID}    Quantity or Description Error
    ${signupbutton}=                Run Keyword And Return Status    RfqClickSignup    
    Run Keyword Unless              ${signupbutton}    RFQMPUpdateMessage    ${rfq_product_id}    ${RFQ_ID}    Quantity or Description Error
    Set Test Variable    ${login}    1
    Sleep    15
    Select Frame                    xpath=//iframe    
    BuyerRegister    ${firstName}    ${email}    ${name}    ${password}    ${website}    ${countryId}    ${mobile}    ${good}
    
BuyerRegister
    [Arguments]    ${firstName}    ${email}    ${name}    ${password}    ${website}    ${countryId}    ${mobile}    ${product}
    Input Text                      id=firstName             ${firstName}
    Input Text                      id=email                 ${email}
    Input Text                      id=name                  ${name}
    Input Password                  id=password              ${password}
    Input Text                      id=website               ${website}
    Click Element                   id=selectTag
    Wait Until Element Is Visible   class=category1    
    Sleep                           5
    Click Element                   class=category1    
    Wait Until Element Is Visible   class=category2    
    Sleep                           1
    Click Element                   class=category2    
    Sleep                           1
    Click Element                   xpath=//div[@class='category3-box show-tag-8']/p[@class='category3-tip tag_check_parent']/span[@class='tag_check']    
    Input Text                      class=category3-input    ${product}
    Click Element                   class=category3-confirm    
    Click Element                   name=countryId
    Select From List By Label       name=countryId           ${countryId}
    Input Text                      id=mobile                ${mobile}
    Click Button                    id=id_save_button
    
JoinBanner
    # Click Element                   class=pret-join
    # Sleep                           2
    Click Element                   class=pret-close
    
JoinMeetingAlert
    # Click Element                   class=meetingBtn
    Click Element                   class=closeBtn