{{/*Made by Crenshaw#7860
Trigger type: Regex ^-(guild|server)\s?(info)?
			Command guild
Just a nice, clean,simple, and wholesome server/guild information command*/}}

{{$filter:="Don't Scan any media content"}}
{{if eq .Guild.ExplicitContentFilter 1}}
	{{$filter = "Scan media content from\nmembers without a role."}}
{{else if eq .Guild.ExplicitContentFilter 2}}
	{{$filter = "Scan media content\nfrom all members."}}
{{end}}
{{$created:=(div .Guild.ID 4194304 | mult 1000000 | toDuration | .DiscordEpoch.Add)}}
{{$created = formatTime $created "03/01/2006"}}
{{sendMessage nil (cembed
"author" (sdict "name" (joinStr "" "Owned by " ((userArg .Guild.OwnerID).String)) "icon_url" ((userArg .Guild.OwnerID).AvatarURL "256"))
"thumbnail" (sdict "url" (joinStr "" "https://cdn.discordapp.com/icons/" .Guild.ID "/" .Guild.Icon ".jpeg?size=1024"))
"color" 123
"title" .Guild.Name
"description" (joinStr "" "**Members - **" onlineCount "**/**" .Guild.MemberCount "\n**Role Count - **" (len .Guild.Roles) "\n**Region - **" (title .Guild.Region)  "\n**ID - **" .Guild.ID "\n**Content Filter - **" $filter "\n**Date Created - **" $created)
"footer" (sdict "text" (joinStr "" "Requested by " .User.String) "icon_url" (.User.AvatarURL "256"))
)}}
