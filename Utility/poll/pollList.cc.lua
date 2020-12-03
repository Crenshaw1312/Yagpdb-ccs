{{/*
Made by: Crenshaw#1312

Trigger Type: regex
Trigger: \A-poll\s?(list|all|view|s(ee)?)

Note: this will most certainly be updated.

Requirements: pollCreate.cc.lua
              pollDelete.cc.lua
              pollReaction.cc.lua
*/}}

{{ $polls := dbTopEntries "poll|%|%" 10 0 }} {{ $display := "```\nNo Polls Found" }}
{{ range $i, $v := $polls }}
	{{ $_ := split (slice .Key 5) "|" }} {{ $title := index $_ 1 }} {{ $msgID := toInt (index $_ 0) }} {{ $base := print "Title: " $title "\nMessage ID: " $msgID }}
	{{ if eq $i 0 }} {{/*First line*/}}
		{{ $display = print "```\n" $base }}
	{{ else }} {{/*middle line(s)*/}}
		{{ $display = print $display "\n\n" $base }}
	{{ end }}
{{ end }}
 
{{ $e := sdict
"Title" "Current Polls"
"Description" (print $display "\n```")
"Color" 0x4B0082
}}
{{ sendMessage nil (cembed $e) }}
