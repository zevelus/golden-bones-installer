!include WinMessages.nsh
!define SF_SELECTED   1
!define SF_BOLD       8
!define SF_RO         16
# Version Information
VIAddVersionKey "ProductVersion" "2.4.0"
VIAddVersionKey "FileVersion" "2.4.0"
VIProductVersion "2.4.0.0"
VIFileVersion "2.4.0.0"

Function .onInit
  Var /GLOBAL ver
  Var /GLOBAL fullVer
  Var /GLOBAL verString
  Var /GLOBAL newInstall
  StrCpy $ver "2.4.0"
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
    StrCpy $licText "Some Quick Info Before Reinstalling"
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
  
  StrCmp $0 4 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:This is a collection of mods that are either required to connect to the Golden Bones server, or improve Minecraft without any drawbacks."
	
  StrCmp $0 5 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:These are mods that can increase chunk rendering performance, give extra control over how the world looks, or alter rendering in some other way."
	
  StrCmp $0 6 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Nvidium uses special technology to dramatically increase rendering performance. However, it only works on NVIDIA graphics cards from the 16xx series up.$\nDetected GPU:$\n$graphicsCard"
  
  StrCmp $0 7 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Bobby saves renders of chunks to your computer temporarily, allowing you to load chunks not sent by the server. Basically it lets you have higher render distances."
	
  StrCmp $0 8 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:This mod adds some simple control sliders to your settings, allowing you to easily adjust how your fog looks."
	
  StrCmp $0 10 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:These mods tweak various aspects of the User Interface."
	
  StrCmp $0 11 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:This mod lets you customize the armor bar. You can add small animations, representations of your armor type, and more!"
	
  StrCmp $0 12 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:This mod is about giving you more information on your hunger. This lets you see your saturation, or optionally see the hunger values of foods."

  StrCmp $0 13 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Raises the hotbar, (which is normally cut off) and allows you to move various UI elements around on your screen."
	
  StrCmp $0 14 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Adds a very small animation to items in the inventory. When you select an item, it will be slightly bigger. This is already a feature in Bedrock Edition."

   StrCmp $0 15 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Quickly find new items by showing an animated star on all newly picked-up items."

  StrCmp $0 16 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:BetterF3 completely overhauls the F3 Debug menu. You can customize what shows on this screen, color code sections, and more!"
	
  StrCmp $0 17 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:With this mod, you can customize the crosshair like never before. You can have the crosshair change depending on what its pointed at."
	
  StrCmp $0 18 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:AutoHUD allows almost every part of the HUD to be hidden based on the situation. It is highly customizable."

  StrCmp $0 19 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Removes the resourcepack reload screen. Allows you to get back to playing much faster after changing recourcepacks."
	
  StrCmp $0 20 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Shows you what song is playing when it changes."
		
  StrCmp $0 22 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:These mods add small things that make the game feel a little more charming and immersive."
	
  StrCmp $0 23 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Visuality adds some customizable effects and particles, such as bones for hitting skeletons and slime when hitting slime. It is highly customizable."
  
  StrCmp $0 24 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:A very simple mod that adds an icon of players' heads in front of their username in the chat."
  
  StrCmp $0 25 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Simply add an animation to food items while you eat them. Very customizable, even with resourcepacks."
	
  StrCmp $0 27 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:These mods provide additional information and control over the game."
  
  StrCmp $0 28 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:An insanely customizable mod capable of providing loads of useful information in a togglable miniHUD."
	
  StrCmp $0 29 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Litematica lets you create and view schematics. Great for transfering builds from creative to survival."
	
  StrCmp $0 30 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:This mod allows you to take control over Minecraft's in game music. Choose tracks, skip, add music, and more!"
	
  StrCmp $0 31 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Spark is a powerful tool for analyzing various performance metrics in the game."
	
  StrCmp $0 32 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:This mod lets you see certain extra info about special blocks and items such as beehives and shulker boxes. This is highly customizable and all features can be disbaled."

  StrCmp $0 33 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:This mod has additional features and functionality for the Tweakeroo mod, which is installed by default."
	
  StrCmp $0 35 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Other miscellaneous mods with cool features."
	
  StrCmp $0 36 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Quit your world and save it in the background while you use the menu, instead of having to wait for the save screen."
	
  StrCmp $0 37 "" +2
    SendMessage $R0 ${WM_SETTEXT} 0 "STR:Allows you to record replays of sessions where you can later view them and even edit them into cinematics."
  
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

