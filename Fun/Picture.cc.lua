{{/*Made by Crenshaw#7860,
	Regex: \A-pic(ture)?(\s(random|id(\s)?(\d){0,3}))?(\s)?((\d){1,3}x(\d){1,3})?$
	I hope you enjoy, I plan on updating this ocassionally*/}}
	
	{{$base:="https://picsum.photos/"}}
	{{$width:="250"}}
	{{$height:="250"}}
	{{if reFind `((\d){1,3}x(\d){1,3})` .Cmd}}
		 {{$wh:=reReplace `\A-pic(ture)?(\s(random|id(\s)?(\d){0,3}))?(\s)?` .Cmd ""}}
		 {{$wh:=split $wh "x"}}
		 {{$width = (index $wh 0)}}
		 {{$height = (index $wh 1)}}
	{{end}}
	
	{{if reFind "id" .Cmd}}
		 {{$id:=reReplace `^-pic(ture)?\sid(\s)?` .Cmd ""}}
		 {{$id:=reReplace `(\s)?((\d){1,3}x(\d){1,3})` $id ""}}
		 {{if eq $id ""}}
			  {{$id:= randInt 0 999}}
			  {{$image:=(joinStr "" $base "id/" $id "/" $width "/" $height)}}
			  {{sendMessage nil (cembed "title" (toString $id) "image" (sdict "url" $image) "color" 123 "timestamp" currentTime "footer" (sdict "text" (joinStr "" "From " .User.String) "icon_url" (.User.AvatarURL "256")))}}
		 {{else}}
			  {{$image:=(joinStr "" $base "id/" $id "/" $width "/" $height)}}
			  {{sendMessage nil (cembed 
			  "title" (toString $id) "image" (sdict "url" $image)  "color" 123 "timestamp" currentTime "footer" (sdict "text" (joinStr "" "From " .User.String) "icon_url" (.User.AvatarURL "256")))}}
		 {{end}}
	{{else if reFind "random" .Cmd}}
		 {{$image:=(joinStr "" $base $width "/" $height "?random=" (randInt 0 1000000000))}}
			  {{sendMessage nil (cembed "title" (title "Random") "image" (sdict "url" $image) "color" 123 "timestamp" currentTime "footer" (sdict "text" (joinStr "" "From " .User.String) "icon_url" (.User.AvatarURL "256")))}}
	{{else if reFind `\A-pic(ture)?$` .Cmd}}
		 {{sendMessage nil "To get a specific picture: `-pic id<picture id>`\n     If you place nothing after `id` then it will produce a random image that has an id, unlike using `random`\nTo get a random image: `-pic random`\n     When using `random` you won't be able to get the id of the image, `random` has a wider scope of possible images though\nBy adding `<number>x<number>` to the end you can effectivley declare the` widthxheight` of the image you want\n**Examples**\n`-pic id237 500x500`\n`-pic id`\n`-pic id237`\n`-pic random`"}}
	{{end}}
