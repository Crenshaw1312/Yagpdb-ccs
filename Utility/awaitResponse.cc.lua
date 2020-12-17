{{/*
    Made by DZ#6669 (438789314101379072) 
    Modded by Crenshaw#1312
  
    Orignal: https://github.com/DZ-TM/Yagpdb.xyz/blob/master/Commands/ComplexCommands/TutorialWaitResponse/TutorialWaitResponse.go
  
    Trigger Type: RegEx
    Trigger: .*
  
    Note: edit what you want to start the poll below
    Note: Doing this for a Coding4Nitro thing, but the changes I made are kinda cool imo
    Note: This cc is a styling mess, please ignore
  
    Changes:
    Simpler error response (and shortened)
    Slimmed down "blocks"
    Answer/Response logging ($responses)
    More response possibilites to end
  
*/}}

{{/* CONFIGURATION VALUES START*/}}
{{$trigger:=`-start`}} {{/* the trigger is set to -trigger, basic regex knowledge is required to edit this */}}
{{$timer:=30}} {{/* 60s timer, if timer ends with no response, the command is automatically disabled */}}
{{/* QUESTIONS
	regex: regex for the response you want for that question
    title: subject/title of that embed
    description: description
*/}}
{{$q:=cslice
  	(sdict "regex" `\A\d+(\s+|\z)` "title" "Number" "description" "type a number")
  	(sdict "regex" `\A.+(\s+|\z)` "title" "Anything" "description" "type anything")
  	(sdict "regex" `\A(happy|sad)(\s+|\z)` "title" "Anything" "description" "are you happy or sad")
}}
{{/* DO NOT EDIT BELOW (unless you want to learn how it works or know what you're doing c: ) */}}
  
{{$databaseValue:=toInt (dbGet .User.ID "waitResponse").Value}}
{{$dontChangeStage:=0}}
{{$changeStage:=0}}
{{ $responses := 0 }}
{{$colour:=0x4B0082}}
{{$position:=0}}
{{ $q = $q.Append (sdict "regex" `.*` "title" "Responses" "description" "_ _") }}

{{define "err"}}
	{{ $id := sendMessageRetID nil "Incorrect value please try again." }}
	{{ deleteMessage nil $id 3 }}
	{{ deleteTrigger 0 }}
{{end}}

{{/* sets colour to role colour */}}
{{range .Guild.Roles}}
	{{- if and (in $.Member.Roles .ID) .Color (lt $position .Position)}}
		{{- $position =.Position}}{{$colour =.Color}}
	{{- end -}}
{{end}}

{{/* sets default value for $embed */}}
{{$embed:=sdict "author" (sdict "icon_url" (.User.AvatarURL "256") "name" (print "User: " .User.String)) "footer" (sdict "text" "Type cancel to cancel the questionaire.") "color" $colour}}

{{/* checks if it was executed by scheduleUniqueCC */}}
{{if .ExecData}}
	{{$embed.Set "title" "Timed Out!"}}
	{{$embed.Set "description" (print "You have not entered a response after " $timer " seconds. As such, the commmand has been cancelled.")}}
	{{sendMessage nil (cembed $embed)}}
{{else}}

	{{ range $num, $qval := $q }}
{{/* Starting*/}}
		{{ if reFind (print `\A(?i)` $trigger `(\s+|\z)`) $.Message.Content }}
			{{ if and (not $databaseValue) (not $num) }}
				{{ $embed.Set "title" $qval.title }}
				{{ $embed.Set "description" $qval.description }}
				{{ dbSetExpire $.User.ID "responses" (cslice) $timer }}
				{{$changeStage =1}}
			{{ end }}
		{{ else if and $num $databaseValue }}
			{{ $responses = (cslice).AppendSlice (dbGet $.User.ID "responses").Value }}
		{{ end }}

{{/* Cancellation*/}}
		{{ if and (eq (lower $.Message.Content) "cancel" "quit" "stop") $num }}
			{{$embed.Set "title" "Cancelled"}}
			{{$embed.Set "description" (print (or $.Member.Nick $.User.Username) "#" $.User.Discriminator " has decided to cancel the questionaire.")}}
			{{dbDel $.User.ID "waitResponse"}}
			{{$changeStage =0}}
			{{cancelScheduledUniqueCC $.CCID "cancelled"}}

		{{ else if and (eq $num $databaseValue) $num }}
{{/* Normal question*/}}
			{{ if reFind (index $q (sub $num 1)).regex $.Message.Content }}
				{{$embed.Set "title" $qval.title}}
				{{$embed.Set "description" $qval.description}}
				{{ $responses = $responses.Append $.Message.Content }}
				{{ dbSetExpire $.User.ID "responses" $responses $timer }}
				{{$changeStage =1}}
				{{scheduleUniqueCC $.CCID nil $timer "cancelled" 1}}

{{/* ending questionaire*/}}
				{{ if (eq (sub (len $q) 1) $databaseValue)}}
					{{$changeStage =0}}
					{{cancelScheduledUniqueCC $.CCID "cancelled"}}
					{{dbDel $.User.ID "waitResponse"}}
					{{dbDel $.User.ID "responses"}}
					{{ $embed.Set "description" (joinStr "\n" "```\n" $responses.StringSlice "\n```") }}
				{{ end }}
{{/* Error*/}}
			{{ else }}
				{{template "err"}}
				{{$changeStage =0}}
  			{{ end }}
		{{ end }}

	{{ end }}
{{end}}

{{/* used to change stage to next stage, the reason we use dbSetExpire instead of dbIncr is because dbIncr would still have the same expiration date as the old dbSetExpire, we use dbSetExpire to replace that expiration date */}}
{{if $changeStage}}
	{{dbSetExpire .User.ID "waitResponse" (str (add $databaseValue 1)) $timer}}
{{end}}

{{/* sends message if database has value, used to make it not spam chat */}}
{{if or $databaseValue (dbGet .User.ID "waitResponse")}}
	{{ if $embed.description }}
		{{sendMessage nil (cembed $embed)}}
	{{ end }}	
{{end}}
