
'################################################################################################################
'Name		:	Declare Global Variables
'################################################################################################################
Dim SlNumber
SlNumber=1
'################################################################################################################
RSAM_Load_RecoveryScenario
'################################################################################################################
' Function Name	: 	Generic_WshShell_Popup
' Parameters	:	Message, TimeinSeconds
' Return Type	:	Void
' Description  	:	1. This function popup a message for a specified amount of time
'							2. Message and Time are passed in the Parameters of the function.      
' Author    	:	Selva      
' Date Created	:	Jan 08, 2010
' Last Updated	:      
' Updated by  	:      
'################################################################################################################

Function Generic_WshShell_Popup(Message,TimeinSeconds)
	Set WshShell = Wscript.CreateObject("Wscript.Shell")
	WshShell.Popup Message,TimeinSeconds,"QTP Status Alert",64
End Function

'################################################################################################################


'################################################################################################################
' Function Name	: 	RSAM_Automation_Result_File_Create
' Parameters	:	Null
' Return Type	:	Returns the Name of the File Created
' Description  	:	1. This function is used to create the RSAM Log File in the html format.
'							2. The name of the html file would be "RSAM_Log_"appeneded with the date and Time 
'								of the function executed.
' Author    	:	Selva      
' Date Created	:	Jan 08, 2010
' Last Updated	:      
' Updated by  	:      
'################################################################################################################

Function RSAM_Automation_Result_File_Create ()
   Load_RSAM_Env_XML_File
	Dim fso, MyFile,FileName,FormattedTime,ReplacedTime,currTestPath,RSAM_Library_Path, prntfolder, rtFolder
	Set fso = CreateObject("Scripting.FileSystemObject")
	currTestPath = Environment.Value("TestDir")
	prntfolder = fso.GetParentFolderName(currTestPath)
	rtFolder = fso.GetParentFolderName(prntfolder)
	FormattedTime=CStr(Time)
	ReplacedTime=Replace(FormattedTime,":","-")
	Date_Value = FormatDateTime(Date,1)
	FileName="RSAM_Log_"&Date_Value&"@"&ReplacedTime&".html"
	FilePathName= rtFolder&"\RSAM_Results\"&FileName
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set MyFile = fso.CreateTextFile(FilePathName, True)
	MyFile.WriteLine("<html><Title>RSAM Automation Results</Title><Body><Center><table border='1' id='tbl1' bordercolor='LightBlue' background='images\RSAM_Header_Logo.jpg' width=90% height=11%><tr><td></td></tr></table><table border='1' id='tbl2'bordercolor='LightBlue'  width=90%><tr><th width=3%><Font Face='Verdana' Size='1'>Sl.No</Font></th><th width=10%><Font Face='Verdana' Size='1'>Test Case ID</Font></th><th><Font Face='Verdana' Size='1'>Step Description</Font></th><th width=18%><Font Face='Verdana' Size='1'>Expected Results</Font></th><th width=18%><Font Face='Verdana' Size='1'>Actual Results</Font></th><th width=9%><Font Face='Verdana' Size='1'>Time</Font></th><th width=5%><Font Face='Verdana' Size='1'>Result</Font></th></tr>")
	MyFile.Close
	'Environment.Value("ResultFileName") = FilePathName
	RSAM_Automation_Result_File_Create=FilePathName
End Function

'################################################################################################################

'################################################################################################################
' Sub Name	: 	RSAM_Automation_Result_File_Update
' Parameters	:	File_Name,TestCase_ID,SlNo,Step_Description,Expected_Result,Actual_Result,StepTime,Result
' Return Type	:	void
' Description  	:	   1. This function is used to update the RSAM Log File in the html format.
'							   2. Inorder to increment the "Sl.No" automatically a global variable has been defined.
'						      3. On passing the value "Fail" in the Result Parameter the cell background color becomes Red
'							 4. This function would fail if the log file does not exist.
'							5. As a pre condition the function "RSAM_Automation_Result_File_Create" should have been executed before calling this function.
'						   6. For the Parameter "File_Name" the value returned by the function "RSAM_Automation_Result_File_Create" should be passed
' Author    	:	Selva      
' Date Created	:	Jan 08, 2010
' Last Updated	:      
' Updated by  	:      
'################################################################################################################

