{{/* Command Type: Reaction Added only Made By Crenshaw#1312*/}}

{{if and (eq (userArg .Message.Author).ID 204255221017214977) (dbGet .User.ID "guide")}}
	{{$x := (index .ReactionMessage.Embeds 0)}}
{{if eq $x.Title "What Path?"}}
	{{deleteAllMessageReactions nil .ReactionMessage.ID}}
 
{{/*for 1 Books*/}}
	{{if ge ((index .ReactionMessage.Reactions 0).Count) 2}}
		{{$e := cembed
			"title" (title "Books") "description" "```css\n#1 [eBooks]\n#2 [audioBooks]\n#3 [Manga]\n#4 [Comics]\n#5 [Magazine]\n```"}}
		 {{editMessage nil .ReactionMessage.ID $e}}
		{{addMessageReactions nil .ReactionMessage.ID ":one:" ":two:" ":three:" ":four:" ":five:"}}
	{{end}} 
{{/*for 2 Movies and TV*/}}
	{{if ge ((index .ReactionMessage.Reactions 1).Count) 2}}
		{{$e := cembed 
			"title" (title "Movies and TV")	"description" (joinStr "" "```css\n#1 [DDL+Torrent]\n#2 [Streaming]\n#3 [Apps]\n```")}}
		{{editMessage nil .ReactionMessage.ID $e}}
		{{addMessageReactions nil .ReactionMessage.ID ":one:" ":two:" ":three:"}}
	{{end}}
 
{{/*for 3 Games*/}}
	{{if ge ((index .ReactionMessage.Reactions 2).Count) 2}}
		{{$e := cembed
			"title" (title "Games") "description" (joinStr "" "```css\n#1 [General]\n#2 [android/ios]\n#3 [Bad Sites]\n```")}}
		{{editMessage nil .ReactionMessage.ID $e}}
		{{addMessageReactions nil .ReactionMessage.ID ":one:" ":two:" ":three:"}}
	{{end}}
 
{{/*for 4 Software*/}}
	{{if ge ((index .ReactionMessage.Reactions 3).Count) 2}}
		{{$e := cembed
			"title" (title "Software") "description" (joinStr "" "```css\n#1 [Download Tools]\n#2 [Torrent]\n```")}}
		{{editMessage nil .ReactionMessage.ID $e}}
		{{addMessageReactions nil .ReactionMessage.ID ":one:" ":two:"}}
	{{end}}
{{end}}
{{end}}
