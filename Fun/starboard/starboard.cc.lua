{{/*
Made by: Crenshaw#1312
Credit: Devonte#0745, helping with minimizing ranges
Credit: everyone yellling at me to fix db on force delete starboard message :P <3

Trigger Type: Reaction
Trigger: Added + Removed

Note: Keeps track of reaction count, supports images and embeds, also discord image links, and whatever plugins you add
Note: Tenor plugin wont always work as it should, my display wrong gif, works fine without plugin
Note: Youre safe to allow emojis in starboard channel,
*/}}

{{/* CONFIGURATION VALUES START*/}}

{{ $emoji := "⭐"}} {{/* emoji, unicode if stadard, or just the name if it's custom*/}}
{{ $stars := 1 }} {{/* amount of stars needed to be added*/}}
{{ $chan := 785542681942032424 }} {{/* starboard channel*/}}
{{ $color := 0x4B0082 }} {{/* color takes decimal or hex*/}}
{{ $removal := true }} {{/* if reactions go below $stars, delete starboard*/}}
					
{{/* ADVANCED CONFIGURATION VALUES*/}}
					
{{ $validFiles := `png|jpe?g|gif|webp|mp4|mkv|mov|wav` }} {{/*allowed file types, regex allowed, ln 20*/}}
					
{{/* CONFIGURATION VALUES END DON NOT EDIT BELOW THIS LINE*/}}

				
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

{{/* Transfering embed values and plugins*/}}
	{{ if .ReactionMessage.Embeds }}
		{{ with (structToSdict (index .ReactionMessage.Embeds 0)) }}
			{{ range $k, $v := . }}
				{{ if and $v (not (eq $k "Fields" "Author" "Footer" "Color" "Timestamp")) }} {{/*not transfered*/}}
					{{ $embed.Set $k $v }}
				{{ end }}
			{{ end }}
			{{ if eq (lower .Type) "image" "gifv" }}
				{{ $embed = sdict
					"Author" $embed.Author
                  			"Image" .Thumbnail
                  			"Description" $embed.Description
					"Footer" $embed.Footer
                  			"Color" $color
					"Timestamp" $embed.Timestamp
					"Fields" $embed.Fields
				}}
			{{ end }}
{{/* Tenor start*/}}
{{/* Tenor End*/}}
{{/* Twitter Plugin Start*/}}
{{/* Twitter Plugin End*/}}
{{/* Github Plugin Start*/}}
{{/* Github Plugin End */}}
{{/* Youtube Plugin Start*/}}
{{/* Youtube Plugin End*/}}
		{{ end }}
	{{ end }}

{{/* send n save the message!*/}}
	{{ $id := sendMessageRetID $chan (cembed $embed) }}
	{{ dbSet 0 .ReactionMessage.ID (toString $id) }}

{{/*if it already exsists*/}}
{{ else if ($db := dbGet 0 .ReactionMessage.ID) }}
	{{ if (getMessage $chan (toInt $db.Value)) }}
{{/* fixing field and CC struct so it's sDcit*/}}
		{{ $embed := structToSdict (index (getMessage $chan $db.Value ).Embeds 0) }}
		{{ $f := cslice }}
		{{ range $embed.Fields }}
			{{ $f = $f.Append (structToSdict .) }}
		{{ end }}
		{{ $embed.Set "Fields" $f }}
{{/* Updating the Message*/}}
		{{ if $count }}
			{{ (index $embed.Fields 0).Set "Name" (print "Reactions: " $count) }}
			{{ editMessage $chan $db.Value (cembed $embed) }}
		{{ else if and $removal (lt $count $stars) }}
			{{ deleteMessage $chan $db.Value 0 }}
			{{ dbDel 0 $db.Key }}
		{{ end }}
{{/* If the message was delete by force, not emoji*/}}
	{{ else }}
		{{ dbDel 0 $db.Key }}
	{{ end }}
{{ end }}
