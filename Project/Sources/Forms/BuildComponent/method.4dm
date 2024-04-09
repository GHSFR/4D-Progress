var $fec : Integer

$fec:=Form event code:C388
Case of 
	: ($fec=On Load:K2:1)
		OBJECT SET TITLE:C194(*; "DernierNumBuild"; "dernier : "+String:C10(Form:C1466.numBuild))
		
End case 
