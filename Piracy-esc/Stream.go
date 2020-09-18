{{/*Made by Crenshaw#7860
	Returns streamlinks from a imdb link
	Only use it three times a day, unless you have a VPN to avoid IP ban*/}}
{{$embed:=sdict "title" "Stream" "thumbnail" (sdict "url" (joinStr "" "https://cdn.discordapp.com/icons/" .Guild.ID "/" .Guild.Icon ".jpeg?size=1024")) "description" "some link stuff" "footer" (sdict "text" (joinStr "" "Request from " .User.String) "icon_url" (.User.AvatarURL "128")) "timestamp" currentTime "color" 123}}
{{if eq (len .CmdArgs) 2}}
{{/*getting season and episode num*/}}
     {{$seep := reReplace "s" (index .CmdArgs 1) ""}}
     {{$seep := split ($seep) "e"}}
     {{$ep := index $seep 1}}
     {{$se := index $seep 0}}
{{/* getting imdb id*/}}
     {{$tt := reFind `(tt(\d+){7})` (index .CmdArgs 0)}}
     {{$link:=(joinStr "" "https://streamvideo.link/getvideo?key=TuhxekfV5tSxbQN0&video_id=" ($tt) "&tv=1&s=" ($se) "&e" ($ep))}}
     {{$embed.Set "description" $link}}
     {{$embed.Set "title" "Stream (Tv show)"}}
     {{sendMessage nil (cembed $embed)}}
{{else if eq (len .CmdArgs) 1}}
     {{$tt := reFind `(tt(\d+){7})` (index .CmdArgs 0)}}
     {{$link:=(joinStr "" "https://streamvideo.link/getvideo?key=TuhxekfV5tSxbQN0&video_id=" ($tt) "&s=0&e=0")}}
     {{$embed.Set "description" $link}}
     {{$embed.Set "title" "Stream (Movie)"}}
     {{sendMessage nil (cembed $embed)}}
{{else}}
     {{sendMessage .Channel.ID "`-stream <IMDB link> s#e#` (For movies you don't need the `1s#e#`)"}}
{{end}}

{{/*https://streamvideo.link/getvideo?key=TuhxekfV5tSxbQN0&video_id=[VIDEO_ID]&tv=[TV]&s=[SEASON_NUMBER]&e=[EPISODE_NUMBER]*/}}
