!include WinMessages.nsh
!define SF_SELECTED   1
!define SF_BOLD       8
!define SF_RO         16
# Version Information
VIAddVersionKey "ProductVersion" "2.0.0"
VIAddVersionKey "FileVersion" "2.0.0"
VIProductVersion "2.0.0.0"
VIFileVersion "2.0.0.0"

Function .onInit
  Var /GLOBAL ver
  Var /GLOBAL fullVer
  Var /GLOBAL verString
  Var /GLOBAL newInstall
  StrCpy $ver "2.0.0"
  StrCpy $fullVer "$ver.0"
  StrCpy $verString "Golden Bones Installer v$ver"
  
  #get graphics card string
  Var /GLOBAL graphicsCard
  SetRegView 64
  ReadRegStr $graphicsCard HKEY_LOCAL_MACHINE 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinSAT' PrimaryAdapterString
  Var /GLOBAL graphicsPrefix
  StrCpy $graphicsPrefix "$graphicsCard" 2 -4
  
  # GUI string variables
  Var /GLOBAL licText
  
  # compare version with registry
  Var /GLOBAL regVer
  ReadRegStr $regVer HKEY_CURRENT_USER SOFTWARE\gbInstaller version
  StrCmp $regVer $ver sameVersion +1
    StrCmp $regVer "" notInstalled diffVersion
	
  # if the installer was already installed
  sameVersion:
    StrCpy $newInstall "configure"
    StrCpy $licText "Some Quick Info Before Configuring"
	Return
  
  #if the installer has the wrong version
  diffVersion:
    StrCpy $newInstall "outdated"
    StrCpy $licText "Some Quick Info Before Updating from v$regVer to v$ver"
	
	Return
  
  #if this is the first install
  notInstalled:
    StrCpy $newInstall "first"
    StrCpy $licText "Some Quick Info Before Installing"
	
	Return
    
FunctionEnd

# Close minecraft before installing warning
Function closeWarning
  MessageBox MB_ICONEXCLAMATION|MB_OK "MAKE SURE YOU HAVE CLOSED MINECRAFT AND THE LAUNCHER BEFORE PROCEEDING"
FunctionEnd

#Section Descriptions
Function .onMouseOverSection
  FindWindow $R0 "#32770" "" $HWNDPARENT
  GetDlgItem $R0 $R0 1022
  StrCmp $0 0 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Dependencies are software that are required to play modded Minecraft."
  
  StrCmp $0 1 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Java is what Minecraft runs on. Minecraft has a version of Java bundled with it, but to play with mods you need to have Java installed. As of 1.20.5, Java 21 is required."
  
  StrCmp $0 2 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Fabric is a modding platform for Minecraft. It is required to use mods."
  
  StrCmp $0 3 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:deez nuts"
  
  StrCmp $0 4 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:This is a collection of mods that are either required to connect to the Golden Bones server, or improve Minecraft without any drawbacks.$\nDeez"
	
  StrCmp $0 5 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:These are mods that can increase chunk rendering performance, give extra control over how the world looks, or alter rendering in some other way."
	
  StrCmp $0 6 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Nvidium uses special technology to dramatically increase rendering performance. However, it only works on NVIDIA graphics cards from the 16xx series up.$\nDetected GPU:$\n$graphicsCard"
  
  StrCmp $0 7 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:description not added yet sorry"
	
  StrCmp $0 8 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:description not added yet sorry"
  
FunctionEnd

# define the name of the installer file
Outfile "Golden Bones Installer.exe"

# define the look of the window
Name "Golden Bones"
Caption "$(^Name) Installer"
SubCaption 0 " - About"
RequestExecutionLevel user
BrandingText $verString
SetFont "Trebuchet MS" 10
InstallColors CBEFEB 242447
InstProgressFlags smooth colored

# File Information
VIAddVersionKey "ProductName" "Golden Bones Installer"
VIAddVersionKey "LegalCopyright" "copyright deez nuts :O"
VIAddVersionKey "FileDescription" "Install a Golden Bones Minecraft Profile"

