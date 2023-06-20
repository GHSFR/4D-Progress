//%attributes = {"shared":true}
#DECLARE($type : Integer)

Use (Storage:C1525)
	If (Count parameters:C259=0)
		If (Storage:C1525.windowType#Null:C1517)
			Storage:C1525.windowType:=Null:C1517
		End if 
		
	Else 
		Storage:C1525.windowType:=$type
	End if 
End use 
