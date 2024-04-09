//%attributes = {}
var $numBuild; $fen : Integer
var $buildParams; $settings; $form : Object
var $version4d; $tmpl; $msg; $fileContent : Text
var $file; $tmplFile; $buildParamsFile; $buildFile; $infoFile; $infoPlistFile : 4D:C1709.File
var $settingsFolder; $rsrcFolder; $dbFolder : 4D:C1709.Folder
var $build : cs:C1710.Build4D.Component
var $success : Boolean
var $targets : Collection

$settingsFolder:=File:C1566(Build application settings file:K5:60).parent
$buildParamsFile:=$settingsFolder.file("buildParams.json")
$buildParams:=JSON Parse:C1218($buildParamsFile.getText())
$form:=New object:C1471()
$form.numBuild:=$buildParams.numBuild
$form.compiled:=True:C214
$fen:=Open form window:C675("BuildComponent"; Movable form dialog box:K39:8; On the left:K39:2+20; At the top:K39:5+Tool bar height:C1016+Menu bar height:C440+20; *)
DIALOG:C40("BuildComponent"; $form)
CLOSE WINDOW:C154($fen)
//$numBuild:=Num(Request("Numéro de build à utiliser (dernier : "+String($numBuild)+") :"; String($numBuild+1)))
If (OK=1)
	If ($form.numBuild#$buildParams.numBuild)
		$buildParams.numBuild:=$form.numBuild
		$buildParamsFile.setText(JSON Stringify:C1217($buildParams; *))
	End if 
	
	$version4d:=Application version:C493()
	
	$version4d:=Substring:C12($version4d; 1; 2)+\
		($version4d[[3]]="0"\
		 ? ($version4d[[4]]="0" ? "" : "."+$version4d[[4]])\
		 : " R"+$version4d[[3]])
	
	$rsrcFolder:=Folder:C1567(Folder:C1567(fk resources folder:K87:11).platformPath; fk platform path:K87:2)
	$dbFolder:=Folder:C1567(Folder:C1567(fk database folder:K87:14).platformPath; fk platform path:K87:2)
	$buildFile:=$settingsFolder.file("buildApp.4DSettings")
	$infoFile:=$dbFolder.file("Info.plist")
	$infoPlistFile:=$rsrcFolder.file("InfoPlist.strings")
	
	For each ($file; New collection:C1472($buildFile; $infoFile; $infoPlistFile))
		$tmplFile:=$file.parent.file($file.name+"-tmpl"+$file.extension)
		If ($tmplFile.exists)
			$tmpl:=$tmplFile.getText()
			PROCESS 4D TAGS:C816($tmpl; $fileContent; $buildParams; $version4d)
			$file.setText($fileContent)
		End if 
	End for each 
	
	If (False:C215)
		BUILD APPLICATION:C871($buildFile.platformPath)
		$msg:="Build "+$buildParams.name+" "+Choose:C955(Bool:C1537(OK); "OK"; "failed")
		DISPLAY NOTIFICATION:C910("Build "+$buildParams.name; $msg)
		ALERT:C41($msg)
		
	Else 
		Folder:C1567(fk logs folder:K87:17).file("Build_start.log").setText(Timestamp:C1445)
		Folder:C1567(fk logs folder:K87:17).file("Build_failed.log").delete()
		Folder:C1567(fk logs folder:K87:17).file("Build_end.log").delete()
		
		$targets:=(Is macOS:C1572) ? New collection:C1472("x86_64_generic"; "arm64_macOS_lib") : New collection:C1472("x86_64_generic")
		
		$settings:=New object:C1471()
		
		$settings.buildName:=$buildParams.name
		//$settings.projectFile:=$buildFile.path
		$settings.compilerOptions:=$form.compiled ? New object:C1471("targets"; $targets) : Null:C1517
		$settings.packedProject:=$form.compiled
		$settings.obfuscated:=$form.compiled
		$settings.destinationFolder:=$dbFolder.parent.folder($dbFolder.name+"_Build")
		
		$settings.includePaths:=New collection:C1472()
		$settings.includePaths.push(New object:C1471("source"; $infoFile))
		$settings.includePaths.push(New object:C1471("source"; $dbFolder.folder("Documentation")))
		//$settings.includePaths.push(New object("source"; $dbFolder.folder("Libraries")))
		$settings.includePaths.push(New object:C1471("source"; $rsrcFolder))
		$settings.includePaths.push(New object:C1471("source"; $dbFolder.folder("Macros v2")))
		
		$settings.deletePaths:=New collection:C1472()
		$settings.deletePaths.push("Resources/php.ini")
		$settings.deletePaths.push("Resources/InfoPlist-tmpl.strings")
		
		$settings.signApplication:=New object:C1471()
		$settings.signApplication.macSignature:=True:C214
		$settings.signApplication.macCertificate:="Developer ID Application: GHS (FR) (74M25885A6)"
		$settings.signApplication.adHocSignature:=False:C215
		
		$build:=cs:C1710.Build4D.Component.new($settings)
		
		$success:=$build.build()
		
		Folder:C1567(fk logs folder:K87:17).file("Build_end.log").setText(Timestamp:C1445)
		If ($success)  // Write logs if failed
			//BUILD APPLICATION($buildFile.platformPath)
			
		Else 
			Folder:C1567(fk logs folder:K87:17).file("Build_failed.log").setText(JSON Stringify:C1217($build.logs; *))
		End if 
		
		$msg:="Build "+$settings.buildName+" "+Choose:C955($success; "OK"; "failed")
		DISPLAY NOTIFICATION:C910("Build "+$settings.buildName; $msg)
		If (Not:C34(Get application info:C1599.headless))
			ALERT:C41($msg)
			If (Not:C34($success))
				SHOW ON DISK:C922(File:C1566("/PACKAGE/Build_failed.log").platformPath)
			End if 
		End if 
	End if 
	
	//$buildFile.delete()
End if 
