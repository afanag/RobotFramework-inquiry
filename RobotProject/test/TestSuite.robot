*** Settings ***
Documentation  Simple example using SeleniumLibrary.
Library        SeleniumLibrary    
Library        Collections
Library        OperatingSystem
Library        String

*** Variables ***


*** Test Cases ***
CSVLoopTest
    ${contents}=     Get File    data.csv
    @{lines}=        Split to lines  ${contents}
	:FOR       ${line}  IN  @{lines}
	# \    Log    ${line}
	\    @{COLUMNS}=                     Split String             ${LINE}        separator=,
	\    ${URL}=                         Get From List            ${COLUMNS}     0
	\    ${firstName}=                   Get From List            ${COLUMNS}     1
	\    ${email}=                       Get From List            ${COLUMNS}     2
	\    ${name}=                        Get From List            ${COLUMNS}     3
	\    ${password}=                    Get From List            ${COLUMNS}     4
	\    ${countryId}=                   Get From List            ${COLUMNS}     5
	\    ${mobile}=                      Get From List            ${COLUMNS}     6
	\    ${prodQuantitya}=               Get From List            ${COLUMNS}     7
	\    Open Browser                    ${URL}                   ff  
    \    Set Browser Implicit Wait       10
    \    Click Element                   id=enquiry-dialog-btn
    \    Click Element                   id=register        
    \    Input Text                      id=firstName             ${firstName}
    \    Input Text                      id=email                 ${email}
    \    Input Text                      id=name                  ${name}
    \    Input Password                  id=password              ${password}
    \    Click Element                   name=countryId
    \    Select From List By Value       name=countryId           ${countryId}
    \    Input Text                      id=mobile                ${mobile}
    \    ${value}=  Evaluate             random.randint(3, 7)    random
    \    sleep    ${value} 
    \    Click Button                    id=id_save_button
    \    ${value}=  Evaluate             random.randint(1, 5)    random
    \    sleep    ${value} 
    \    Input Text                      id=prodQuantitya         ${prodQuantitya}
    \    Click Element                   id=submitBtn        
    \    ${value}=  Evaluate             random.randint(5, 15)    random
    \    sleep    ${value} 
    \    Close Browser
    
	
    