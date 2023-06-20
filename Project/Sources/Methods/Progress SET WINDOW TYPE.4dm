//%attributes = {"shared":true}
#DECLARE($type : Integer)

Use (Storage:C1525)
	If (Storage:C1525.options=Null:C1517) & (Count parameters:C259>0)
		Storage:C1525.options:=New shared object:C1526()
	End if 
End use 

If (Storage:C1525.options#Null:C1517)
	Use (Storage:C1525.options)
		If (Count parameters:C259=0)
			If (Storage:C1525.options.windowType#Null:C1517)
				Storage:C1525.options.windowType:=Null:C1517
			End if 
			
		Else 
			Storage:C1525.options.windowType:=$type
		End if 
	End use 
End if 
