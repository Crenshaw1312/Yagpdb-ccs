{{/*
Made by: Crenshaw#1312

Trigger Type: Reaction
Trigger: Added Only

Note* unsure if this works completely, have found no errors yet though
Note* Keeps track of reaction count, supports images and embeds, also discord image links
*/}}

{{/*CONFIGURATION VALUES START*/}}

{{ $emoji := "⭐"}} {{/*emoji, unicode if stadard, or just the name if it's custom*/}}
{{ $stars := 1 }} {{/*amount of stars needed to be added*/}}
{{ $chan := 770299126528606208 }} {{/*starboard channel*/}}
{{ $color := 0x4B0082 }} {{/*color takes decimal or hex*/}}
{{/*CONFIGURATION VALUES END*/}}

{{/*The count of the stars*/}}
{{ $count := 0 }}
{{ range .ReactionMessage.Reactions }}
	{{ if and (eq .Emoji.Name $emoji) }}
		{{ $count = .Count }}
	{{ end }}
{{ end }}

{{ $msgLink := printf "https://discordapp.com/channels/%d/%d/%d" .Guild.ID .Channel.ID .ReactionMessage.ID }}

{{ if and .ReactionAdded (eq .Reaction.Emoji.Name $emoji) (ge $count $stars) (not (dbGet 0 .ReactionMessage.ID).Value) }}

{{/* making the Embed*/}}
	{{ $embed := sdict
		"Author" (sdict "name" .ReactionMessage.Author.Username "icon_url" (.ReactionMessage.Author.AvatarURL "256"))
		"Description" .ReactionMessage.Content
		"Color" $color
        "Timestamp" .ReactionMessage.Timestamp
		"Footer" (sdict "text" "Posted on")
		"Fields" (cslice (sdict "name" (print "Reactions: " $count) "value" (print "\n**[Message Link](" $msgLink ")**") "inline" false))
	}}

{{/* transfering values if it's an embed */}}
	{{ with .ReactionMessage.Embeds }}
		{{ range $key, $value := (structToSdict (index . 0)) }}
			{{ if not (eq $key "Fields" "Author" "Footer" "Thumbnail" "Color") }} {{/*the things here are what will not be transfered*/}}
				{{ $embed.Set $key $value }}
			{{ end }}
		{{ end }}
	{{ end }}

{{/* image link or attachment? link is domainant */}}
	{{ $link := 0 }}
	{{- $link := reFind `https?://(?:\w+\.)?[\w-]+\.[\w]{2,3}(?:\/[\w-_.]+)+\.(?:png|jpg|jpeg|gif|webp)` .ReactionMessage.Content -}}
		{{ if $link }}
			{{ $embed.Set "Image" (sdict "url" $link) }}
		{{ else }}
			{{ range .ReactionMessage.Attachments }}
				{{ if reFind `(?:png|tif|jpe?g|gif)$` .Filename }}
					{{ $embed.Set "Image" (sdict "url" .URL) }}
				{{ end }}
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
