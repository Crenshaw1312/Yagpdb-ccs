{{/*
Made by: Crenshaw1312

Trigger Type: Regex
Trigger: \A-poll\s?(end|stop|results)
 
Requirements: pollCreate.cc.lua
              pollReaction.cc.lua
   (optional) pollList.cc.lua
   
Note: you can delete by the poll title/name or message ID
Note: must be run in same channel as poll
   
Allows: YAGPRB and PAGSTDB
*/}}
 
{{/*CONFIGURATION VALUES START*/}}
{{ $delPoll := false }} {{/*weather or not to delete the poll once you end it*/}}
{{/*CONFIGURATION VALUES END*/}}
 
{{ if ge (len .CmdArgs) 1 }}
	{{ $byTitle := true }} {{ $title := "%%" }} {{ $msgID := "%%" }}
	{{ if reFind `^\d{18}$` (index .CmdArgs 0) }}
		{{ $byTitle = false }}
		{{ $msgID = index .CmdArgs 0 }}
	{{ else }}
		{{ $title = joinStr " " .CmdArgs }}
	{{ end }}
 
{{/* getting the poll */}}
	{{ $res := dbTopEntries (print "poll|" $msgID "|" $title) 1 0 }}
	{{ if eq (len $res) 1 }}
		{{ $res = (index $res 0)}}
		{{ dbDel $res.UserID $res.Key }}
		{{ $_ := split (slice $res.Key 5) "|" }}
		{{ $title = index $_ 1 }} {{ $msgID = index $_ 0 }} {{ $display := "" }}
		{{ $poll := getMessage nil $msgID }}
		{{ $items := (split (index $poll.Embeds 0).Description "\n") }}
		{{ range $index, $value := $poll.Reactions }}
			{{ $display = print $display "\n" (index $items $index) "** ›› **`Count: " (sub $value.Count 1) "`" }}
		{{ end }}
		{{ if $delPoll }}
			{{ deleteMessage nil $msgID 0 }}
		{{ end }}
		{{ sendMessage nil (cembed 
			"Title" (print "Resaults for " $title)
            "Description" $display
			"Color" 0x4B0083
            "Timestamp" $poll.Timestamp
			"Footer" (sdict "text" (print "Poll was made on") )
		) }}
{{/* no resaults */}}
	{{ else }}
		No polls found with that search, try using the message ID instead.
	{{ end }}
 
{{/*error message*/}}
{{ else }}
Please provide the __name__ or __message ID__ of the poll you want to end.
{{ end }}
