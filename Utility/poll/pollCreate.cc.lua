{{/*
Made by: Crenshaw#1312
Thanks: DZ#6669 Reason: Made regex, ("[^"]*")|([^"\s]*)

Trigger Type: regex
Trigger: \A-poll\s?(c(reate)?|start|begin|make)

Requirement: disable default poll command in Command overrides
Requirements: pollDelete.cc.lua
	      pollReaction.cc.lua
  (optional)  pollList.cc.lus

Note: You cant use both -single and -multiple flags at once
Note: using more then 6 or so unicode emojis in your title will preak it.
Note: Single mode does not work do to a bug on PAGSTDB and YAGPDB
		
Allows: PAGSTDB and YAGPDB, only tested on PAGSTDB
*/}}


{{/*CONFIGURATION VALUES STARTS*/}}
{{ $type := "single" }} {{/*<sultipule/single>, default poll setting*/}}
{{ $nums := cslice "1️⃣" "2️⃣" "3️⃣" "4️⃣" "5️⃣" "6️⃣" "7️⃣" "8️⃣" "9️⃣" }} {{/*emojis used for polls, at least 2*/}}
{{/*CONFIGURATION VALUES ENDS*/}}
 
{{/*Getting choices*/}}
{{ $items := cslice }}
{{ range reFindAll `("[^"]*")|([^"\s]*)` .StrippedMsg }}
	{{ $items = $items.Append (reReplace "\"" . "") }}
{{ end }}
 
{{/*Type of poll*/}}
{{ if (reFind `-s(ingle)?\s?$` $.StrippedMsg) }}
	{{ $type = "single" }}
{{ else if (reFind `-m(ultiple)?\s?$` $.StrippedMsg) }}
	{{ $type = "multiple" }}
{{ end }}
 
{{/*making the display and title*/}}
{{ $title := 0 }} {{ $display := "" }} {{ $emojis := cslice }}
{{ range $index, $value := $items }}
	{{ if not $title }}
		{{ $title = $value }}
{{ else if and (le $index (len $nums)) (not (reFind `^(-m(ultiple)?|-s(ingle)?)\s?` $value)) }}
		{{ $emoji := index $nums (sub $index 2) }}
		{{ $display = print $display "\n" $emoji " **›** " $value }}
		{{ $emojis = $emojis.Append $emoji }}
	{{ end }}
{{ end }}
 
{{/*Sending the poll*/}}
{{ $poll := sdict 
  "Title" (toString $title)
	"Description" $display
	"Color" 0x4B0082
	"Timestamp" currentTime
	"Footer" (sdict "icon_url" (.User.AvatarURL "256") "text" .User.String)
}}
 
{{/* adding the reactions */}}
{{- if and (ge (len .CmdArgs) 3) (reFind `^[^\|_%]{1,100}$` (toString $title)) -}}
	{{ $id := sendMessageRetID nil (cembed $poll) }}
	{{ range $_, $value := $emojis }}
		{{ addMessageReactions nil $id $value }}
	{{ end }}
 
{{/*Saving the poll*/}}
	{{- dbSet 0 (print "poll|" .Channel.ID "|" $id "|" $title "|" $type) (cslice) -}}
{{ else }}
Please provide at least three args:
`-poll create <title> <opt1> <opt2>`
> Note: Titles cannot contain `_`, `%`, or `|`.
{{ end }}
                                  
                                                