# nsDialogs custom page. 


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
  IfFileExists '$PROGRAMFILES64\Eclipse Adoptium\jdk-21.0.6.7-hotspot\bin\javaw.exe' skipTemurin 0
    DetailPrint "Latest Temurin 21 version not found."
    MessageBox MB_ICONINFORMATION|MB_OKCANCEL|MB_DEFBUTTON1 "An outdated Java 21 was detected!$\nThis is required for running any Minecraft mods.$\n$\n$\tEclipse Temurin 21 is one of the best Java 21 builds.$\n$\tClick Okay to install it automatically.$\n$\n(Click Okay unless you are a techno-wiz that's certain you already have Java 21 installed)" /SD IDOK IDCANCEL skipTemurin
    DetailPrint "Installing Temurin 21..."
	SetOutPath $TEMP\gbsInstaller
	inetc::get /CAPTION "Downloading Java Installer Package" "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.6%2B7/OpenJDK21U-jdk_x64_windows_hotspot_21.0.6_7.msi" "$TEMP\gbsInstaller\OpenJDK21U-jdk_x64_windows_hotspot_21.0.6_7.msi" /end
    ExecWait '"msiexec" /i "$TEMP\gbsInstaller\OpenJDK21U-jdk_x64_windows_hotspot_21.0.6_7.msi" ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome,FeatureOracleJavaSoft INSTALLDIR="C:\Program Files\Eclipse Adoptium\jdk-21.0.6.7-hotspot\" /qb+!'
    Delete $TEMP\gbsInstaller\OpenJDK21U-jdk_x64_windows_hotspot_21.0.6_7.msi
	DetailPrint "Temurin 21 installed."
  skipTemurin:
 SectionEnd
 Section "Fabric"
  # set section type
  SectionInstType ${IT_DEFA} ${IT_PLUS} ${IT_FULL} ${IT_LITE} ${IT_SAMS} RO
  # check for fabric and install it
  IfFileExists '$APPDATA\.minecraft\versions\fabric-loader-0.16.10-1.21.4\fabric-loader-0.16.10-1.21.4.json' skipFabric 0
    DetailPrint "Latest Fabric version not found."
    DetailPrint "Installing Fabric..."
	SetOutPath $TEMP\gbsInstaller
	File files\dependencies\fabric-installer-1.0.1.jar
    ExecWait '"$PROGRAMFILES64\Eclipse Adoptium\jdk-21.0.6.7-hotspot\bin\javaw.exe" -jar "$TEMP\gbsInstaller\fabric-installer-1.0.1.jar" client -mcversion "1.21.4" -noprofile -dir "$APPDATA\.minecraft"'
    Delete $TEMP\gbsInstaller\fabric-installer-1.0.1.jar
	DetailPrint "Fabric installed."
  skipFabric:
 SectionEnd
SectionGroupEnd

SetOverwrite ifdiff

Section "Essential Mods"
  SectionInstType ${IT_DEFA} ${IT_PLUS} ${IT_FULL} ${IT_LITE} ${IT_SAMS} RO
  DetailPrint "Installing essential mods..."
  SetOutPath $INSTDIR\mods
  Delete $INSTDIR\mods\*.jar
  File files\mcFiles\core\mods\*.jar
  DetailPrint "Essential mods installed."
  DetailPrint "Checking for optional mods requested by the user..."
SectionEnd

# Improvements Section
SectionGroup "Rendering"

  # Nvidium (only works on newer nvidia graphics cards)
  #TEMPORARY CHANGES TO THIS SECTION: the section title says not updated yet. the DetailPrint line for saying nvidium installed had been commented out.
  Section /o "Nvidium - Unavailable" nvidium_section_id
	  File files\mcFiles\optional\mods\nvidium.placeholder
	  #DetailPrint "Nvidium installed."
  SectionEnd  
  
