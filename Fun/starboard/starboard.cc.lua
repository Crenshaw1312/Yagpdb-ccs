{{/*
Made by: Crenshaw#1312
Credit: Devonte#0745, helping with minimizing ranges

Trigger Type: Reaction
Trigger: Added Only

Note* unsure if this works completely, have found no errors yet though
Note* Keeps track of reaction count, supports images and embeds, also discord image links
*/}}

{{/* CONFIGURATION VALUES START*/}}
{{ $emoji := "⭐"}} {{/* emoji, unicode if stadard, or just the name if it's custom*/}}
{{ $stars := 1 }} {{/* amount of stars needed to be added*/}}
{{ $chan := 785542681942032424 }} {{/* starboard channel*/}}
{{ $color := 0x4B0082 }} {{/* color takes decimal or hex*/}}
{{ $removal := true }} {{/* if reactions go below $stars, delete starboard*/}}
{{/* ADVANCED CONFIGURATION VALUES*/}}
{{ $validFiles := `png|jpe?g|gif|webp|mp4|mkv|mov|wav` }} {{/*allowed file types, regex allowed, ln 20*/}}
{{/* CONFIGURATION VALUES END*/}}

{{/* The count of the stars*/}}
{{ $count := 0 }}
{{ range .ReactionMessage.Reactions }}
	{{ if and (eq .Emoji.Name $emoji) }}
		{{ $count = .Count }}
	{{ end }}
{{ end }}

{{ $msgLink := printf "https://discordapp.com/channels/%d/%d/%d" .Guild.ID .Channel.ID .ReactionMessage.ID }}
{{ $filegex := print `https?://(?:\w+\.)?[\w-]+\.[\w]{2,3}(?:\/[\w-_.]+)+\.(` $validFiles `)` }}


{{ if and .ReactionAdded (eq .Reaction.Emoji.Name $emoji) (ge $count $stars) (ne (toInt .Channel.ID) $chan) (not (dbGet 0 .ReactionMessage.ID).Value) }}

{{/* making the Embed*/}}
	{{ $embed := sdict
		"Author" (sdict "name" .ReactionMessage.Author.Username "icon_url" (.ReactionMessage.Author.AvatarURL "256"))
		"Description" (reReplace $filegex .ReactionMessage.Content "")
		"Color" $color
        "Timestamp" .ReactionMessage.Timestamp
		"Footer" (sdict "text" "Posted on")
		"Fields" (cslice (sdict "Name" (print "Reactions: " $count) "Value" (print "\n**[Message Link](" $msgLink ")**") "Inline" true))
	}}

{{/* transfering values if it's an embed*/}}
	{{ with .ReactionMessage.Embeds }}
		{{ range $k, $v := (structToSdict (index . 0)) }}
			{{ if and $v (not (eq $k "Fields" "Author" "Footer" "Color" "Timestamp" "Thumbnail")) }} {{/*things here will not be transfered*/}}
				{{ $embed.Set $k $v }}
			{{ end }}
		{{ end }}
	{{ end }}

{{/* find all image/file via link*/}}
	{{ $attachLinks := cslice }}
	{{ range .ReactionMessage.Attachments }}
        {{- if reFind $filegex .URL -}}
                {{ $attachLinks = $attachLinks.Append .URL }}
        {{ end }}
	{{ end }}
	{{ $links := reFindAll $filegex .ReactionMessage.Content }}
	{{ $links = $attachLinks.AppendSlice $links }}

	{{ range $i,$v := $links }}
		{{ $name := reFind `/[^/]+$` $v }} {{ $name = slice $name 1 }}
		{{ if reFind `(?:png|jpg|jpeg|gif|webp|tif)$` $v }}
			{{ $embed.Set "Image" (sdict "url" $v) }}
		{{ end }}
		{{ $val := print (add $i 1) " **»** [" $name "](" $v ")" }}
		{{ if eq 2 (len $embed.Fields) }}
			{{ (index $embed.Fields 1).Set "Value" (print (index $embed.Fields 1).Value "\n" $val) }}
		{{ else }}
			{{ $embed.Set "Fields" ($embed.Fields.Append 
				(sdict "Name" "Attachments" "Value" $val "Inline" false)
			) }}
		{{ end }}
	{{ end }}

{{/* Special handling for video/article embeds*/}}
	{{ if .ReactionMessage.Embeds }}
		{{ with (structToSdict (index .ReactionMessage.Embeds 0)) }}
{{/* Twitter Plugin Start*/}}
{{/* Twitter Plugin End*/}}
		{{ end }}
	{{ end }}

{{/*send n' save the message!*/}}
	{{ $id := sendMessageRetID $chan (cembed $embed) }}
	{{ dbSet 0 .ReactionMessage.ID (toString $id) }}

{{/*if it already exsists*/}}
{{ else if ($db := dbGet 0 .ReactionMessage.ID) }}
	{{ $embed := structToSdict (index (getMessage $chan $db.Value ).Embeds 0) }}
	{{ $f := cslice }}
	{{ range $embed.Fields }}
		{{ $f = $f.Append (structToSdict .) }}
	{{ end }}
	{{ $embed.Set "Fields" $f }}

	{{ if $count }}
		{{ (index $embed.Fields 0).Set "Name" (print "Reactions: " $count) }}
		{{ editMessage $chan $db.Value (cembed $embed) }}
	{{ else if and $removal (lt $count $stars) }}
		{{ deleteMessage $chan $db.Value 0 }}
		{{ dbDel 0 $db.Key }}
	{{ end }}
{{ end }}
