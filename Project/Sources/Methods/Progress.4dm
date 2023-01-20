//%attributes = {}
#DECLARE($signal : 4D:C1709.Signal; $progress : cs:C1710.progress)

If (False:C215)
	C_OBJECT:C1216(Progress; $1)
	C_OBJECT:C1216(Progress; $2)
End if 

var instances : Collection
instances:=instances || New collection:C1472

Case of 
		
		//______________________________________________________
	: ($signal.description="create")  // Create a new instance
		
		// D'abord chercher si il y a un null à récupérer ?
		//instances.push($progress)
		//$progress.id:=instances.length  // It's a bad idea
		
		//______________________________________________________
	: ($signal.description="close")
		
		//var $instance : cs.progress
		//$c:=instances.indices("id"; $progress.id)
		
		//If ($c.length>0)
		
		CALL FORM:C1391($progress.window; Formula:C1597(CANCEL:C270))
		
		// End if
		
		//______________________________________________________
	: ($signal.description="show")
		
		var $bottom; $left; $right; $height; $width; $top : Integer
		var $name : Text
		
		If (Is macOS:C1572)
			
			$name:="MACOS"
			// FIXME: return 0 & 0
			//FORM GET PROPERTIES($name; width; height)
			$width:=400
			$height:=68
			$left:=(Screen width:C187/2)-($width/2)
			$top:=80+Tool bar height:C1016
			$right:=$left+$width
			$bottom:=$top+$height
			$progress.window:=Open window:C153($left; $top; $right; $bottom; -1*Plain fixed size window:K34:6; " ")
			
			VerticalCenter:=$left
			
		Else 
			
			$name:="WINDOWS"
			// FIXME: return 0 & 0
			//FORM GET PROPERTIES($name; width; height)
			$width:=400
			$height:=120
			$left:=(Screen width:C187/2)-($width/2)
			$top:=(Screen height:C188-$height)/2
			$right:=$left+$width
			$bottom:=$top+$height
			$progress.window:=Open window:C153($left; $top; $right; $bottom; Plain fixed size window:K34:6; " ")
			
			VerticalCenter:=($top+$bottom)/2
			
		End if 
		
		DIALOG:C40($name; $progress; *)
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 

Use ($signal)
	
	$signal.instance:=OB Copy:C1225($progress; ck shared:K85:29)
	
End use 

$signal.trigger()