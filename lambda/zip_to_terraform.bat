for /d %%X in (*) do (
	if exist "%%X\package.json" (
	  REM copy "settings.js" "%%X\settings.js" 
	  cd %%X
	  
		if NOT exist "\node_modules" (
			npm install --production
		)
		
	  "c:\Program Files\7-Zip\7z.exe" a "%%X.zip" *
	  move "%%X.zip" "..\..\terraform\"
	  REM 		del "settings.js" 
	  cd ..
	)
)