# bobby
  Section "Bobby"
    SectionInstType ${IT_DEFA} ${IT_PLUS} ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\bobby-5.2.6+mc1.21.4.jar
	DetailPrint "Bobby installed."
  SectionEnd
  
  # simple fog
  Section /o "Simple Fog Controls"
    SectionInstType ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\simplefog-1.7.1.jar
	DetailPrint "SimpleFog installed."
  SectionEnd
SectionGroupEnd

SectionGroup "UI"
  
  # detail armor bar
  Section "Detailed Armor Bar"
    SectionInstType ${IT_DEFA} ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\DetailArmorBar-2.6.3+1.21.3-fabric.jar
	DetailPrint "DetailArmorBar installed."
  SectionEnd
  
  # appleskin
  Section /o "Appleskin"
    SectionInstType ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\appleskin-fabric-mc1.21.3-3.0.6.jar
	DetailPrint "Appleskin installed."
  SectionEnd
  
  # Raised (13)
  Section /o "Raised"
    SectionInstType ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\raised-fabric-1.21.3-4.0.1.jar
	DetailPrint "Raised installed."
  SectionEnd
  
  # TIA
  Section /o "NEW - Tiny Item Animations"
    SectionInstType ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\tia-fabric-1.21.3-1.2.2.jar
	DetailPrint "TIA installed."
  SectionEnd
  
  # Item Highlighter
  Section /o "NEW - Item Highlighter"
    SectionInstType ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\Highlighter-1.21.4-fabric-1.1.11.jar
	File files\mcFiles\optional\mods\Iceberg-1.21.4-fabric-1.2.13.jar
	DetailPrint "Item Highlighter installed."
  SectionEnd
  
  # better F3
  Section /o "BetterF3 Menu"
    SectionInstType ${IT_FULL} ${IT_SAMS}
    # define what to install and place it in the output path
    File files\mcFiles\optional\mods\BetterF3-13.0.0-Fabric-1.21.4.jar
	DetailPrint "BetterF3 installed."
  SectionEnd
  
  # dynamic crosshair
  Section /o "Dynamic Crosshair"
    SectionInstType ${IT_FULL}
    File files\mcFiles\optional\mods\dynamiccrosshair-9.3+1.21.3-fabric.jar
	DetailPrint "DynamicCrosshair installed."
  SectionEnd
  
  # autohud
  Section /o "AutoHUD"
    SectionInstType ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\autohud-8.2+1.21.3-fabric.jar
	DetailPrint "AutoHUD installed."
  SectionEnd
   
  # rrls
  Section /o "Remove RP Reload Screen"
    SectionInstType ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\rrls-5.1.1+mc1.21.4-fabric.jar
	File files\mcFiles\optional\mods\ForgeConfigAPIPort-v21.4.1-1.21.4-Fabric.jar
	DetailPrint "RRLS installed."
  SectionEnd
  
# NowPlaying
  Section /o "Now Playing"
    SectionInstType ${IT_FULL}
    File files\mcFiles\optional\mods\now-playing-fabric-1.5.13+1.21.4.jar
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
    File files\mcFiles\optional\mods\visuality-0.7.9+1.21.4.jar
	DetailPrint "Visuality installed."
  SectionEnd
  
  # chat heads
  Section /o "Chat Heads"
    SectionInstType ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\chat_heads-0.13.14-fabric-1.21.4.jar
	DetailPrint "ChatHeads installed."
  SectionEnd
  
  # Eating animation
  Section /o "Eating Animation - Unavailable"
    SectionInstType ${IT_PLUS} ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\eating-animation.placeholder
	DetailPrint "Eating Animation installed."
  SectionEnd
  
SectionGroupEnd
  