# set installation presets
InstType "Default" IT_DEFA
InstType "Default +" IT_PLUS
InstType "Full" IT_FULL
InstType "Lite" IT_LITE
InstType "Sam's mod selection" IT_SAMS


# set the icon
Icon files\installerAssets\icon.ico

# define the directory to install to
InstallDir '$APPDATA\minecraftProfiles\instances\goldenBones\seasonFive'

# show info page
Page license


LicenseText $licText "Continue"
LicenseData files\installerAssets\about.rtf

# choose components page
Page components closeWarning componentShow
ComponentText "Choose from a preset selection of mods to install. You can also use the checkboxes next to specific features that you do or don't like." "$\tSelection Details" "The default 'Recommended' install preset is ideal for most players. You can also choose to toggle some of the options depending on your personal preferences.$\nNote: Unselected components will be uninstalled if they've been installed before."

# now actually install it page
Page instfiles

# Section for java and fabric installers and everything that is required NO MATTER WHAT
SectionGroup "Dependencies"
 Section "Java 21"

  # set section type
  SectionInstType ${IT_DEFA} ${IT_PLUS} ${IT_FULL} ${IT_LITE} ${IT_SAMS} RO
  DetailPrint "Checking for dependencies..."
  # check for temurin and install it
  IfFileExists '$PROGRAMFILES64\Eclipse Adoptium\jdk-21.0.4.7-hotspot\bin\javaw.exe' skipTemurin 0
    DetailPrint "Latest Temurin 21 version not found."
    MessageBox MB_ICONINFORMATION|MB_OKCANCEL|MB_DEFBUTTON1 "An outdated Java 21 was detected!$\nThis is required for running any Minecraft mods.$\n$\n$\tEclipse Temurin 21 is one of the best Java 21 builds.$\n$\tClick Okay to install it automatically.$\n$\n(Click Okay unless you are a techno-wiz that's certain you already have Java 21 installed)" /SD IDOK IDCANCEL skipTemurin
    DetailPrint "Installing Temurin 21..."
	SetOutPath $TEMP\gbsInstaller
	inetc::get /CAPTION "Downloading Java Installer Package" "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.4%2B7/OpenJDK21U-jdk_x64_windows_hotspot_21.0.4_7.msi" "$TEMP\gbsInstaller\OpenJDK21U-jdk_x64_windows_hotspot_21.0.4_7.msi" /end
    ExecWait '"msiexec" /i "$TEMP\gbsInstaller\OpenJDK21U-jdk_x64_windows_hotspot_21.0.4_7.msi" ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome,FeatureOracleJavaSoft INSTALLDIR="C:\Program Files\Eclipse Adoptium\jdk-21.0.4.7-hotspot\" /qb+!'
    Delete $TEMP\gbsInstaller\OpenJDK21U-jdk_x64_windows_hotspot_21.0.4_7.msi
	DetailPrint "Temurin 21 installed."
  skipTemurin:
 SectionEnd
 Section "Fabric"
  # set section type
  SectionInstType ${IT_DEFA} ${IT_PLUS} ${IT_FULL} ${IT_LITE} ${IT_SAMS} RO
  # check for fabric and install it
  IfFileExists '$APPDATA\.minecraft\versions\fabric-loader-0.16.2-1.21.1\fabric-loader-0.16.2-1.21.1.json' skipFabric 0
    DetailPrint "Latest Fabric version not found."
    DetailPrint "Installing Fabric..."
	SetOutPath $TEMP\gbsInstaller
	File files\dependencies\fabric-installer-1.0.1.exe
    ExecWait 'javaw -jar "$TEMP\gbsInstaller\fabric-installer-1.0.1.exe" client -mcversion "1.21.1" -noprofile -dir "$APPDATA\.minecraft"'
    Delete $TEMP\gbsInstaller\fabric-installer-1.0.1.exe
	DetailPrint "Fabric installed."
  skipFabric:
 SectionEnd
SectionGroupEnd

SetOverwrite ifdiff

