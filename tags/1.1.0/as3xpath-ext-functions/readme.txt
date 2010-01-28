To build this project with Maven. Run mvn install on the command line, or use M2Eclipse install from the context menu.

To build this project using Flex Builder/Flash Builder, perform the following steps:
	1. Right-Click -> Add/Change project type -> Add Flex Library Project Type
	2. Right-Click -> Properties -> Flex Library Build Path
	3. On the "Library Path" screen, click "Add SWC Folder..", enter "lib", click "OK"
	4. On the "Source Path" screen, in "Main source folder:" type, "src/main/actionscript" without the quotes.
	5. Click "Add Folder...", enter "src/main/resources", click "OK"
	6. Click "Add Folder...", enter "src/test/actionscript", click "OK"
	7. Click "Add Folder...", enter "src/test/resources", click "OK"
	8. Click "OK"
	9. Download the FlexUnit4 libraries from http://www.digitalprimates.net/downloadit/FlexUnit4TurnkeyRC_1.0.zip and add the SWCs to the lib folder.
	
Building for release via Flex Builder/Flash Builder
	1. Right-Click -> Properties -> Flex Library Build Path -> Classes
	2. Deselect src/test/**