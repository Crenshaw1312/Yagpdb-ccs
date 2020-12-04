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
{{ $logPoll := 778312013918371851 }} {{/*channel to send poll resaults to, .Channel.ID or nil for channel where command is triggered*/}}
{{/*CONFIGURATION VALUES END*/}}

{{ if and (reFind `^<#\d{18}>$` (index .CmdArgs 0)) (ge (len .CmdArgs) 2) }}
	{{ $title := "%%" }} {{ $msgID := "%%" }} {{ $chanID := "%%" }}
		{{ $chanID = index .CmdArgs 0 }}
		{{ if reFind `^\d{18}$` (index .CmdArgs 1) }}
			{{ $msgID = index .CmdArgs 1 }}
		{{ else }}
			{{ $title = joinStr " " (slice .CmdArgs 1) }}
		{{ end }}

{{/* getting the poll */}}
	{{ $res := dbTopEntries (print "poll|%%|" $msgID "|" $title "|%%") 1 0 }}
	{{ if eq (len $res) 1 }} {{$counter := 0}}{{$percents := 0}}
		{{ $res = (index $res 0)}}
		{{ dbDel $res.UserID $res.Key }}
		{{ $_ := split (slice $res.Key 5) "|" }}
		{{ $chanID := toInt (index $_ 0) }} {{ $msgID := toInt (index $_ 1) }} {{ $title := index $_ 2 }} {{ $type := index $_ 3 }} {{ $display := "" }}
		{{ $poll := getMessage $chanID $msgID }}
		{{- range $poll.Reactions -}}
			{{$counter = add $counter (sub .Count 1)}}
		{{- end -}}
		{{ $items := (split (index $poll.Embeds 0).Description "\n") }}
		{{ range $index, $value := $poll.Reactions }}
			{{$percents = printf "%.0f%%" (round (fdiv (sub $value.Count 1) $counter|mult 100.0))}}
			{{ $display = print $display "\n" (index $items $index) "** ›› **`" (sub $value.Count 1) " (" $percents ")`" }}
		{{ end }}
		{{ if $delPoll }}
			{{ deleteMessage $chanID $msgID 0 }}
		{{ end }}
		{{ sendMessage $logPoll (cembed 
			"Title" (print "Resaults for " $title)
            "Description" $display
			"Color" 0x4B0083
            "Timestamp" $poll.Timestamp
			"Footer" (sdict "text" (print "Poll was made") )
		) }}
		{{ sendMessage nil "Done :thumbsup:" }}
{{/* no resaults */}}
	{{ else }}
		No polls found with that search, try using the message ID instead.
	{{ end }}

{{/*error message*/}}
{{ else }}
Please provide the __name__ or __message ID__ of the poll you want to end.
example: `-poll end <channel mention> <message ID/title>`
{{ end }}