Public Function RSAM_Automation_Result_File_Update(TestCase_ID,Step_Description,Expected_Result,Actual_Result,Result)
	Load_RSAM_Env_XML_File
	Dim File_Name
	File_Name = Environment.Value("ResultFileName")
	If Result="Fail" Then
	Result_Val= "<td bgcolor='Red'><Font Face='Verdana' Size='1' color='White'><b>Fail<b></td></tr>"
	Else
	Result_Val= "<td><Font Face='Verdana' Size='1'><b>"&Result&"<b></td></tr>"
	End If
	Const ForReading = 1, ForWriting = 2, ForAppending = 8
	Dim fso, file_append
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set file_append = fso.OpenTextFile(File_Name, ForAppending,False)
	file_append.Write "<tr onClick=(this.bgColor='Yellow') onMouseover=(this.bgColor='LightBlue') onMouseout=(this.bgColor='#FFFFFF')><td><Font Face='Verdana' Size='1'>"&SlNumber&"</td><td><Font Face='Verdana' Size='1'>"&TestCase_ID&"</td><td><Font Face='Verdana' Size='1'>"&Step_Description&"</td><td><Font Face='Verdana' Size='1'>"&Expected_Result&"</td><td><Font Face='Verdana' Size='1'>"&Actual_Result&"</td><td><Font Face='Verdana' Size='1'>"&Time&"</td>"&Result_Val&""
	file_append.Close
	SlNumber=SlNumber+1
End Function

'################################################################################################################

