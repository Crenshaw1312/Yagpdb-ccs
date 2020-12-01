{{/*
Made by: LemmeCry#0001

Trigger Type: reaction
Trigger: added+removed

*/}}
{{/*Trigger Type: Reactions (Added + Removed Reactions)*/}}
{{$channel := logging_channel_id}} 
{{$color := 3368703}}
{{$state := ""}}
{{$mid := (print "https://discord.com/channels/" .Guild.ID "/" .Channel.ID "/" .Message.ID)}}
{{if .ReactionAdded}}
{{$state = "Added"}}
{{else}}
{{$state = "Removed"}}
{{end}}
{{$embed := cembed
"title" (print "A reaction has been " $state) 
"author" (sdict "name" .User.Username "icon_url" (.User.AvatarURL "256")) 
"color" $color
"fields" (cslice 
(sdict "name" "User:" "value" (print .User.String "\n(" .User.ID ")") "inline" false)
(sdict "name" "Emote:" "value" (print .Reaction.Emoji.Name "\n(" .Reaction.Emoji.ID ")") "inline" false)
(sdict "name" "Message:" "value" (print "[Here](" $mid ")\n(" .Message.ID ")") "inline" false)
(sdict "name" "Channel:" "value" (print "<#" .Channel.ID ">" "\n(" .Channel.ID ")") "inline" false)
)
"timestamp" currentTime
}}
{{sendMessage $channel $embed}}
