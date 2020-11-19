{{/* this makes a tic tac toe game along with some other features.
Note: Game default lasts 5 minutes, it logs the amount of wins, ties, and game lost. You can also customize your marker to and default emoji.
Note2: To create a tic-tac-toe account for someone else, do `ttt stats [mention]`

Trigger Type: Command
Trigger: ttt

Usage:
`ttt play <mention>` to play a game
`ttt stats [mention]` to get a user's stats, ping no one to geet your own
`ttt reset` completely reset you stats
`ttt marker <1/2> <emoji>` set your marker for when you're player1 or player 2 to something besides X and O
*/}}

{{/* CONFIGURATION VALUES START */}}

{{ $player1Marker := "⭕️" }} {{/* The default emojis to use as markers, players can customize their own though */}}
{{ $player2Marker := "❌" }}
{{ $gameTime := 300 }} {{/* How long a game lasts, in seconds. Currently 5 minutes */}}
{{ $allowReset := true }} {{/*Weather or not if you allow users to completely reset all of their stats*/}}

{{/* CONFIGURATION VALUES END */}}
 
{{ $cmd := "help" }}
{{ if .CmdArgs }}
	{{ $cmd = index .CmdArgs 0 }}
{{ end }}
 
{{/* make player data if not there */}}
{{ if not (dbGet .User.ID "tictactoe").Value }}
	{{ dbSet .User.ID "tictactoe" (sdict "Marker1" $player1Marker "Marker2" $player2Marker "Won" "0" "Tied" "0" "Lost" "0") }}
{{ end }}
 
 
{{/* stats */}}
{{ if eq $cmd "stats" }}
	{{ $stats := sdict
		"Thumbnail" (sdict "url" "https://cdn.discordapp.com/attachments/769320349078650932/776922976557465620/how-to-build-simple-tic-tac-toe-game-with-react-blog.webp")
		"Fields" (cslice
			(sdict "Name" "Won" "Value" "0" "Inline" true)
			(sdict "Name" "Tied" "Value" "0" "Inline" true)
			(sdict "Name" "Lost" "Value" "0" "Inline" true)
			(sdict "Name" "Marker 1" "Value" "0" "Inline" true)
			(sdict "Name" "Marker 2" "Value" "0" "Inline" true)
		)
		"Footer" (sdict "icon_url" (.User.AvatarURL "256") "text" (print "Requested by " .User.String))
		"Color" 0x4B0082
	}}
	{{ $member := .Member }}
	{{ if eq (len .CmdArgs) 2 }}
		{{ $member = getMember (index .CmdArgs 1) }}
	{{ end }}
	{{ $stats.Set "Title" (print "Stats - " $member.User.Username) }}
	{{ if not (dbGet $member.User.ID "tictactoe").Value }}
		{{ dbSet $member.User.ID "tictactoe" (sdict "Marker1" $player1Marker "Marker2" $player2Marker "Won" "0" "Tied" "0" "Lost" "0") }}
	{{ end }}
	{{ if (dbGet $member.User.ID "tictactoe").Value }}
		{{ $data := sdict (dbGet $member.User.ID "tictactoe").Value }}
		{{ range $index, $value := (cslice "Won" "Tied" "Lost" "Marker1" "Marker2") }}
			{{ (index $stats.Fields $index).Set "Value" (print "`" ($data.Get $value) "`") }}
		{{ end }}
	{{ end }}
	{{ sendMessage nil (cembed $stats) }}
 
{{/* reset */}}
{{ else if eq $cmd "reset" }}
	{{ if $allowReset }}
		{{ dbSet .User.ID "tictactoe" (sdict "Marker1" $player1Marker "Marker2" $player2Marker "Won" "0" "Tied" "0" "Lost" "0") }}
		Reset your stats, do `+ttt stats` to see.
	{{ else }}
		This is disabled, contact an admin to have `+ttt reset` enabled.
	{{ end }}
 
{{/*set marker*/}}
{{ else if and (eq 3 (len .CmdArgs)) (eq $cmd "setmarker" "sm") }}
	{{ if and (eq (index .CmdArgs 1) "1" "2") (reFind `\p{So}|.\x{20e3}` (index .CmdArgs 2)) }}
		{{ if (dbGet .User.ID "tictactoe").Value }}
			{{- $marker := print "Marker" (index .CmdArgs 1) -}}
			{{ $emoji := (index .CmdArgs 2) }}
			{{ $data := sdict (dbGet .User.ID "tictactoe").Value }}
			{{ $data.Set $marker $emoji }}
			{{ dbSet .User.ID "tictactoe" $data }}
			Marker {{index .CmdArgs 1}} has been set to `{{$emoji}}`.
		{{ end }}
	{{ end }}
 
{{/* actually playing a game */}}
{{ else if eq $cmd "play" }}
	{{ $args := parseArgs 2 "Please ping a member to play" (carg "string" "play") (carg "member" "player2") }}
	{{ $member :=  $args.Get 1 }}
	{{ $player1 := sdict "ID" .User.ID "Plays" (cslice) }}
	{{ $player2 := sdict "ID" $member.User.ID "Plays" (cslice) }}
	{{ if (ne $player2.ID $player1.ID) }}
		{{ range $index, $value :=(cslice $player1 $player2) }}
			{{ $value.Set "Marker" ((sdict (dbGet $value.ID "tictactoe").Value).Get (print "Marker" (add $index 1))) }}
		{{ end }}
		{{ $gameID := sendMessageRetID nil (cembed
			"title" "Tic-Tac-Toe!"
			"description" "```\n1️⃣|2️⃣|3️⃣\n---------\n4️⃣|5️⃣|6️⃣\n---------\n7️⃣|8️⃣|9️⃣\n```"
			"Footer" (sdict "icon_url" ($member.User.AvatarURL "256") "text" (print $member.User.Username "'s turn"))
		) }}
		{{ $data := sdict "Player1" $player1 "Player2" $player2 "Turn" "player2" "Available" (cslice "1️⃣" "2️⃣" "3️⃣" "4️⃣" "5️⃣" "6️⃣" "7️⃣" "8️⃣" "9️⃣") }}
		{{ addMessageReactions nil $gameID "1️⃣" "2️⃣" "3️⃣" "4️⃣" "5️⃣" "6️⃣" "7️⃣" "8️⃣" "9️⃣" }}
		{{ dbSetExpire $gameID "tictactoe" $data $gameTime }}
	{{ end }}
	
{{/* help message */}}
{{ else }}
	{{ sendMessage nil (cembed
		"Title" "Tic-Tac-Toe"
		"Thumbnail" (sdict "url" "https://cdn.discordapp.com/attachments/769320349078650932/776922976557465620/how-to-build-simple-tic-tac-toe-game-with-react-blog.webp")
		"Description" (joinStr "\n\n"
			"`ttt stats [member]` Get a user's stats."
			"`ttt setMarker <1/2> <standard emoji>` Set your marker to something besides :x: or :o:."
			"`ttt play <mention>` Play tic-tac-toe with someone!"
			"`ttt reset` Reset all of your stats, marker(s) and play score(s)."
		)
		"Footer" (sdict "icon_url" (.User.AvatarURL "256") "text" (print "Requested by " .User.String))
		"Color" 0x4B0082
		
	) }}
{{ end }}
