{{/*
Made by: Crenshaw#1312

Trigger Type: regex
Trigger: \A-poll\s?(list|all|view|s(ee)?)

Note: poll list [page number]

Requirements: pollCreate.cc.lua
              pollDelete.cc.lua
              pollReaction.cc.lua
*/}}

{{ $page := reFind `\d+` .StrippedMsg }}
{{ if $page }}
{{ $page = sub $page 1 }}
{{ end }}

{{ $polls := dbTopEntries "poll|%%|%%|%%|%%" 10 (mult $page 10) }} {{ $display := "" }}
{{ range $i, $v := $polls }}
{{ $_ := split (slice .Key 5) "|" }}
	{{ $chanID := toInt (index $_ 0) }} {{ $msgID := toInt (index $_ 1) }} {{ $title := index $_ 2 }} {{ $type := index $_ 3 }}
	{{ $link := print "https://discord.com/channels/" $.Guild.ID "/" $chanID "/" $msgID }}
	{{ $base := print "```\nTitle: " $title "\nType: " $type "\nChannel: <#" $chanID ">\nMessage ID: " $msgID "\n```**[Message Link](" $link ")**" }}
	{{ $display = print $display "\n\n" $base }}
{{ end }}


{{ $e := sdict
	"Title" "Current Polls"
    	"Description" (or $display "```\nNo Polls Found\n```")
	"Color" 0x4B0082
  	"Footer" (sdict "Text" (print "Page " (or $page 1) ))
}}
{{ $e.Set "Description" (print $e.Description "\n\n`page list [page num]`") }}
{{ sendMessage nil (cembed $e) }}
