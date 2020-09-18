{{/*Made by Crenshaw#7860
	Get search query links to any specified google drive*/}}
	
	{{$args := parseArgs 2 "gdrive <file type> <file name> *The File types are* `folder`-`video`-`image`-`pdf`-`drawing`-`audio`-`archive`-`form`-`document`-`spreadsheet`-`presentation`"
	(carg "string" "File type")
	(carg "string" "File Name")}}
	{{$gdriveID:="0ACBAa6Gbh8CFUk9PVA"}}
	{{$link := (reReplace " " (joinStr "" "https://drive.google.com/drive/u/0/search?q=type:" ($args.Get 0) "%20" ($args.Get 1) "%20in:" $gdriveID) "%20")}}
	
	 {{if reFind `(folder|video|image|pdf|drawing|audio|archive|form|document|spreadsheet|presentation)` ($args.Get 0)}}
		 {{sendMessage nil (cembed
		 "thumbnail" (sdict "url" (joinStr "" "https://cdn.discordapp.com/icons/" .Guild.ID "/" .Guild.Icon ".jpeg?size=1024"))
		 "title" (title ($args.Get 1))
		 "description" ($link)
		 "color" 123
		 "footer" (sdict "text" (joinStr "" "Search from " .User.String) "icon_url" (.User.AvatarURL "128")))}}
	{{else}}
		 {{sendMessage nil "gdrive <file type> <file name> *The File types are* `folder`-`video`-`image`-`pdf`-`drawing`-`audio`-`archive`-`form`-`document`-`spreadsheet`-`presentation`"}}
	{{end}}