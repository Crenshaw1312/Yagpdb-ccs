{{/*
Trigger ttype: Reaction
Trigger: reaction added only
*/}}

{{ define "findWin" }}
	{{ $wins := cslice "1️⃣-2️⃣-3️⃣" "4️⃣-5️⃣-6️⃣" "7️⃣-8️⃣-9️⃣" "1️⃣-4️⃣-7️⃣" "2️⃣-5️⃣-8️⃣" "7️⃣-5️⃣-3️⃣" "3️⃣-6️⃣-9️⃣" "1️⃣-5️⃣-9️⃣" }}
	{{ $.Set "Result" false }}
	{{ range $wins }}
		{{ $x := index (split . "-") 0 }} {{ $y := index (split . "-") 1 }} {{ $z := index (split . "-") 2 }}
		{{ if and (in $.Player.Plays $x) (in $.Player.Plays $y) (in $.Player.Plays $z) }}
			{{ $.Set "Result" true }}
			{{ $.Set "WinLine" (cslice $x $y $z) }}
		{{ end }}
	{{ end }}
{{ end }}
 
{{ if (dbGet .ReactionMessage.ID "tictactoe").Value }}
 
{{/* setting up variables */}}
	{{ $data:=sdict (dbGet .ReactionMessage.ID "tictactoe").Value }}
	{{ $data.Set "Available" ((cslice).AppendSlice $data.Available) }}
	{{ $embed := structToSdict (index .ReactionMessage.Embeds 0) }}
	{{ $player := false }} {{ $opponent := false}}
 
{{/* finder what player the current user is and setting up opponent*/}}
	{{ if and (eq (toInt $data.Player1.ID) .User.ID) (eq $data.Turn "player1") }}
		{{ $player = sdict $data.Player1}}
		{{ $player.Set "Plays" ((cslice).AppendSlice $player.Plays) }} {{ $data.Set "Turn" "player2" }} {{ $data.Set "Player1" $player }}
		{{$opponent = $data.Player2.ID }}{{ $opponent = (getMember $opponent).User }}
	{{ else if and (eq (toInt $data.Player2.ID) .User.ID) (eq $data.Turn "player2") }}
		{{ $player = sdict $data.Player2}}
		{{ $player.Set "Plays" ((cslice).AppendSlice $player.Plays) }} {{ $data.Set "Turn" "player1" }} {{ $data.Set "Player2" $player }}
		{{ $opponent = $data.Player1.ID }}{{ $opponent = (getMember $opponent).User }}
	{{ else }}
		{{ deleteMessageReaction nil .ReactionMessage.ID .User.ID .Reaction.Emoji.Name }}
	{{ end }}
 
{{/* updating board*/}}
	{{ if and $player (eq .Reaction.Emoji.Name "1️⃣" "2️⃣" "3️⃣" "4️⃣" "5️⃣" "6️⃣" "7️⃣" "8️⃣" "9️⃣")}}
		{{ deleteMessageReaction nil .ReactionMessage.ID .User.ID .Reaction.Emoji.Name }}
		{{ deleteMessageReaction nil .ReactionMessage.ID 624608566426468373 .Reaction.Emoji.Name }}
		{{ $embed.Set "Description" (reReplace .Reaction.Emoji.Name $embed.Description $player.Marker) }}
		{{ $embed.Set "Footer" (sdict "text" (print $opponent.Username "'s turn") "icon_url" ($opponent.AvatarURL "256")) }}
		{{ editMessage nil .ReactionMessage.ID (cembed $embed) }}
 
{{/*updating plays*/}}
		{{ $available := cslice }}
		{{ range $data.Available }}
			{{ if ne . $.Reaction.Emoji.Name }}
				{{ $available = $available.Append .}}
			{{ else if eq  . $.Reaction.Emoji.Name }}
				{{ $player.Set "Plays" (($player.Plays).Append .) }}
			{{ end }}
		{{ end }}
		{{ $data.Set "Available" $available }}
		{{ if eq .User.ID (toInt $data.Player1.ID) }} 
			{{ $data.Player1.Set "Plays" $player.Plays }} 
		{{ else if eq .User.ID (toInt $data.Player2.ID) }}
			{{ $data.Player2.Set "Plays" $player.Plays }}
		{{ end }}
		{{ $findWin := (sdict "Player" $player)}}
		{{ template "findWin" $findWin }}
 
{{/* Try to find a win/Tie */}}
		{{ if $findWin.Result }}
			{{ $embed.Del "Description" }} {{ $embed.Del "Title" }} {{ $embed.Set "Footer" (sdict "text" (print .User.Username " Won!") "icon_url" (.User.AvatarURL "256")) }}
			{{ deleteAllMessageReactions nil .ReactionMessage.ID }}
			{{ editMessage nil .ReactionMessage.ID (cembed $embed) }}
			{{ dbDel .ReactionMessage.ID "tictactoe" }}
			{{ $stats := sdict (dbGet .User.ID "tictactoe").Value }} {{ $stats.Set "Won" (add (toInt $stats.Wins) 1) }} {{ dbSet .User.ID "tictactoe" $stats }}
			{{ $stats := sdict (dbGet $opponent.ID "tictactoe").Value }} {{ $stats.Set "Lost" (add (toInt $stats.Lost) 1) }} {{ dbSet $opponent.ID "tictactoe" $stats }}
		{{ else if or (eq (len $data.Available) 0) (eq (len .ReactionMessage.Reactions) 0) }}
			{{ $embed.Del "Description" }} {{ $embed.Del "Title" }} {{ $embed.Set "Footer" (sdict "text" "Tie!") }}
			{{ editMessage nil .ReactionMessage.ID (cembed $embed) }}
			{{ dbDel .ReactionMessage.ID "tictactoe" }}
			{{ range (cslice .User $opponent) }}
				{{ $stats := sdict (dbGet .ID "tictactoe").Value }} {{ $stats.Set "Tied" (add (toInt $stats.Tied) 1) }} {{ dbSet .ID "tictactoe" $stats }}
			{{ end }}
		{{ else }}
			{{ dbSetExpire .ReactionMessage.ID "tictactoe" $data (toInt64  ((dbGet .Channel.ID "tictactoe").ExpiresAt.Sub currentTime).Seconds) }}
		{{ end }}
	{{ end }}
{{ else if and (dbGet .ReactionMessage.ID "tictactoe").Value (not (eq .Reaction.Emoji.Name "1️⃣" "2️⃣" "3️⃣" "4️⃣" "5️⃣" "6️⃣" "7️⃣" "8️⃣" "9️⃣")) }}
	{{ deleteMessageReaction nil .ReactionMessage.ID .Reaction }}
{{ end }}