# Utility and Control Section
SectionGroup "Utility and Control"
  
  # minihud
  Section /o "MiniHUD"
    SectionInstType ${IT_PLUS} ${IT_FULL} ${IT_SAMS}
    # define what to install and place it in the output path
    File files\mcFiles\optional\mods\minihud-fabric-1.21.4-0.34.4.jar
	DetailPrint "MiniHUD installed."
  SectionEnd
  
  # litematica
  Section /o "Litematica"
    SectionInstType ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\litematica-fabric-1.21.4-0.21.2.jar
	DetailPrint "Litematica installed."
  SectionEnd
  
  # music control
  Section /o "Music Control"
    SectionInstType ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\music_control-1.9+1.21.4.jar
	DetailPrint "MusicControl installed."
  SectionEnd
  
  # spark
  Section /o "Spark"
    SectionInstType ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\spark-1.10.121-fabric.jar
	DetailPrint "Spark installed."
  SectionEnd  
  
  # peek
  Section /o "Peek"
    SectionInstType ${IT_PLUS} ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\peek-fabric-1.21.4-1.4.1.jar
	DetailPrint "Peek installed."
  SectionEnd
  
  # tweakermore
  Section /o "TweakerMore"
    SectionInstType ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\tweakermore-v3.24.1-mc1.21.4.jar
	DetailPrint "TweakerMore installed."
  SectionEnd
  
SectionGroupEnd

# Misc section
SectionGroup "Misc"

  # fastquit
  Section /o "Fast Quit"
    SectionInstType ${IT_FULL} ${IT_PLUS} ${IT_SAMS}
    File files\mcFiles\optional\mods\fastquit-3.0.0+1.21.4.jar
	DetailPrint "FastQuit installed."
  SectionEnd
  
  # Replay mod
  Section /o "Replay Mod"
    SectionInstType ${IT_FULL} ${IT_SAMS}
    File files\mcFiles\optional\mods\replaymod-1.21.4-2.6.21.jar
	DetailPrint "ReplayMod installed."
  SectionEnd

SectionGroupEnd

