{{/*
Made by: Crenshaw#1312

Trigger Type: Regex
Trigger: .*

Note: ONLY ALLOW THIS TO RUN IN ONE CHANNEL (this should be your suggestion chanel)
Note: Allow people to type in your suggestion channel
Note: You can change your upvote/downvote in line 46 (on Github)
*/}}

{{/* CONFIGURATION VAlUES START*/}}
{{ $color := 0x4B0082 }} {{/* 0x(Hex code)*/}}
{{ $autoDel := 300 }} {{/* delete suggestions after X seconds, 0 to dissable*/}}
{{/* CONFIGURATION VALUES END*/}}

{{ if .ExecData.Key }}
	{{ if (dbGet 0 .ExecData.Key).ExpiresAt }}
		{{ deleteMessage nil .ExecData.ID 0 }}
		{{ dbDel 0 (print "sugs|" .sugCount) }}
	{{ end }}
{{ end }}

{{ if and (not (reFind `\A-s(ug|uggestion)?\s?(del(ete)?|deny|com(ment)?|ap(prove)?|imp(lement)?|q(oute)?)` .Cmd)) (not .ExecData) }}
	{{/* Getting suggestion number*/}}
	{{ $sugCount := 0 }}
	{{ if ($s := (dbGet 0 "sugCount").Value) }}
		{{ $sugCount = add 1 $s }}
		{{ $_ := dbIncr 0 "sugCount" 1}}
	{{ else }}
		{{ dbSet 0 "sugCount" 1 }}
		{{ $sugCount = 1 }}
	{{ end }}

	{{/* Sending embed*/}}
	{{ $sugID := sendMessageRetID nil (cembed
		"Author" (sdict "Icon_URL" (.User.AvatarURL "256") "Name" .User.String)
		"Title" (print "Suggestion #" $sugCount)
		"Description" .Cmd
		"Color" $color
		"Timestamp" currentTime
		"Footer" (sdict "Text" "Suggested")
	) }}

	{{ editMessage nil $sugID .User.Mention }}
	{{ addMessageReactions nil $sugID "✅" "❎" }}

	{{/* autoDel*/}}
	{{ if $autoDel }}
		{{ dbSet 0 (print "sugs|" $sugCount) (toString $sugID) }}
		{{ scheduleUniqueCC .CCID .Channel.ID $autoDel $sugCount (sdict "sugCount" $sugCount "Key" (print "sugs|" $sugCount) "ID" $sugID) }}
	{{ else }}
		{{ dbSet 0 (print "sugs|" $sugCount) (toString $sugID) }}
	{{ end }}

	{{ deleteTrigger 1 }}
{{ end }}
