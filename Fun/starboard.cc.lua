{{/*
Made by: Crenshaw#1312

Trigger Type: Reaction
Trigger: Added Only

Note* unsure if this works completely, have found no errors yet though
Note* Keeps track of reaction count, supports images and embeds, also discord image links
*/}}

{{{/*CONFIGURATION VALUES START*/}}
 
{{ $emoji := "⭐"}} {{/*emoji, unicode if stadard, or just the name if it's custom*/}}
{{ $stars := 1 }} {{/*amount of stars needed to be added*/}}
{{ $chan := 785542681942032424 }} {{/*starboard channel*/}}
{{ $color := 0x4B0082 }} {{/*color takes decimal or hex*/}}
{{ $showImage := true }} {{/*weather or not to show an image in the embed*/}}
{{/*CONFIGURATION VALUES END*/}}
 
{{/*The count of the stars*/}}
{{ $count := 0 }}
{{ range .ReactionMessage.Reactions }}
	{{ if and (eq .Emoji.Name $emoji) }}
		{{ $count = .Count }}
	{{ end }}
{{ end }}
 
{{ $msgLink := printf "https://discordapp.com/channels/%d/%d/%d" .Guild.ID .Channel.ID .ReactionMessage.ID }}
 
{{ if and .ReactionAdded (eq .Reaction.Emoji.Name $emoji) (ne (toInt .Channel.ID) $chan) (ge $count $stars) (not (dbGet 0 .ReactionMessage.ID).Value) }}
 
{{/* making the Embed*/}}
	{{ $embed := sdict
		"Author" (sdict "name" .ReactionMessage.Author.Username "icon_url" (.ReactionMessage.Author.AvatarURL "256"))
		"Description" .ReactionMessage.Content
		"Color" $color
        "Timestamp" .ReactionMessage.Timestamp
		"Footer" (sdict "text" "Posted on")
		"Fields" (cslice (sdict "Name" (print "Reactions: " $count) "Value" (print "\n**[Message Link](" $msgLink ")**") "Inline" true))
	}}
 
{{/* transfering values if it's an embed */}}
	{{ $image := "" }}
	{{ if not $showImage }}
		{{ $image = "Image" }}
	{{ end }}
	{{ with .ReactionMessage.Embeds }}
		{{ range $key, $value := (structToSdict (index . 0)) }}
			{{ if not (eq $key "Fields" "Author" "Footer" "Thumbnail" "Color" "Timestamp" $image) }} {{/*the things here are what will not be transfered*/}}
				{{ $embed.Set $key $value }}
			{{ end }}
		{{ end }}
	{{ end }}
 
{{/* find image via link*/}}
	{{ $link := 0 }}
	{{- $link := reFind `https?://(?:\w+\.)?[\w-]+\.[\w]{2,3}(?:\/[\w-_.]+)+\.(?:png|jpg|jpeg|gif|webp)` .ReactionMessage.Content -}}
		{{ if and $showImage $link }}
			{{ $embed.Set "Image" (sdict "url" $link) }}
		{{ end }}
 
{{/* Set up attachments*/}}
	{{ range $i, $v := .ReactionMessage.Attachments }}
		{{ if and (reFind `(?:png|tif|jpe?g|gif)$` $v.Filename) (eq 1 (add $i 1)) $showImage }}
			{{ $embed.Set "Image" (sdict "url" $v.URL) }}
		{{ end }}
		{{ $val := print "[Attachment " (add $i 1) "](" $v.URL ")" }}
		{{ if eq 2 (len $embed.Fields) }}
			{{ (index $embed.Fields 1).Set "Value" (print (index $embed.Fields 1).Value "\n" $val) }}
		{{ else }}
			{{ $embed.Set "Fields" ($embed.Fields.Append 
				(sdict "Name" "Attachments" "Value" $val "Inline" true)
			) }}
		{{ end }}
	{{ end }}
 
{{/*send n' save the message!*/}}
	{{ $id := sendMessageRetID $chan (cembed $embed) }}
	{{ dbSet 0 .ReactionMessage.ID (toString $id) }}
 
{{/*if it already exsists*/}}
{{ else if ($db := dbGet 0 .ReactionMessage.ID) }}
{{ $embed := structToSdict (index (getMessage $chan $db.Value ).Embeds 0) }}
	{{ $embed.Set "Fields" (cslice
		(sdict "Name" (print "Reactions: " $count) "Value" (print "\n**[Message Link](" $msgLink ")**") "Inline" false)
    ) }}
	{{ if $count }}
		{{ editMessage $chan $db.Value (cembed $embed) }}
	{{ else }}
		{{ deleteMessage $chan $db.Value 0 }}
		{{ dbDel 0 $db.Key }}
	{{ end }}
{{ end }}
