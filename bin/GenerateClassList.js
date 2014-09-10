var fso = new ActiveXObject("Scripting.FileSystemObject");

var tFile = fso.CreateTextFile("../src/manifest.xml", true);
var fldr = fso.GetFolder("../src");

tFile.writeLine('<?xml version="1.0"?>');
tFile.writeLine('<componentPackage>');

scanFla("", fldr);
tFile.writeLine('</componentPackage>');

function scanFla(dirName, fldr){
	// ����Ŀ¼
	
	var fc = new Enumerator(fldr.SubFolders);
	
	while(!fc.atEnd())
	{
		scanFla(dirName+"/"+fc.item().name, fc.item());
		fc.moveNext();
	}

	var fc = new Enumerator(fldr.files);
	
	
	while(!fc.atEnd())
	{
		if(fc.item().name.indexOf(".as") > 0 && fc.item().name.indexOf(".svn") == -1)
		{
			var name = fc.item().name.split(".")[0];
			var packageName = dirName+"/"+name;
			packageName = packageName.split("/").join(".");
			tFile.writeLine('<component class="'+packageName.substr(1)+'"/>');
		}
		fc.moveNext();
	}
	
}

alert=function(s){WScript.Echo(s)};
alert("Done");