Section "Essential Mods"
  SectionInstType ${IT_DEFA} ${IT_PLUS} ${IT_FULL} ${IT_LITE} ${IT_SAMS} RO
  DetailPrint "Installing essential mods..."
  SetOutPath $INSTDIR\mods
  File files\mcFiles\core\mods\*.jar
  DetailPrint "Essential mods installed."
  DetailPrint "Checking for optional mods requested by the user..."
SectionEnd

# Improvements Section
SectionGroup "Rendering"

  # Nvidium (only works on newer nvidia graphics cards)
  Section /o "Nvidium" nvidium_section_id
	  File files\mcFiles\optional\mods\nvidium-0.2.9-beta.jar
	  DetailPrint "Nvidium installed."
  SectionEnd  
  
# bobby
  Section "Bobby"
    SectionInstType ${IT_DEFA} ${IT_PLUS} ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\bobby-5.2.3+mc1.21.jar
	DetailPrint "Bobby installed."
  SectionEnd
  
  # simple fog
  Section /o "Simple Fog Controls"
    SectionInstType ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\simplefog-1.6.0.jar
	DetailPrint "SimpleFog installed."
  SectionEnd
SectionGroupEnd

SectionGroup "UI"
  
  # detail armor bar
  Section "Detailed Armor Bar"
    SectionInstType ${IT_DEFA} ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\DetailArmorBar-2.6.3+1.21.1-fabric.jar
	DetailPrint "DetailArmorBar installed."
  SectionEnd
  
  # appleskin
  Section /o "Appleskin"
    SectionInstType ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\appleskin-fabric-mc1.21-3.0.5.jar
	DetailPrint "Appleskin installed."
  SectionEnd
  
  # better F3
  Section /o "BetterF3 Menu"
    SectionInstType ${IT_PLUS} ${IT_FULL} ${IT_SAMS}
    # define what to install and place it in the output path
    File files\mcFiles\optional\mods\BetterF3-11.0.1-Fabric-1.21.jar
	DetailPrint "BetterF3 installed."
  SectionEnd
  
  # raised hotbar
  Section /o "Raised"
    SectionInstType ${IT_PLUS} ${IT_FULL} ${IT_SAMS}
    # define what to install and place it in the output path
    File files\mcFiles\optional\mods\raised-fabric-1.21-4.0.0.jar
	DetailPrint "Raised installed."
  SectionEnd
  
  # dynamic crosshair
  Section /o "Dynamic Crosshair"
    SectionInstType ${IT_FULL}
    File files\mcFiles\optional\mods\dynamiccrosshair-8.1+1.21-fabric.jar
	DetailPrint "DynamicCrosshair installed."
  SectionEnd
  
  # autohud
  Section /o "AutoHUD"
    SectionInstType ${IT_FULL}
    File files\mcFiles\optional\mods\autohud-7.2.1+1.21-fabric.jar
	DetailPrint "AutoHUD installed."
  SectionEnd
   
  # rrls
  Section /o "Remove RP Reload Screen"
    SectionInstType ${IT_PLUS} ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\rrls-5.0.7+mc1.21-fabric.jar
	DetailPrint "RRLS installed."
  SectionEnd
  
# NowPlaying
  Section /o "Now Playing"
    SectionInstType ${IT_FULL}
    File files\mcFiles\optional\mods\now-playing-fabric-1.21-1.5.5.jar
	DetailPrint "NowPlaying installed."
  SectionEnd
  
SectionGroupEnd

Function componentShow
  #check for nvidium compatibility
  StrCmp $graphicsPrefix '16' nvidiaEnabled
  StrCmp $graphicsPrefix '20' nvidiaEnabled
  StrCmp $graphicsPrefix '30' nvidiaEnabled
  StrCmp $graphicsPrefix '40' nvidiaEnabled
  #if it isn't compatible
  SectionSetText ${nvidium_section_id} "Nvidium  (incompatible)"
  SectionSetInstTypes ${nvidium_section_id} 0
  SectionGetFlags ${nvidium_section_id} $3
  IntOp $3 $3 | ${SF_RO}
  SectionSetFlags ${nvidium_section_id} $3
  Return
  #if it is compatible
  nvidiaEnabled:
    SectionSetInstTypes ${nvidium_section_id} 31
    IntOp $4 ${SF_BOLD} | ${SF_SELECTED}
	SectionSetFlags ${nvidium_section_id} $4
