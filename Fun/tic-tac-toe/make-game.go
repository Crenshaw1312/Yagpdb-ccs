{{/*Made by Crenshaw#7860
Trigger Tpye Regex: ^-(ttt|tic(-|\s)?tac(-|\s)?toe)
I made this from inspiration of Specky Bot and my friend Haley.*/}}

{{$Games:=(toString (dbGet 336 (joinStr "" .Channel.ID "ttt")).Value)}}{{/*game info*/}}
{{if ($Games)}}
{{/*End game?*/}}
	{{$Games:=(toString (dbGet 336 (joinStr "" .Channel.ID "ttt")).Value)}}
	{{$Games:=(split $Games "----")|(reReplace "--" $Games "")}}
	{{$Games:=split $Games "><"}}
	{{$p1:=(index $Games 0)}}
	{{$p2:=(index $Games 1)}}
	{{if eq (toString .User.ID) $p1 $p2}}
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
	{{else}}
	{{/*Creating a game*/}}
		{{$id:=sendMessageRetID nil (joinStr "" "\n **Player 1:** " (userArg ($args.Get 0)).Mention  " **-** X **Player 2:**" .User.Mention " **-** O\n```\n 1 | 2 | 3\n-----------\n 4 | 5 | 6\n-----------\n 7 | 8 | 9 \n```\nRemember to do `-ttt end` when the game is over")}}
		{{addMessageReactions nil $id ":one:" ":two:" ":three:" ":four:" ":five:" ":six:" ":seven:" ":eight:" ":nine:"}}
		{{dbSet 336 (joinStr "" .Channel.ID "ttt") (joinStr "" "--" ((userArg ($args.Get 0)).ID) "><" .User.ID "><" $id "><" .Channel.ID "--")}}
		{{dbSet 336 (joinStr "" .Channel.ID "XorO") "X"}}
	{{end}}
{{end}}
