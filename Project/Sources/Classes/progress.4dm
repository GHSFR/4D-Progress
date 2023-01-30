Class constructor($title)
	
	This:C1470.ready:=False:C215
	
	This:C1470._title:=""
	This:C1470._message:=""
	This:C1470.progress:=-1  // Barber
	This:C1470.cancellable:=False:C215
	
	This:C1470.start:=Tickcount:C458
	This:C1470.delay:=0
	
	This:C1470.closed:=False:C215
	
	This:C1470.stopTitle:=""
	This:C1470.isForeground:=True:C214
	This:C1470.icon:=Null:C1517
	This:C1470.id:=0
	This:C1470.stopEnabled:=False:C215
	This:C1470.stopped:=False:C215
	This:C1470.isVisible:=False:C215
	This:C1470.success:=False:C215
	
	This:C1470._worker:="$progress"  // 1
	
	If (Value type:C1509($title)=Is object:K8:27)
		
		For each ($key; $title)
			
			This:C1470[$key]:=$title[$key]
			
		End for each 
		
	Else 
		
		This:C1470._title:=String:C10($title)
		
	End if 
	
	This:C1470._handler:=Formula:C1597(Progress)
	
	This:C1470.init()
	
	// === === === === === === === === === === === === === === === === === === ===
Function _callBack($signal : 4D:C1709.Signal; $progress : cs:C1710.progress)
	
	
	Case of 
			
			//______________________________________________________
		: ($signal.description="create")  // Create a new instance
			
			// D'abord chercher si il y a un null à récupérer ?
			
			//______________________________________________________
		: ($signal.description="show")
			
			var $bottom; $left; $right; $height; $width; $top : Integer
			var $name : Text
			
			var $show : Boolean
			
			If (Not:C34($progress.closed))
				
				$progress.timeSpent:=Tickcount:C458-$progress.start
				
				$show:=$progress.delay=0 || ($progress.timeSpent>$progress.delay)
				
				If (Not:C34($show))
					
					//$delay:=True
					//CALL WORKER($progress._worker; $progress._progress; $signal; $progress)
					
				Else 
					
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
					
				End if 
			End if 
			
			//______________________________________________________
		: ($progress.window=Null:C1517)
			
			
			
			//______________________________________________________
		: ($signal.description="close")
			
			CALL FORM:C1391($progress.window; Formula:C1597(CANCEL:C270))
			
			//______________________________________________________
		: ($signal.description="update")
			
			CALL FORM:C1391($progress.window; Formula:C1597(Form:C1466.message:=$progress.message))
			
			//______________________________________________________
		Else 
			
			// A "Case of" statement should never omit "Else"
			
			//______________________________________________________
	End case 
	
	If ($signal#Null:C1517)
		
		Use ($signal)
			
			$signal.instance:=OB Copy:C1225($progress; ck shared:K85:29)
			
		End use 
		
		$signal.trigger()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function init()
	
	var $signal : 4D:C1709.Signal
	$signal:=This:C1470._signal("create")
	
	CALL WORKER:C1389(This:C1470._worker; This:C1470._handler; $signal; This:C1470)
	$signal.wait()
	This:C1470.success:=$signal.signaled
	
	If (This:C1470.success)
		
		This:C1470.id:=$signal.instance.id
		This:C1470.ready:=True:C214
		
	End if 
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function set message($message : Text)
	
	This:C1470._message:=$message
	
	If (This:C1470.ready)
		
		var $signal : 4D:C1709.Signal
		$signal:=This:C1470._signal("update")
		
		If (False:C215)
			
			This:C1470._callWorker($signal; False:C215)
			
		Else 
			
			CALL WORKER:C1389(This:C1470._worker; This:C1470._handler; $signal; This:C1470)
			
		End if 
	End if 
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function get message() : Text
	
	return This:C1470._message
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function set title($title : Text)
	
	This:C1470._title:=$title
	
	If (This:C1470.ready)
		
		var $signal : 4D:C1709.Signal
		$signal:=This:C1470._signal("update")
		
		If (False:C215)
			
			This:C1470._callWorker($signal; False:C215)
			
		Else 
			
			CALL WORKER:C1389(This:C1470._worker; This:C1470._handler; $signal; This:C1470)
			
		End if 
	End if 
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function get title() : Text
	
	return This:C1470._title
	
	// === === === === === === === === === === === === === === === === === === ===
Function display()
	
	var $signal : 4D:C1709.Signal
	$signal:=This:C1470._signal("show")
	
	CALL WORKER:C1389(This:C1470._worker; This:C1470._handler; $signal; This:C1470)
	$signal.wait()
	This:C1470.success:=$signal.signaled
	
	If (This:C1470.success)
		
		If ($signal.instance.timeSpent>=This:C1470.delay)
			
			This:C1470.window:=$signal.instance.window
			
		Else 
			
			$start:=Tickcount:C458
			
			While ((Tickcount:C458-$start)<60)
				
				IDLE:C311
				DELAY PROCESS:C323(Current process:C322; 1)
				IDLE:C311
				
			End while 
			
			This:C1470.display()
			
		End if 
	End if 
	
	//*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _signal($description : Text) : 4D:C1709.Signal
	
	var $signal : 4D:C1709.Signal
	$signal:=New signal:C1641
	
	Use ($signal)
		
		$signal.description:=$description
		
	End use 
	
	return $signal
	
	//*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _callWorker($ignal : 4D:C1709.Signal; $wait : Boolean) : 4D:C1709.Signal
	
	If (This:C1470.ready)
		
		$wait:=Count parameters:C259>=2 ? $wait : True:C214
		CALL WORKER:C1389(This:C1470._worker; This:C1470._handler; $signal; This:C1470)
		If ($wait)
			
			$signal.wait()
			This:C1470.success:=$signal.signaled
			return $signal
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function setDelay($tiks : Integer)->$this : cs:C1710.progress
	
	This:C1470.hide()
	
	This:C1470.delay:=$tiks
	This:C1470.start:=Tickcount:C458
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function update()
	
	If (Not:C34(This:C1470.isVisible))
		
		If ((Tickcount:C458-This:C1470.start)>This:C1470.delay)
			
			This:C1470.show()
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function show($visible : Boolean; $foreground : Boolean)->$this : cs:C1710.progress
	
	If (Count parameters:C259>=1)
		
		This:C1470.isVisible:=$visible
		
		If (Count parameters:C259>=2)
			
			This:C1470.isForeground:=$foreground
			
		End if 
		
	Else 
		
		This:C1470.isVisible:=True:C214
		
	End if 
	
	Progress SET WINDOW VISIBLE(This:C1470.isVisible; -1; -1; This:C1470.isForeground)
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function bringToFront()->$this : cs:C1710.progress
	
	This:C1470.isForeground:=True:C214
	This:C1470.visible:=True:C214
	
	Progress SET WINDOW VISIBLE(This:C1470.visible; -1; -1; This:C1470.isForeground)
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function hide()->$this : cs:C1710.progress
	
	This:C1470.show(False:C215)
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function close()
	
	var $signal : 4D:C1709.Signal
	$signal:=This:C1470._signal("close")
	
	This:C1470.closed:=True:C214
	
	CALL WORKER:C1389(This:C1470._worker; This:C1470._handler; $signal; This:C1470)
	$signal.wait()
	This:C1470.success:=$signal.signaled
	
	// === === === === === === === === === === === === === === === === === === ===
Function setTitle($title : Text)->$this : cs:C1710.progress
	
	var $t : Text
	
	If (Count parameters:C259>=1)
		
		$t:=$title
		
		If (Length:C16($title)>0)\
			 & (Length:C16($title)<=255)
			
			//%W-533.1
			If ($title[[1]]#Char:C90(1))
				
				$t:=Get localized string:C991($title)
				$t:=Choose:C955(Length:C16($t)>0; $t; $title)  // Revert if no localization
				
			End if 
			//%W+533.1
			
		End if 
		
	End if 
	
	This:C1470._title:=$t
	Progress SET TITLE(This:C1470.id; This:C1470._title)
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function setMessage($message : Text; $foreground : Boolean)->$this : cs:C1710.progress
	
	//var $t : Text
	
	//If (Count parameters>=1)
	
	//$t:=$message
	
	//If (Length($message)>0)\
										 & (Length($message)<=255)
	
	////%W-533.1
	//If ($message[[1]]#Char(1))
	
	//$t:=Get localized string($message)
	//$t:=Choose(Length($t)>0; $t; $message)  // Revert if no localization
	
	//End if 
	////%W+533.1
	
	//End if 
	
	//If (Count parameters>=2)
	
	//This.isForeground:=$foreground
	
	//End if 
	//End if 
	
	//This._message:=$t
	//Progress SET MESSAGE(This.id; This._message; This.isForeground)
	
	//This.isStopped()
	
	//$this:=This
	
	This:C1470._message:=$message
	
	var $signal : 4D:C1709.Signal
	$signal:=This:C1470._signal("message")
	
	CALL WORKER:C1389(This:C1470._worker; This:C1470._handler; $signal; This:C1470)
	
	$signal.wait()
	This:C1470.success:=$signal.signaled
	
	
	// === === === === === === === === === === === === === === === === === === ===
Function setProgress($progress; $foreground : Boolean)->$this : cs:C1710.progress
	
	If (Value type:C1509($progress)=Is text:K8:3)
		
		Case of 
				
				//______________________________________________________
			: ($progress="barber@")\
				 | ($progress="undefined")
				
				This:C1470.progress:=-1
				
				//______________________________________________________
			Else 
				
				This:C1470.progress:=Num:C11($progress)
				
				//______________________________________________________
		End case 
		
	Else 
		
		This:C1470.progress:=Num:C11($progress)
		
	End if 
	
	If (Count parameters:C259>=2)
		
		This:C1470.isForeground:=$foreground
		
	End if 
	
	Progress SET PROGRESS(This:C1470.id; This:C1470.progress; This:C1470._message; This:C1470.isForeground)
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function setIcon($icon : Picture; $foreground : Boolean)->$this : cs:C1710.progress
	
	var $p : Picture
	
	If (Count parameters:C259>=1)
		
		$p:=$icon
		
	End if 
	
	This:C1470.icon:=$p
	
	If (Count parameters:C259>=2)
		
		Progress SET ICON(This:C1470.id; This:C1470.icon; $foreground)
		
	Else 
		
		Progress SET ICON(This:C1470.id; This:C1470.icon)
		
	End if 
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function setPosition($x : Integer; $y : Integer; $foreground : Boolean)->$this : cs:C1710.progress
	
	If (Count parameters:C259>=2)
		
		This:C1470.x:=$x
		This:C1470.y:=$y
		
		If (Count parameters:C259>=3)
			
			This:C1470.isForeground:=$foreground
			
		End if 
		
		Progress SET WINDOW VISIBLE(This:C1470.visible; This:C1470.x; This:C1470.y; This:C1470.isForeground)
		
	Else 
		
		This:C1470.x:=$x
		Progress SET WINDOW VISIBLE(This:C1470.visible; This:C1470.x; -1; This:C1470.isForeground)
		
	End if 
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function showStop($show : Boolean)->$this : cs:C1710.progress
	
	If (Count parameters:C259>=1)
		
		This:C1470.stopEnabled:=$show
		
	Else 
		
		// Default is True
		This:C1470.stopEnabled:=True:C214
		
	End if 
	
	Progress SET BUTTON ENABLED(This:C1470.id; This:C1470.stopEnabled)
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function hideStop()->$this : cs:C1710.progress
	
	This:C1470.showStop(False:C215)
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function setStopTitle($title : Text)->$this : cs:C1710.progress
	
	If (Count parameters:C259>=1)
		
		This:C1470.stopTitle:=$title
		
	Else 
		
		// Default is True
		This:C1470.stopTitle:="Stop"
		
	End if 
	
	Progress SET BUTTON TITLE(This:C1470.id; This:C1470.stopTitle)
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function isStopped()->$stopped : Boolean
	
	This:C1470.stopped:=Progress Stopped(This:C1470.id)
	
	$stopped:=This:C1470.stopped
	
	// === === === === === === === === === === === === === === === === === === ===
Function forEach($target; $formula : Object; $keepOpen : Boolean)->$this : cs:C1710.progress
	
	var $i; $size : Integer
	var $v : Variant
	var $t : Text
	var $keep : Boolean
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($target)=Is collection:K8:32)
			
			This:C1470.setProgress(0)
			$size:=$target.length
			
			//______________________________________________________
		: (Value type:C1509($target)=Is object:K8:27)
			
			This:C1470.setProgress(0)
			
			$size:=OB Entries:C1720($target).length
			
			//______________________________________________________
		Else 
			
			This:C1470.setProgress(-1)  // Barber shop
			
			//______________________________________________________
	End case 
	
	If (This:C1470.stopEnabled)  // The progress has a Stop button
		
		This:C1470.stopped:=False:C215
		
		// As long as progress is not stopped...
		For each ($v; $target) While (Not:C34(This:C1470.stopped))
			
			This:C1470.update()
			
			If (Not:C34(This:C1470.isStopped()))
				
				$i:=$i+1
				$t:=String:C10($formula.call(Null:C1517; $v; $target; $i))
				
				If ($size#0)
					
					This:C1470.setProgress($i/$size)
					
				End if 
				
				If (Length:C16($t)>0)
					
					This:C1470.setMessage($t)
					
				End if 
				
			Else 
				
				// The user clicks on Stop
				This:C1470.hideStop()
				
			End if 
		End for each 
		
		
	Else 
		
		This:C1470.stopped:=False:C215
		
		For each ($v; $target)
			
			This:C1470.update()
			
			$i:=$i+1
			$t:=String:C10($formula.call(Null:C1517; $v; $target; $i))
			
			If ($size#0)
				
				This:C1470.setProgress($i/$size)
				
			End if 
			
			If (Length:C16($t)>0)
				
				This:C1470.setMessage($t)
				
			End if 
		End for each 
		
	End if 
	
	If (Count parameters:C259>=3)
		
		$keep:=$keepOpen
		
	End if 
	
	If ($keep)
		
		This:C1470.setProgress(-1).setMessage("")
		
	Else 
		
		This:C1470.close()
		
	End if 
	
	$this:=This:C1470