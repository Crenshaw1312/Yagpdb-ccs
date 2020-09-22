{{$number:=sdict "emoji" 0}} {{$index:=1}} {{$item:=0}}
{{$number.Set "emoji" (cslice "1️⃣" "2️⃣" "3️⃣" "4️⃣" "5️⃣" "6️⃣" "7️⃣" "8️⃣" "9️⃣")}}
{{range $index, $item:=$number.emoji}}
	{{range $.ReactionMessage.Reactions}}
		{{if eq $item (toString  .Emoji.Name)}}
			{{$number =toString (add $index 1)}}{{$index}}
		{{end}}
	{{end}}
{{end}}