'################################################################################################################
' Function Name	: 	Load_RSAM_Env_XML_File
' Parameters	:	None
' Return Type	:	void
' Description  	:	   1. This function is used to Load the Environment XML file
'								2. The path will be taken based on the current directory of the test
'								3. To get parent folder the built in functions GetPArentFolder byname is used.
'								4. Then the RSAM Library folder is appended at the end of the string.
' Author    	:	Selva      
' Date Created	:	Jan 08, 2010
' Last Updated	:      
' Updated by  	:      
'################################################################################################################
Function Load_RSAM_Env_XML_File()
	Dim currTestPath,RSAM_Library_Path, prntfolder, rtFolder
	Set fso = CreateObject("Scripting.FileSystemObject")
	currTestPath = Environment.Value("TestDir")
	prntfolder = fso.GetParentFolderName(currTestPath)
	rtFolder = fso.GetParentFolderName(prntfolder)
	RSAM_Library_Path = rtFolder&"\"&"RSAM_Library"
    Environment.LoadFromFile(RSAM_Library_Path&"\"&"RSAM_Environment.xml")
End Function
'################################################################################################################

'################################################################################################################
' Function Name	: 	Get_Value_From_DB
' Parameters	:	ServerName,DBName,UserID,PWD,SQLQuery
' Return Type	:	Record Set will be returned in the form of a string
' Description  	:	   1. This function is used to connect to the database and get the values in the form of string 
'								2. The parameters need to be passed in order to call the function
'								3. At the end of the function all the db connections opened will be closed
'								
' Author    	:	Selva      
' Date Created	:	Feb 03, 2010
' Last Updated	:      
' Updated by  	:      
'################################################################################################################
Function Get_Value_From_DB(ServerName,DBName,UserID,PWD,SQLQuery)
	 'Create the connection string: 
	 strConn="DRIVER={SQL Server};SERVER="&ServerName&";database=" & DBName & ";User ID=" & UserID & ";Password=" & PWD & " ;" 
     Set oConn = CreateObject("ADODB.Connection") 
	 oConn.CursorLocation = 2 'Server-side cursor
	 oConn.Open strConn    'Establish the connection: 
     Set rs = CreateObject("ADODB.Recordset")  'Create a recordset to hold the results 
     rs.CursorType = 2 'Options for CursorType are:  0=Forward Only, 1=KeySet, 2=Dynamic, 3=Static (read-only) 
	 Set rs.ActiveConnection = oConn 
     rs.Open SQLQuery       'Execute the query and put the results into the recordset 
	 ' Verify record set is not null or empty 
	 If rs.fields.count <= 0 Then  
		RSAM_Automation_Result_File_Update "DB Results",SQLQuery,"Should return results","Did not return any results","Fail"
		Get_Value_From_DB = "Data NOT FOUND for SQLQuery Specified"
	 End If
	   ' Process Record Set
	 Do While Not rs.EOF = True
        Get_Value_From_DB = rs.GetString 'This will display the returned record
		RSAM_Automation_Result_File_Update "DB Results",SQLQuery,"Should return results",Get_Value_From_DB,"Pass"
	 Loop
     rs.Close ''Close the Recordset   
     Set strConn=Nothing  'Clear the connection string 
     Set oConn=Nothing ' Clear the connection to a database 
End Function
'################################################################################################################
'***********************************************************************************************************************
'* Module Description
'*		NAME:			fNavigateUsingTopMenu Function
'*		DESCRIPTION:		Navigate to required module using top menu 
'*							
'*		INPUT PARAMS:		oBrwName, oPgName, Navigation Path for ex. Search>Search Findings>[New Search]
'*		AUTHOR:  		Kumari Sarita
'*		DATE:			07/17/2009
'*		MODIFICATION HISTORY
'* --------------------------------
'*		Modified By:	Selva
'*		Date:			Feb 04, 2010
'*		Description:	Modified the Main menu html id.
'									Inserted Regular Expression as the html id differs form page to page.
'***********************************************************************************************************************

Public Function fNavigateUsingTopMenu(oBrwName, oPgName, fullNavigationPath)

	Dim tblMainMenu1, tblMainMenu2, strTopMenus, partObj, tblLevel1Menu, tblSubMenu, elmObj, arrPath
	
	tblMainMenu1 = "html id:=xmnuMainMenuxMM_MainM"
	tblMainMenu2 = "html id:=.{0,2}MainMenu\dxuwmMainMenu_MainM"
	If Browser(oBrwName).Page(oPgName).WebTable(tblMainMenu1).Exist(1) Then
		strTopMenus = Browser(oBrwName).Page(oPgName).WebTable(tblMainMenu1).GetROProperty("innertext")
		partObj = "html id:=xmnuMainMenuxMM_"
	Else
		strTopMenus = Browser(oBrwName).Page(oPgName).WebTable(tblMainMenu2).GetROProperty("innertext")
		partObj = "html id:=.{0,2}MainMenu\dxuwmMainMenu_"
	End If
	
	'Extract the navigation path details
	arrPath = Split(fullNavigationPath,">")
	Select Case LCase(Trim(arrPath(0)))
		Case "home"
			tblLevel1Menu = partObj & 1
		Case "assessments"
			tblLevel1Menu = partObj & 2
		Case "manage"
			tblLevel1Menu = partObj & 3
		Case "findings"
			tblLevel1Menu = partObj & 4
		Case "dashboards"
			tblLevel1Menu = partObj & 5
		Case "reports"
			tblLevel1Menu = partObj & 6
		Case "search"
			tblLevel1Menu = partObj & 7
		Case "logout"
			tblLevel1Menu = partObj & 8
		Case "help"
			tblLevel1Menu = partObj & 9
		Case else
	End Select
	
	If InStr(1,strTopMenus,arrPath(0),1)>0 Then
		'Click on the top most menu link
		Set elmObj = Browser(oBrwName).Page(oPgName).WebTable(tblLevel1Menu).ChildItem(1,2,"WebElement",0)
		elmObj.Click
		
		'Click on sub menu if exist
		If UBound(arrPath)>0 Then
			For i=1 to 10
				tblSubMenu = tblLevel1Menu&"_"&i
				If Browser(oBrwName).Page(oPgName).WebTable(tblSubMenu).Exist(1) Then
					strSubMenuName = Browser(oBrwName).Page(oPgName).WebTable(tblSubMenu).GetROProperty("innertext")
					If InStr(1,strSubMenuName,trim(arrPath(1)),1)>0 Then
						intSubMenuPos = i
						Exit For
					End If
				ElseIf i=10 Then
					WriteReportOut micWarning, "Sub menu Existence check", arrPath(1)&" 2nd level menu does not exist for this user."
					Exit Function
				End If
			Next
			
			Set elmObj = Browser(oBrwName).Page(oPgName).WebTable(tblSubMenu).ChildItem(1,2,"WebElement",0)	
			If UBound(arrPath)=1 Then
				elmObj.Click
			Else
				elmObj.FireEvent "onmouseover"
			End If
		End If
		
		If UBound(arrPath)>1 Then
			For i=1 to 50
				tblSubSubMenu = tblLevel1Menu&"_"&intSubMenuPos&"_"&i
				If Browser(oBrwName).Page(oPgName).WebTable(tblSubSubMenu).Exist(1) Then
					strSubSubMenuName = Browser(oBrwName).Page(oPgName).WebTable(tblSubSubMenu).GetROProperty("innertext")
					If InStr(1,strSubSubMenuName,trim(arrPath(2)),1)>0 Then
						Exit For
					End If
				ElseIf i=50 Then
					WriteReportOut micWarning, "Sub Sub menu Existence check", arrPath(2)&" 3rd level menu does not exist for this user."
					Exit Function
				End If
			Next
			
			Set elmObj = Browser(oBrwName).Page(oPgName).WebTable(tblSubSubMenu).ChildItem(1,2,"WebElement",0)	
			elmObj.Click
		End If
	Else
		WriteReportOut micWarning, "Top menu Existence check", arrPath(0)&" 1st level menu does not exist for this user."
	End If

End Function
'################################################################################################################
' ‘################################################################################################################
' #Function Name:	RSAM _Launch
'# Description:	 This script does the following
'							1. It will load the environment variable file during run time
'							2. Fetch URL defined in the file
'							3. Launch the application
'							4. Verify if the user name, password and Login buttons in the Login Page
'							5. Write the corresponding results to the custom log file					
'# Input Parameters: browser name and Page name
'# Return Values: Verifies if the user name, password and the login buttons are present
' # Dependencies: 1. The Environment XML File should be present, 
'								2. The framework folder structures should not be modified.
'#Author: Selva	
'#Date Created: Feb 02, 2010
'#Date Modified
'#
'# 
'Date		Name					Description
'# ------		--------					---------------
' #
' #
' #
'‘################################################################################################################## 
Function RSAM_Launch(oBrwName, oPgName, strRsamUrl)
	Dim oUsrName, oPwd, oLoginBtn
	oUsrName = "name:=txt_userID"
	oPwd = "name:=txt_password"
	oLoginBtn = "name:=rov_login_img"
	Load_RSAM_Env_XML_File 'load environment file at run time
	SystemUtil.Run"iexplore",strRsamUrl,"3" 'Launches RSAM in Maximized mode
	With Browser(oBrwName).Page(oPgName)
		.Sync
		If .WebEdit(oUsrName).Exist and .WebEdit(oPwd).Exist and .Image(oLoginBtn).Exist Then ' Verifies if the username, pwd and login buttons are present.
			RSAM_Automation_Result_File_Update "RSAM Launch","Verify the Login screen of the RSAM Application","Username, Password & Login Button should be present","All are present","Pass"
		Else
			RSAM_Automation_Result_File_Update "RSAM Launch","Verify the Login screen of the RSAM Application","Username, Password & Login Button should be present","All are not present","Fail"
		End If
	End With
End Function
'‘################################################################################################################## 
' ‘################################################################################################################
' Function Name:	RSAM _Login
'# Description:	 This script does the following
'							1. It will load the environment variable file during run time
'							2. Fetch Username and Password defined in the file
'							3. Login in the application
'							4. Verify if the user name is specified in the Home Page
'							5. Write the corresponding results to the custom log file					
'# Input Parameters: 
'# Return Values:
' # Dependencies: 1. The Environment XML File should be present, 
'								2. The framework folder structures should not be modified.
'	
'#Author: Selva	
'#Date Created: Feb 02, 2010
'#Date Modified
'#
'# 
'Date		Name					Description
'# ------		--------					---------------
' #
' #
' #
'‘################################################################################################################## 
Function RSAM_Login(oBrwName,oPgName)
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'The below code load the environment file during run time
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Load_RSAM_Env_XML_File	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'The below code fetches the values from the env file and enters it in the application
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Dim oUsrName, oPwd, oLoginBtn, strUsrName, strPwd, oHmBrwName, oHmPgName, oLoginInfo, strUsrNullMsg
	oUsrName = "name:=txt_userID"
	oPwd = "name:=txt_password"
	oLoginBtn = "name:=rov_login_img"
	strUsrName = Environment("Username")
	strPwd = Environment("pwd")	
	With Browser(oBrwName).Page(oPgName)
		.WebEdit(oUsrName).Set strUsrName
		.WebEdit(oPwd).Set strPwd
		.Image(oLoginBtn).Click
	End With
	If strUsrName="" or strPwd="" Then
        strUsrNullMsg = Browser(oBrwName).Dialog("regexpwndtitle:=Microsoft Internet Explorer").WinButton("regexpwndtitle:=OK").GetROProperty("attached text")
		If strUsrNullMsg = "You must specify a User ID and Password" Then
			RSAM_Automation_Result_File_Update "Login_01","When Blank username or Password is entered","You must specify a User ID and Password",strUsrNullMsg,"Pass"
		Else
			RSAM_Automation_Result_File_Update "Login_01","When Blank username or Password is entered","You must specify a User ID and Password",strUsrNullMsg,"Fail"
		End If
		Browser(oBrwName).Dialog("regexpwndtitle:=Microsoft Internet Explorer").WinButton("regexpwndtitle:=OK").Click
	End If
End Function
'	 ‘################################################################################################################
' Function Name:	RSAM _Login_Validation
'# Description:	 This script does the following
'							1. It will load the environment variable file during run time
'							2. Fetch Username and Password defined in the file
'							3. Login in the application
'							4. Verify if the user name is specified in the Home Page
'							5. Write the corresponding results to the custom log file					
'# Input Parameters: 
'# Return Values:
' # Dependencies: 1. The Environment XML File should be present, 
'								2. The framework folder structures should not be modified.
'	
'#Author: Selva	
'#Date Created: Feb 02, 2010
'#Date Modified
'#
'# 
'Date		Name					Description
'# ------		--------					---------------
' #
' #
' #
'‘################################################################################################################## 
Function RSAM_Login_Validation()
	oLoginInfo = "innerhtml:=For_Demonstration_Only<BR>.*"
	oHmBrwName = "name:=RSAM Home"
	oHmPgName = "title:=RSAM Home"
	oLougoutBtn = " innertext:=Logout "
	strUsrName = Environment("Username")
    strPwd = Environment("pwd")
	Browser(oHmBrwName).Page(oHmPgName).Sync
    'Get the username from the Login information
    If Browser(oHmBrwName).Page(oHmPgName).Exist Then ''Compare the usernames
		RSAM_Automation_Result_File_Update "Login_01","User name in the Home Page","User should be logged in Sucessfully","User Logged In","Pass"
	Else
        RSAM_Automation_Result_File_Update "Login_01","User name in the Home Page","User should be logged in Sucessfully","User unable to Log In","Fail"
	End If
End Function
'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'‘################################################################################################################## 
'################################################################################################################
' Function Name:	RSAM _Password_Encrypt
'# Description:	 This script does the following
'							1. It will load the Password Encryptor application
'							2. Enter the password input in the application and click encrypt
'							3. Get the encrypted password from the application
'							4. Return the encrypted password
'# Input Parameters: User Passwordto be encrypted
'# Return Values: Encrypted Password
' # Dependencies: 1. The Environment XML File should be present, 
'								2. The framework folder structures should not be modified.
'								3.  The password encryptor should be present
'	
'#Author: Selva	
'#Date Created: Feb 02, 2010
'#Date Modified
'#
'# 
'Date		Name					Description
'# ------		--------					---------------
' #
' #
' #
'‘################################################################################################################## 
Function RSAM_Password_Encrypt(strUserPwd)
	Load_RSAM_Env_XML_File
	SystemUtil.Run"iexplore",Environment("PasswordEncryptorURL"),"3"
	If Browser("name:=RSAM Password Encryptor").WinButton("text:=To help protect your security,.*").Exist Then
		With Browser("name:=RSAM Password Encryptor")
			.WinButton("text:=To help protect your security,.*").Click
			.WinMenu("menuobjtype:=3").Select "Allow Blocked Content..."
			.Dialog("text:=Security Warning","nativeclass:=#32770").WinButton("text:=&Yes","nativeclass:=Button").Click
		End With
	End If
	With Browser("name:=RSAM Password Encryptor")
		.WebEdit("html id:=pwdencrypt").Set strUserPwd
		.WebButton("name:=Encrypt").Click
		RSAM_Encrypted_Pwd = .WebEdit("html id:=encryptedpwd").GetROProperty("value")
	End With
	RSAM_Password_Encrypt  = RSAM_Encrypted_Pwd
	Browser("name:=RSAM Password Encryptor").Close
End Function
'‘################################################################################################################## 
'################################################################################################################
' Function Name:	RSAM_RandomString
'# Description:	 This script does the following
'							1. It  generates a random string with the string provided appending at the front,

'# Input Parameters: Append String and Length of the random string to be generated
'# Return Values: Random String 
' # Dependencies: =
'	
'#Author: Selva	
'#Date Created: Feb 11, 2010
'#Date Modified
'#
'# 
'Date		Name					Description
'# ------		--------					---------------
' #
' #
' #
'‘################################################################################################################## 
Function RSAM_RandomString(appndStr,strLen)
	Dim str    
	Const LETTERS = "abcdefghijklmnopqrstuvwxyz0123456789"
	For i = 1 to strLen
		str = str & Mid( LETTERS, RandomNumber( 1, Len( LETTERS ) ), 1 )
	Next
	RSAM_RandomString = appndStr&"_"&str
	If  RSAM_RandomString <> "" Then
		RSAM_Automation_Result_File_Update "Random String","To generate a random string with the specified length and append string","Random string should be generated",RSAM_RandomString,"Pass"
	Else
		RSAM_Automation_Result_File_Update "Random String","To generate a random string with the specified length and append string","Random string should be generated",RSAM_RandomString,"Fail"
	End If
End Function
'################################################################################################################## 
'################################################################################################################
' Function Name:	RSAM_LoadRecovery
'# Description:	 This script does the following
'							1. It  loads the recovery scenario file during the run time

'# Input Parameters: 
'# Return Values: 
' # Dependencies: =
'	
'#Author: Selva	
'#Date Created: Feb 23, 2010
'#Date Modified
'#
'# 
'Date		Name					Description
'# ------		--------					---------------
' #
' #
' #
'‘################################################################################################################## 
Function RSAM_Load_RecoveryScenario()
    Load_RSAM_Env_XML_File
	Dim qtApp,qtRecovery,iIndex
	Set qtApp = CreateObject("QuickTest.Application")
	Set qtRecovery = qtApp.Test.Settings.Recovery
	If qtRecovery.Count>0 Then
		qtRecovery.RemoveAll
	End If
	qtRecovery.Add Environment("RSAM_Recovery_Path")&"\RSAM_Recovery.qrs", "ErrorMessage", 1
	For iIndex = 1 To qtRecovery.Count
		qtRecovery.Item(iIndex).Enabled = True
	Next
	qtRecovery.Enabled= True
	qtRecovery.SetActivationMode "OnError"
	Set qtApp = Nothing
	Set qtRecovery = Nothing
End Function
'################################################################################################################## 
