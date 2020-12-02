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
		
Allows: PAGSTDB and YAGPDB
*/}}

{{/*CONFIGURATION VALUES STARTS*/}}
{{ $type := "single" }} {{/*<multipule/single>, default poll setting*/}}
{{ $nums := cslice "1️⃣" "2️⃣" "3️⃣" "4️⃣" "5️⃣" "6️⃣" "7️⃣" "8️⃣" "9️⃣" }} {{/*emojis used for polls, at least 2*/}}
{{/*CONFIGURATION VALUES ENDS*/}}

{{/*Getting choices*/}}
{{ $items := cslice }}
{{ range reFindAll `("[^"]*")|([^"\s]*)` .StrippedMsg }}
	{{ $items = $items.Append (reReplace "\"" . "") }}
{{ end }}

{{/*making the display and title*/}}
{{ $title := 0 }} {{ $display := "" }} {{ $emojis := cslice }}
{{ range $index, $value := $items }}
	{{ if (reFind `^-s(ingle)?$` $.StrippedMsg) }}
		{{ $type = "single" }}
	{{ else if (reFind `^-m(ultiple)?\s?$` $.StrippedMsg) }}
		{{ $type = "multiple" }}
	{{ else if not $title }}
		{{ $title = $value }}
	{{ else if le $index (len $nums) }}
		{{ $emoji := index $nums (sub $index 2) }}
		{{ $display = print $display "\n" $emoji " **›** " $value }}
		{{ $emojis = $emojis.Append $emoji }}
	{{ end }}
{{ end }}

{{/*Sending the poll*/}}
{{ $poll := sdict 
	"Title" $title
	"Description" $display
	"Color" 0x4B0082
}}

{{/* adding the reactions */}}
{{- if and (ge (len .CmdArgs) 3) (reFind `^[^\|_%]{1,25}$` $title) -}}
	{{ $id := sendMessageRetID nil (cembed $poll) }}
	{{ range $_, $value := $emojis }}
		{{ addMessageReactions nil $id $value }}
	{{ end }}

{{/*Saving the poll*/}}
	{{- dbSet 0 (print "poll|" $id "|" $title) (cslice $type) -}}
{{ else }}
Please provide at least three args:
`-poll create <title> <opt1> <opt2>`
> Note: Titles cannot contain `_`, `%`, or `|` and a max of **25** characters.
{{ end }}
