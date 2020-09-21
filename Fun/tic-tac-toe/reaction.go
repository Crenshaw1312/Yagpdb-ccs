{{/*Made by Crenshaw#7860
Trigger Tpye Regex: ^-(ttt|tic(-|\s)?tac(-|\s)?toe)
I made this from inspiration of Specky Bot and my friend Haley.*/}}

{{$ccID:=12}}{{/*replace this with the ccID of the conversion-tt command*/}}
{{/*database of all the games*/}}
{{$Games:=(toString (dbGet 336 (joinStr "" .Channel.ID "ttt")).Value)}}
{{$Games:=(split $Games "----")|(reReplace "--" $Games "")}}
 
{{if and (reFind (toString .ReactionMessage.ID) $Games) (reFind (toString .Reaction.UserID) $Games) (eq (toString .ReactionMessage.Author) "YAGPDB.xyz#8760")}}
	{{$Games:=split $Games "><"}}
	{{/*Variables*/}}
	{{$p1:=(index $Games 0)}}
	{{$p2:=(index $Games 1)}}
	{{$msgID:=(index $Games 2)}}
	{{$chan:=(index $Games 3)}}
	{{$user:=.User.ID}}
	{{$message:= .ReactionMessage.Content}}
	{{range .ReactionMessage.Reactions}}
		{{if eq .Count 2}}
{{/*setting up emoji information*/}}
			{{$letnum:=reReplace ":" .Emoji.Name ""}}
			{{execCC $ccID nil 0 $letnum}}
			{{sleep 1}}
			{{$number:=(dbGet 0 "letnum").Value}}
{{/*Replacing number with emoji*/}}
			{{if eq (toString $user) $p1}}
				{{if eq (toString (dbGet 336 (joinStr "" $chan "XorO")).Value) "X"}}
					{{editMessage nil $msgID (reReplace $number $message "X")}}
					{{dbSet 336 (joinStr "" $chan "XorO") "O"}}
					{{deleteMessageReaction nil $msgID  204255221017214977 .Emoji.Name}}
				{{end}}
			{{deleteMessageReaction nil $msgID  $user .Emoji.Name}}
			{{else if eq (toString $user) $p2}}
				{{if eq (toString (dbGet 336 (joinStr "" $chan "XorO")).Value) "O"}}
					{{editMessage nil $msgID (reReplace $number $message "O")}}
					{{dbSet 336 (joinStr "" $chan "XorO") "X"}}
					{{deleteMessageReaction nil $msgID  204255221017214977 .Emoji.Name}}
				{{end}}
			{{end}}
		{{end}}
		{{deleteMessageReaction nil $msgID  $user .Emoji.Name}}
	{{end}}
{{end}}
