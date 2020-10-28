{{/*Made by Crenshaw#7860
	Based/Learned from jo3l"s*/}}
{{$user := .User}}
{{$args := parseArgs 0 "`-avatar <user>`"
(carg "userid" "user")}}

{{if $args.IsSet 0}} {{/*based /learned off Jo3l's*/}}
	{{$user = userArg ($args.Get 0)}}
{{end}}

{{sendMessage nil (cembed
	"title" (joinStr "" (printf "%s" $user.String))
	"image" (sdict "url" ($user.AvatarURL "128"))
	"color" 0x4B0082
    "footer" (sdict "text" (joinStr "" "Requested by " .User.String))
)}}
