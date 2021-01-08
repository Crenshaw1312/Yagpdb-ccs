{{$embed := index .Message.Embeds 0|structToSdict}}
{{range $k, $v := $msg}}
	{{if eq (kindOf $v true) "struct"}}{{$embed.Set $k (structToSdict $v)}}{{end}}
{{end}}
{{if eq .Reaction.Emoji.Name "📱"}}
	{{sendDM (printf "\n**%s**\n%s\n%s\n%s" $embed.Title $embed.Description (or $embed.Image (sdict "URL" "")).URL (reReplace `\)\n.+` $embed.Footer.Text ")"))}}
	{{deleteAllMessageReactions nil .Message.ID}}
	{{addMessageReactions nil .Message.ID "📱"}}
{{end}}
