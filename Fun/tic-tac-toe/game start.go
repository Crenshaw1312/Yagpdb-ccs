{{/*Made by Crenshaw#7860
Trigger Tpye Regex: ^-(ttt|tic(-|\s)?tac(-|\s)?toe)
I made this from inspiration of Specky Bot and my friend Haley.*/}}
{{$mod:=755559646265081907}}{{/*ROLE that are considered mod*/}}
{{$admin:=755559646265081907}}{{/*ROLE that are considered admin*/}}

{{/*no touching*/}}
{{$Games:=(toString (dbGet 336 (joinStr "" .Channel.ID "ttt")).Value)}}{{/*game info*/}}
{{if ($Games)}}
{{/*End game?*/}}
	{{$Games:=(toString (dbGet 336 (joinStr "" .Channel.ID "ttt")).Value)}}
	{{if or (hasRoleID $admin) (hasRoleID $mod) (reFind (toString .User.ID) $Games)}}
		{{if reFind `(end|stop|close)` (index .CmdArgs 0)}}
			{{dbDel 336  (joinStr "" .Channel.ID "ttt")}}
			{{sendMessage nil "Game Ended, Thanks for playing!"}}
		{{end}}
	{{end}}
{{else}}

	{{$args := parseArgs 1 "You need to ping your challenger!\n`-ttt @user`"
(carg "userid" "player")}}

{{/*Start game?*/}}
	{{if ($Games)}}
{{/*active ttt channel*/}}
	     There is an already active game in this channel, try a different channel.
	{{else if and (not (userArg ($args.Get 0)).Bot) (ne (toString (userArg ($args.Get 0)).ID) (toString .User.ID))}}
{{/*Creating a game*/}}
		{{sendMessage nil (joinStr "" "\n **Player 1:** " (userArg ($args.Get 0)).Mention  " **-** X **Player 2:**" .User.Mention " **-** O")}}
		{{$id:=sendMessageRetID nil (joinStr "" "\n```\n 1 | 2 | 3\n-----------\n 4 | 5 | 6\n-----------\n 7 | 8 | 9\n```\nRemember to do `-ttt end` when the game is over")}}
		{{addMessageReactions nil $id ":one:" ":two:" ":three:" ":four:" ":five:" ":six:" ":seven:" ":eight:" ":nine:"}}
		{{dbSet 336 (joinStr "" .Channel.ID "ttt") (joinStr "" "--" ((userArg ($args.Get 0)).ID) "><" .User.ID "><" $id "><" .Channel.ID "--")}}
		{{dbSet 336 (joinStr "" .Channel.ID "XorO") "X"}}
	{{else if eq (toString (userArg ($args.Get 0)).ID) (toString .User.ID)}}
		You cannot play yourself, go make a new friend to join you!
	{{else if (userArg ($args.Get 0)).Bot}}
		You can't play a bot, that's considered sad.
	{{end}}
{{end}}
