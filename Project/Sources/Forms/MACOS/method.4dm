If (Form:C1466.progress=-1)
	
	OBJECT SET FORMAT:C236(*; "progress"; ";;;;128")
	OBJECT SET VALUE:C1742("progress"; 1)
	
Else 
	
	OBJECT SET FORMAT:C236(*; "progress"; ";;;;0")
	OBJECT SET VALUE:C1742("progress"; Num:C11(Form:C1466.value))
	
End if 

If (Form:C1466.cancellable)
	
	OBJECT GET COORDINATES:C663(*; "markerStop"; $left; $top; $right; $bottom)
	OBJECT GET COORDINATES:C663(*; "progress"; $left; $top; $unused; $bottom)
	OBJECT SET COORDINATES:C1248(*; "progress"; $left; $top; $right; $bottom)
	OBJECT SET VISIBLE:C603(*; "stop"; True:C214)
	
Else 
	
	OBJECT GET COORDINATES:C663(*; "markerNoStop"; $left; $top; $right; $bottom)
	OBJECT GET COORDINATES:C663(*; "progress"; $left; $top; $unused; $bottom)
	OBJECT SET COORDINATES:C1248(*; "progress"; $left; $top; $right; $bottom)
	OBJECT SET VISIBLE:C603(*; "stop"; False:C215)
	
End if 