##install config and create profile with hidden section
Section "-Config"
  Var /GLOBAL doesOldLaunchProfileExist
  DetailPrint "Installing default resourcepack..."
  SetOutPath $INSTDIR\resourcepacks
  File files\mcFiles\core\resourcepacks\*.zip
  DetailPrint "Resourcepacks installed."
  DetailPrint "Configuring..."
 # SetOutPath $INSTDIR\config\.puzzle_cache
  #File files\mcFiles\core\config\.puzzle_cache\mojangstudios.png
  SetOverwrite off
  # copy options file from last version
  IfFileExists '$APPDATA\minecraftProfiles\instances\goldenBones\gbsV_1206_v1\options.txt' 0 noSaves
  IfFileExists '$APPDATA\minecraftProfiles\instances\goldenBones\seasonFive\options.txt' noSaves 0
  SetOutPath $INSTDIR
  CopyFiles /SILENT /FILESONLY $APPDATA\minecraftProfiles\instances\goldenBones\gbsV_1206_v1\options.txt $INSTDIR
  DetailPrint "Options copied."
  
  #copy saves and shaders if the user wants
  IfFileExists '$APPDATA\minecraftProfiles\instances\goldenBones\gbsV_1206_v1\options.txt' 0 noSaves
  MessageBox MB_USERICON|MB_YESNO|MB_TOPMOST|MB_DEFBUTTON1 "Would you like to copy saves and shaderpacks from your 1.20.6 Golden Bones profile to your new one?" /SD IDYES IDNO noSaves
  CopyFiles /SILENT '$APPDATA\minecraftProfiles\instances\goldenBones\gbsV_1206_v1\saves\*' $INSTDIR\saves
  DetailPrint "World saves copied."
  CopyFiles /SILENT '$APPDATA\minecraftProfiles\instances\goldenBones\gbsV_1206_v1\shaderpacks\*' $INSTDIR\shaderpacks
  DetailPrint "Shaders copied."
  noSaves:
 # SetOutPath $INSTDIR\config\carpet
 # File files\mcFiles\core\config\carpet\default_carpet.conf
  SetOutPath $INSTDIR\config\NoChatReports
  File files\mcFiles\core\config\NoChatReports\NCR-Client.json
  SetOutPath $INSTDIR\config\peek
  File files\mcFiles\core\config\peek\peek.properties
  #SetOutPath $INSTDIR\config\respackopts
 # File files\mcFiles\core\config\respackopts\_respackopts.conf
  SetOutPath $INSTDIR\config\status
  File files\mcFiles\core\config\status\state-client.properties
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
  #File files\mcFiles\core\config\*.cfg
  DetailPrint "Options configured successfully."
  DetailPrint "Creating launcher installation..."
  #create the launcher Profile
  nsJSON::Set /file '$APPDATA\.minecraft\launcher_profiles.json'
  nsJSON::Quote '$INSTDIR'
  Pop $7
  nsJSON::Set "profiles" "golden-bones-seasonV" "gameDir" /value '$7'
  nsJSON::Set "profiles" "golden-bones-seasonV" "lastVersionId" /value '"fabric-loader-0.16.10-1.21.4"'
  nsJSON::Set "profiles" "golden-bones-seasonV" "name" /value '"Golden Bones Season V"'
  nsJSON::Set "profiles" "golden-bones-seasonV" "icon" /value '"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAMAAACdt4HsAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAACBUExURUdwTPfvUggxMffme+/FAM7WAELv1vfWAPf3ITHmxffvMffWEAhSQu/mnO/mxWPv3oRzGe/m5ilKQoRSGVLFrSnFnITm5hmca0KlnITexRl7a2NaEBmEjBmljIRzWmNCEGPO3lpCQqXm797vEGOlnFrvrYRSWqVzGWN7WmOEnK21zijRWRUAAAABdFJOUwBA5thmAAAACXBIWXMAAAsTAAALEwEAmpwYAAAD70lEQVRYw6VXiZbiNhCUkC255fHFOTAHk2Q32c3/f2CqWz7kY8CQNjDzeFS5+lRbqdYymJra5gWXWmNZa+NvXzab7UqGRQKGn0Cwnf3cOTfD60L7MQFDT++nzVQD0Hk+pgBcN01T+Gzi/7+vl/fTb7gRw/PcF4YpYnxpitLoWAF7f4GAy+UUxwF4401jtM5dkgwEjTGMz8YRBAMUbDeRAibQBaz0SdIyZJkvmqJsykkMEILN++l9lEn23xSFNqbQbiBgFyBrmkWOwuXXNs6CEJSlaUDiOgZOn5bXjGE7qySOodYg8PmIoDM/0zCtAidZ1J7/DgRatwRmrOFtV1/f5gSdLSiYeAGC+o9v8X0UU8alaTpnqD/BsIxP+OoLAWjwdBRjBbtlfLCxe4Ehrqd6Bwnf3H+ObxnidLKAXYzX/e2VSha6WhjMwFD/XQ8xkAQO+GUTBm86hjgL8+B/y4C2MqGzP3f/dDHA3fUKPDNIWYXWfqvrz+v4/sltPEofGiBBw42Xze5aX3fcDqEp5PMOHj8SBg0nMkG1k5Xh4f+bw1UQafqXLgxrqCpLlmHyCh9rZnRbUYiDpT8rsudNmKNR8a5jgAYisng77yV8TqmHGKCBqvNPojA91uOjzmINZO+m7yaDtfQ4PmbYW3oCryj24gm8shFD9gReIXYtg9cLq8Magr0dsvkEA9k9xV48ineS/ypMGP04g3OWvrgCAkM3IB7Aa6IPaYTgxTDmVuJdbhFE6aQn4uAczk6iV6Cr4EX6EIPj5kUMDuyCDfXAgfArGXiHyEVBxZk4dhqEYAVFOH+ShCwUHGWcEKl7gZCJHc1vNA8UcAx5KlqrbjO43Ptclsdo+nMpE18oJ1I3GRC0psHilccEjuwH7n6UKFI7IJaTkWDiYopj7cmj0xMKOAvgoI+DVVOGmCbJsXIZLKq5zuX8C0c/0bkSD+hHUCCLyNI6lGBP1U1Z8u4ngQjzi7tR8lh9dQSRBq2HqkiyUhclzIQ4tPMPWThyHR3Ox56gZzAlr+ZZ7wLu7XEaYmXX/fxFHVR8LokXkwVCYzE2PYEsjkBDgkE0uvlJg1mKhjV3ZoF92fRPBwkYvGHjYugHOMu3/OZsjGe9aUooHh4vEk6k96EQ+gEuhcRZ5Iocx8BrmCl1FpUCRJSFF7xTsQtVxa9Bf8iCxxNKhFdJEBE2wH4qH84WVczVGBGgKb2MejN6QGI3Ouunsj1WkoIhBuw/HheCiFlFJyO8VJKMlI8DRSlApopQS+n9g4GOe+7HIYsyXQu9Di+lxCPhPFQBh7D0a/Gch689ve4P0RMmp1Fyma48X/f7qI6fOB6lkNX/YCC6J+A/sas/f2s3ypsAAAAASUVORK5CYII="'
  nsJSON::Set "profiles" "golden-bones-seasonV" "javaArgs" /value '"-Xms6G -Xmx6G -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+AlwaysActAsServerClassMachine -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseNUMA -XX:NmethodSweepActivity=1 -XX:ReservedCodeCacheSize=400M -XX:NonNMethodCodeHeapSize=12M -XX:ProfiledCodeHeapSize=194M -XX:NonProfiledCodeHeapSize=194M -XX:-DontCompileHugeMethods -XX:MaxNodeLimit=240000 -XX:NodeLimitFudgeFactor=8000 -XX:+UseVectorCmov -XX:+PerfDisableSharedMem -XX:+UseFastUnorderedTimeStamps -XX:+UseCriticalJavaThreadPriority -XX:ThreadPriorityPolicy=1 -XX:AllocatePrefetchStyle=3 -XX:+UseG1GC -XX:MaxGCPauseMillis=37 -XX:+PerfDisableSharedMem -XX:G1HeapRegionSize=16M -XX:G1NewSizePercent=23 -XX:G1ReservePercent=20 -XX:SurvivorRatio=32 -XX:G1MixedGCCountTarget=3 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1RSetUpdatingPauseTimePercent=0 -XX:MaxTenuringThreshold=1 -XX:G1SATBBufferEnqueueingThresholdPercent=30 -XX:G1ConcMarkStepDurationMillis=5.0 -XX:G1ConcRSHotCardLimit=16 -XX:G1ConcRefinementServiceIntervalMillis=150 -XX:GCTimeRatio=99"'
  nsJSON::Set "profiles" "golden-bones-seasonV" "javaDir" /value '"C:\\Program Files\\Eclipse Adoptium\\jdk-21.0.6.7-hotspot\\bin\\javaw.exe"'
  nsJSON::Set "profiles" "golden-bones-seasonV" "type" /value '"custom"'
  # set the name of the old launcher profile if it exists
  nsJSON::Get /exists "profiles" "golden-bones-season5" /end
  Pop $doesOldLaunchProfileExist
  StrCmp $doesOldLaunchProfileExist "no" noOldLauncher
    nsJSON::Set "profiles" "golden-bones-season5" "icon" /value '"data:image/png;base64,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"'
    nsJSON::Set "profiles" "golden-bones-season5" "name" /value '"Golden Bones Season V - 1.20.6"'
  noOldLauncher:
  nsJSON::Serialize /format /file '$APPDATA\.minecraft\launcher_profiles.json'
  DetailPrint "Launcher installation created and configured."
  
  #Prompt user if they'd like to create a desktop shortcut to the profile directory
  IfFileExists '$DESKTOP\Golden Bones Folder.lnk' noShortcut
  MessageBox MB_USERICON|MB_YESNO|MB_TOPMOST|MB_DEFBUTTON1 "Would you like to create a desktop shortcut to this profile's .minecraft folder?" /SD IDYES IDNO noShortcut
  CreateShortcut /NoWorkingDir "$DESKTOP\Golden Bones Folder.lnk" "$INSTDIR"
  DetailPrint "Shortcut created."
  noShortcut:
  
SectionEnd



# At end of Program

#successful install
Function .onInstSuccess
  #set version stored in registry to current version
  WriteRegStr HKEY_CURRENT_USER SOFTWARE\gbInstaller version $ver
  #save installation data
  
FunctionEnd

Function .onUserAbort
  MessageBox MB_OK "bruh cringe. you cancelled the install..."
  
FunctionEnd

#failed install
Function .onInstFailed
  MessageBox MB_OK "INSTALL FAILURE"
FunctionEnd