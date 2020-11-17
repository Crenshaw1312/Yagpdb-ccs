{{/*
    
Trigger Type: Command (Prefix/Mention)
Trigger: game

Usage:
`game <search>` getsthe cover image of a game.
*/}}

{{ $args := parseArgs 1 "" (carg "string" "game name") }}
{{ $rsp := exec "hltb" ($args.Get 0) }}
{{ $rsp = structToSdict $rsp }}
{{ $gameImage := $rsp.Thumbnail.URL }}
{{ $gameTitle := $rsp.Author.Name }}
{{ sendMessage nil (cembed
"title" $gameTitle
"image" (sdict "url" $gameImage)
"color" 0x4B0082
)}}
