{{/*
Made by: Crenshaw#1312
Credit: LemmeCry#0001

Trigger Type: Regex
Trigger: \A(?:\s?)(https://)?discord\.(gg|com/invite)/[^\s]{8,10}(?:\s?)

Note: Just paste the link in, no extra content
*/}}

{{ $id := sendMessageRetID nil (print .Cmd "#") }}
{{ sleep 1 }}
{{ $invite := structToSdict (index (getMessage nil $id).Embeds 0) }}

{{ deleteMessage nil $id 0 }}

{{ $name := reReplace `(Join\sthe\s|\sDiscord\sServer!)` $invite.Title "" }}
{{ $members := reFindAll `\d+` $invite.Description }} {{ $members = print "Member Count: **" (index $members (sub (len $members) 1)) "**" }}

{{ $embed := sdict
	"Author" (sdict "icon_url" (.User.AvatarURL "256") "Name" .User.String)
    "Thumbnail" (sdict "url" $invite.Thumbnail.URL)
	"Title" $name
  	"URL" .Cmd
  	"Description" $members
  	"Color" 0x4B0082
}}
{{ sendMessage nil (cembed $embed) }}
{{ deleteTrigger 0 }}
