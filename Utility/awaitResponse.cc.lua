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

{{/* configuration area */}}
{{$trigger:=`-start`}} {{/* the trigger is set to -trigger, basic regex knowledge is required to edit this */}}
{{$timer:=15}} {{/* 60s timer, if timer ends with no response, the command is automatically disabled */}}

{{/* DO NOT EDIT BELOW (unless you want to learn how it works or know what you're doing c: ) */}}
{{$databaseValue:=toInt (dbGet .User.ID "waitResponse").Value}}
{{$dontChangeStage:=0}}
{{$changeStage:=0}}
{{$colour:=0x4B0082}}
{{$position:=0}}

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
{{$embed:=sdict "author" (sdict "icon_url" (.User.AvatarURL "256") "name" (print "User: " .User.String)) "footer" (sdict "text" "Type cancel to cancel the tutorial.") "color" $colour}}

{{/* checks if it was executed by scheduleUniqueCC */}}
{{if .ExecData}}
	{{$embed.Set "title" "Timed Out!"}}
	{{$embed.Set "description" (print "You have not entered a response after " $timer " seconds. As such, the commmand has been cancelled.")}}
	{{sendMessage nil (cembed $embed)}}
{{else}}

	{{/* if no database */}}
	{{if not $databaseValue}}
		{{if reFind (print `\A(?i)` $trigger `(\s+|\z)`) .Message.Content}}
			{{$embed.Set "title" "Your Elevation"}}
			{{$embed.Set "description" "Enter you altitude"}}
			{{dbSetExpire .User.ID "responses" (cslice) $timer }}
			{{$changeStage =1}}
			{{scheduleUniqueCC .CCID nil $timer "cancelled" 1}}
		{{end}}
	{{/* if $databaseValue has a value */}}
	{{else}}
{{/* Getting responses*/}}
		{{$responses:=(cslice).AppendSlice (dbGet .User.ID "responses").Value}}

		{{if eq $databaseValue 1}}
			{{with toInt .Message.Content}}
				{{if gt . 0}}
					{{$embed.Set "title" "Airport Elevation"}}
					{{$embed.Set "description" "**Elevation** of the airport (from sea level)"}}
					{{ dbSetExpire $.User.ID "responses" ($responses.Append $.Message.Content) $timer }}
					{{$changeStage =1}}
				{{else}}
					{{template "err"}} {{$changeStage =0}}
				{{end}}
			{{else}}
				{{template "err"}} {{$changeStage =0}}
			{{end}}
			{{scheduleUniqueCC .CCID nil $timer "cancelled" 1}}

		{{else if eq $databaseValue 2}}
			{{with toInt .Message.Content}}
				{{if gt . 0 }}
					{{$embed.Set "title" "Tail Wind"}}
					{{$embed.Set "description" "Enter **true** or **false** if you have tail wind"}}
					{{ dbSetExpire $.User.ID "responses" ($responses.Append $.Message.Content) $timer }}
					{{$changeStage =1}}
				{{else}}
					{{template "err"}} {{$changeStage =0}}
				{{end}}
			{{else}}
				{{template "err"}} {{$changeStage =0}}
			{{end}}
			{{scheduleUniqueCC .CCID nil $timer "cancelled" 1}}

		{{else if eq $databaseValue 3}}
			{{if eq (lower (toString .Message.Content)) "true" "false"}}
				{{$embed.Set "title" "Done"}}
				{{$embed.Set "description" "Enter **finished** or **done**"}}
				{{ dbSetExpire $.User.ID "responses" ($responses.Append $.Message.Content) $timer }}
				{{$changeStage =1}}
			{{else}}
				{{template "err"}} {{$changeStage =0}}
			{{end}}
			{{scheduleUniqueCC .CCID nil $timer "cancelled" 1}}

		{{else if eq $databaseValue 4}}
			{{if eq (lower .Message.Content) "finish" "finished" "done" "enter" }}
				{{$embed.Set "title" "Calculation Finished!"}}
				{{$embed.Set "description" (json $responses) }}
				{{dbDel .User.ID "waitResponse"}}
			{{else}}
				{{template "err"}}
			{{end}}
			{{$changeStage =0}}
			{{cancelScheduledUniqueCC .CCID "cancelled"}}
		{{end}}

		{{/* checks if user inputted cancel */}}
		{{if eq (lower .Message.Content) "cancel" "stop" "end" "quit"}}
			{{$embed.Set "title" "Calculation was Cancelled"}}
			{{$embed.Set "description" (print (or .Member.Nick .User.Username) "#" .User.Discriminator " has decided to cancel the tutorial.")}}
			{{dbDel .User.ID "waitResponse"}}
			{{$changeStage =0}}
			{{cancelScheduledUniqueCC .CCID "cancelled"}}
		{{end}}
	{{end}}
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