FunctionEnd



SectionGroup "Atmosphere and Charm"
  
  # visuality
  Section /o "Visuality"
    SectionInstType ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\visuality-0.7.7+1.21.jar
	DetailPrint "Visuality installed."
  SectionEnd
  
  # chat heads
  Section /o "Chat Heads"
    SectionInstType ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\chat_heads-0.12.10-fabric-1.21.jar
	DetailPrint "ChatHeads installed."
  SectionEnd
  
  # Eating animation
  Section /o "Eating Animation"
    SectionInstType ${IT_PLUS} ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\eating-animation-1.21+1.9.72.jar
	DetailPrint "Eating Animation installed."
  SectionEnd
  
SectionGroupEnd
  
# Utility and Control Section
SectionGroup "Utility and Control"
  
  # minihud
  Section /o "MiniHUD"
    SectionInstType ${IT_FULL}
    # define what to install and place it in the output path
    File files\mcFiles\optional\mods\minihud-fabric-1.21-0.31.999-sakura.23.jar
	DetailPrint "MiniHUD installed."
  SectionEnd
  
  # litematica
  Section /o "Litematica"
    SectionInstType ${IT_FULL}
    File files\mcFiles\optional\mods\litematica-fabric-1.21-0.19.1.jar
	DetailPrint "Litematica installed."
  SectionEnd
  
  # music control
  Section /o "Music Control"
    SectionInstType ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\music_control-1.8.3+1.21.jar
	DetailPrint "MusicControl installed."
  SectionEnd
  
  # spark
  Section /o "Spark"
    SectionInstType ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\spark-1.10.97-fabric.jar
	DetailPrint "Spark installed."
  SectionEnd  
  
  # peek
  Section /o "Peek"
    SectionInstType ${IT_PLUS} ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\peek-fabric-1.21.1-1.3.4.jar
	DetailPrint "Peek installed."
  SectionEnd
  
  # tweakermore
  Section /o "TweakerMore"
    SectionInstType ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\tweakermore-v3.20.1-mc1.21.jar
	DetailPrint "TweakerMore installed."
  SectionEnd
  
SectionGroupEnd

# Misc section
SectionGroup "Misc"

  # fastquit
  Section /o "Fast Quit"
    SectionInstType ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\fastquit-3.0.0+1.20.6.jar
	DetailPrint "FastQuit installed."
  SectionEnd
  
  # Replay mod
  Section /o "Replay Mod"
    SectionInstType ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\replaymod-1.21-2.6.17.jar
	DetailPrint "ReplayMod installed."
  SectionEnd

SectionGroupEnd

