{{/*
Made by: Crenshaw#1312

Trigger Type: regex
Trigger: \A-poll\s?(list|all|view|s(ee)?)

Note: this will most certainly be updated.

Requirements: pollCreate.cc.lua
              pollDelete.cc.lua
              pollReaction.cc.lua
*/}}

{{ $polls := dbTopEntries "poll|%%|%%|%%|%%" 10 0 }} {{ $display := "" }}
{{ range $i, $v := $polls }}
{{ $_ := split (slice .Key 5) "|" }}
	{{ $chanID := toInt (index $_ 0) }} {{ $msgID := toInt (index $_ 1) }} {{ $title := index $_ 2 }} {{ $type := index $_ 3 }}
	{{ $link := print "https://discord.com/channels/" $.Guild.ID "/" $chanID "/" $msgID }}
	{{ $base := print "`Title: " $title "\nType: " $type "\nMessage ID: `[" $msgID "](" $link ")" }}
	{{ $display = print $display "\n\n" $base }}
{{ end }}

{{ $e := sdict
"Title" "Current Polls"
"Description" $display
"Color" 0x4B0082
}}
{{ sendMessage nil (cembed $e) }}
