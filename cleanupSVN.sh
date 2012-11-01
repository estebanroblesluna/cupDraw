cd ../src/main/webapp/webspec/Frameworks
rm -R Objective-J/ Foundation/ AppKit/ Debug/Objective-J/ Debug/Foundation/ Debug/AppKit/
svn up Objective-J/ Foundation/ AppKit/ Debug/Objective-J/ Debug/Foundation/ Debug/AppKit/
svn checkout --depth infinity --force https://webspec-language.googlecode.com/svn/trunk/modules/webspeclanguage-webdiagrameditor/src/main/webapp/webspec/Frameworks/CupDraw CupDraw
svn checkout --depth infinity --force https://webspec-language.googlecode.com/svn/trunk/modules/webspeclanguage-webdiagrameditor/src/main/webapp/webspec/Frameworks/Debug/CupDraw Debug/CupDraw
cd ../../../../../CupDraw