##install config and create profile with hidden section
Section "-Config"
  DetailPrint "Installing default resourcepack..."
  SetOutPath $INSTDIR\resourcepacks
  File files\mcFiles\core\resourcepacks\*.zip
  DetailPrint "Resourcepack installed."
  DetailPrint "Configuring..."
  SetOutPath $INSTDIR\config\.puzzle_cache
  File files\mcFiles\core\config\.puzzle_cache\mojangstudios.png
  SetOverwrite off
  SetOutPath $INSTDIR\config\carpet
  File files\mcFiles\core\config\carpet\default_carpet.conf
  SetOutPath $INSTDIR\config\music_control
  File files\mcFiles\core\config\music_control\*.json
  SetOutPath $INSTDIR\config\NoChatReports
  File files\mcFiles\core\config\NoChatReports\NCR-Client.json
  SetOutPath $INSTDIR\config\peek
  File files\mcFiles\core\config\peek\peek.properties
  SetOutPath $INSTDIR\config\respackopts
  File files\mcFiles\core\config\respackopts\_respackopts.conf
  SetOutPath $INSTDIR\config\sound_physics_remastered
  File files\mcFiles\core\config\sound_physics_remastered\soundphysics.properties
  SetOutPath $INSTDIR\config\status
  File files\mcFiles\core\config\status\state-client.properties
  SetOutPath $INSTDIR\config\yosbr
  File files\mcFiles\core\config\yosbr\options.txt
  SetOutPath $INSTDIR
  File files\mcFiles\core\dump\*.*
  #other yosbr files lol
  SetOutPath $INSTDIR\config
  File files\mcFiles\core\config\badoptimizations.txt
  File files\mcFiles\core\config\bobby.conf
  File files\mcFiles\core\config\*.json5
  File files\mcFiles\core\config\*.json
  File files\mcFiles\core\config\*.properties
  File files\mcFiles\core\config\*.toml
  File files\mcFiles\core\config\*.cfg
  DetailPrint "Options configured successfully."
  DetailPrint "Creating launcher installation..."
  #create the launcher Profile
  nsJSON::Set /file '$APPDATA\.minecraft\launcher_profiles.json'
  nsJSON::Quote '$INSTDIR'
  Pop $7
  nsJSON::Set "profiles" "golden-bones-season5" "gameDir" /value '$7'
  nsJSON::Set "profiles" "golden-bones-season5" "lastVersionId" /value '"fabric-loader-0.15.11-1.20.6"'
  nsJSON::Set "profiles" "golden-bones-season5" "name" /value '"Golden Bones Season V"'
  nsJSON::Set "profiles" "golden-bones-season5" "icon" /value '"data:image/png;base64,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"'
  nsJSON::Set "profiles" "golden-bones-season5" "javaArgs" /value '"-Xms6G -Xmx6G -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+AlwaysActAsServerClassMachine -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseNUMA -XX:NmethodSweepActivity=1 -XX:ReservedCodeCacheSize=400M -XX:NonNMethodCodeHeapSize=12M -XX:ProfiledCodeHeapSize=194M -XX:NonProfiledCodeHeapSize=194M -XX:-DontCompileHugeMethods -XX:MaxNodeLimit=240000 -XX:NodeLimitFudgeFactor=8000 -XX:+UseVectorCmov -XX:+PerfDisableSharedMem -XX:+UseFastUnorderedTimeStamps -XX:+UseCriticalJavaThreadPriority -XX:ThreadPriorityPolicy=1 -XX:AllocatePrefetchStyle=3 -XX:+UseG1GC -XX:MaxGCPauseMillis=37 -XX:+PerfDisableSharedMem -XX:G1HeapRegionSize=16M -XX:G1NewSizePercent=23 -XX:G1ReservePercent=20 -XX:SurvivorRatio=32 -XX:G1MixedGCCountTarget=3 -XX:G1HeapWastePercent=20 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1RSetUpdatingPauseTimePercent=0 -XX:MaxTenuringThreshold=1 -XX:G1SATBBufferEnqueueingThresholdPercent=30 -XX:G1ConcMarkStepDurationMillis=5.0 -XX:G1ConcRSHotCardLimit=16 -XX:G1ConcRefinementServiceIntervalMillis=150 -XX:GCTimeRatio=99"'
  nsJSON::Set "profiles" "golden-bones-season5" "javaDir" /value '"C:\\Program Files\\Eclipse Adoptium\\jdk-21.0.4.7-hotspot\\bin\\javaw.exe"'
  nsJSON::Set "profiles" "golden-bones-season5" "type" /value '"custom"'
  nsJSON::Serialize /format /file '$APPDATA\.minecraft\launcher_profiles.json'
  DetailPrint "Launcher installation created and configured."
  
SectionEnd



# At end of Program

#successful install
Function .onInstSuccess
  WriteRegStr HKEY_CURRENT_USER SOFTWARE\gbInstaller version $ver
FunctionEnd

Function .onUserAbort
  MessageBox MB_OK "bruh cringe"
  
FunctionEnd

#failed install
Function .onInstFailed
  MessageBox MB_OK "INSTALL FAILURE"
FunctionEnd