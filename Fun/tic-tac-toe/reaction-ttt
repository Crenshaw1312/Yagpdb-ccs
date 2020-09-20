{{/*Made by Crenshaw#7860
Trigger Tpye Regex: ^-(ttt|tic(-|\s)?tac(-|\s)?toe)
I made this from inspiration of Specky Bot and my friend Haley.*/}}

{{$Games:=(toString (dbGet 336 (joinStr "" .Channel.ID "ttt")).Value)}}{{/*game info*/}}
{{if ($Games)}}
	{{if .CmdArgs}}
{{/*End game?*/}}
		{{$Games:=(toString (dbGet 336 (joinStr "" .Channel.ID "ttt")).Value)}}
		{{if reFind (toString .User.ID) $Games}}
			{{if reFind `(end|stop|close)` (index .CmdArgs 0)}}
				{{dbDel 336  (joinStr "" .Channel.ID "ttt")}}
				{{sendMessage nil "Game Ended, Thanks for playing!"}}
			{{end}}
		{{end}}
	{{end}}
{{else}}

	{{$args := parseArgs 1 "You need to ping your challenger!\n`-ttt @user`"
(carg "userid" "player")}}

{{/*Start game?*/}}
	{{if ($Games)}}
{{/*active ttt channel*/}}
	     There is an already active game in this channel, try a different channel.
	{{else if and (not (userArg ($args.Get 0)).Bot) (ne (toString .User.ID) (toString (userArg ($args.Get 0)).ID))}}
{{/*Creating a game*/}}
		{{$id:=sendMessageRetID nil (joinStr "" "\n" (userArg ($args.Get 0)).Mention  " **-** X\n" .User.Mention " **-** O\n```\n 1 | 2 | 3\n-----------\n 4 | 5 | 6\n-----------\n 7 | 8 | 9 \n```\n" (userArg ($args.Get 0)).Username " Plays first\nRemember to do `-ttt end` when the game is over")}}
		{{addMessageReactions nil $id ":one:" ":two:" ":three:" ":four:" ":five:" ":six:" ":seven:" ":eight:" ":nine:"}}
		{{dbSet 336 (joinStr "" .Channel.ID "ttt") (joinStr "" "--" ((userArg ($args.Get 0)).ID) "><" .User.ID "><" $id "><" .Channel.ID "--")}}
		{{dbSet 336 (joinStr "" .Channel.ID "XorO") "X"}}
	{{else if (userArg ($args.Get 0)).Bot}}
		Do you have like no friends? Go make some
	{{else if eq (toString .User.ID) (toString (userArg ($args.Get 0)).ID)}}
		Just no... no, playing by yourself is depressing. Go make some friends.
	{{end}}
{{end}}
