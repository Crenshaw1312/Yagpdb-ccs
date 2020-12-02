{{/*
Made by: Crenshaw#1312

Trigger Type: Reaction
Trigger: Added Only

Note* The basic concept works fine though, suports embeds too!
Note* Extremly Broken, image support is spotty, doesn't update emoji count right, or update message.
*/}}

{{/*CONFIGURATION VALUES START*/}}

{{ $emoji := "⭐"}} {{/*emoji, unicode if stadard, or just the name if it's custom*/}}
{{ $stars := 1 }} {{/*amount of stars needed to be added*/}}
{{ $chan := 773225735867334676 }} {{/*starboard channel*/}}
{{ $color := 0x7DF9FF }} {{/*color takes decimal or hex, color for the embed*/}}
{{/*CONFIGURATION VALUES END*/}}

{{ $count := 0 }}
{{ range .ReactionMessage.Reactions }}
	{{ if and (eq .Emoji.Name $emoji) (ge .Count $stars) }}
		{{ $count = .Count }}
	{{ end }}
{{ end }}

{{ $msgLink := printf "https://discordapp.com/channels/%d/%d/%d" .Guild.ID .Channel.ID .ReactionMessage.ID }}

{{ if and (eq .Reaction.Emoji.Name $emoji) (ge $count $stars) }}

{{/* making the Embed*/}}
	{{ $postedAt := (.ReactionMessage.Timestamp.Parse).Format "Jan 01 2006 3PM" }}
	{{ $embed := sdict
		"Author" (sdict "name" .ReactionMessage.Author.Username "icon_url" (.ReactionMessage.Author.AvatarURL "256"))
		"Description" .ReactionMessage.Content
		"Color" $color
		"Footer" (sdict "text" (print "Posted on " $postedAt))
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
{{ $link }}
  {{ if $link }}
    {{ $embed.Set "Image" (sdict "url" $link) }}
  {{ else }}
    {{ with .ReactionMessage.Attachments }}
			{{ if reFind `(?:png|tif|jpe?g|gif)$` .Filename }}
				{{ $embed.Set "Image" (sdict "url" (index . 0).URL) }}
			{{ end }}
		{{ end }}
	{{ end }}

{{/*send the message!*/}}
	{{ sendMessage $chan (cembed $embed) }}
{{ end }}
                                                
                                                
