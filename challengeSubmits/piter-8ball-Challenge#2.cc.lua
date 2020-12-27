{{/*
    Trigger: Command with trigger "-8ball"
    
    Make sure the in-built command is disabled (via command overrides)
    
*/}}
{{/* CONFIG */}}
{{$responses := cslice "Yes." "No." "Maybe." "I'm not sure." "Probably." "I don't know." "I don't think so."}}

{{/* CODE */}}
{{$random := (index (shuffle $responses) 0)}}

{{$embed := sdict
  "author" (sdict "name" (printf "%s (%d)" .User.String .User.ID) "icon_url" (.User.AvatarURL "256"))
  "fields" (cslice 
      (sdict "name" "Question:" "value" (printf "%s" .StrippedMsg))
      (sdict "name" "Answer:" "value" $random)
  )
}}
{{sendMessage nil (cembed $embed)}}
