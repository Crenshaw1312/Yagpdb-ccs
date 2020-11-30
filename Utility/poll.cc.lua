{{/*
Made by: Crenshaw#1312
Thanks: DZ#6669 Reason: Made regex

Trigger Type: command
Trigger: poll

Requirement: disable default poll command in Command overrides

Allows: PAGSTDB and YAGPDB
*/}}

{{/*Getting choices*/}}
{{ $nums := cslice "1️⃣" "2️⃣" "3️⃣" "4️⃣" "5️⃣" "6️⃣" "7️⃣" "8️⃣" "9️⃣" }}
{{ $items := cslice }}
{{ range reFindAll `("[^"]*")|([^"]*)` .StrippedMsg }}
	{{ $items = $items.Append (reReplace "\"" . "") }}
{{ end }}

{{/*making the display and title*/}}
{{ $title := 0 }} {{ $display := "" }} {{ $emojis := cslice }}
{{ range $index, $value := $items }}
	{{ if not $title }}
		{{ $title = $value }}
	{{ else if le $index 9 }}
		{{ $emoji := index $nums (sub $index 1) }}
		{{ $display = print $display "\n" $emoji " **»** " $value }}
		{{ $emojis = $emojis.Append $emoji }}
	{{ end }}
{{ end }}

{{/*Sending the poll*/}}
{{ $poll := sdict 
	"Title" $title
	"Description" $display
	"Color" 0x4B0082
}}
{{ $id := sendMessageRetID nil (cembed $poll) }}
{{ range $index, $value := $emojis }}
	{{ addMessageReactions nil $id $value }}
{{ end }}
