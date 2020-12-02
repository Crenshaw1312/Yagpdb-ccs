{{/* CONFIG */}}
{{$responses := cslice "Yes." "No." "Maybe." "I'm not sure." "Probably." "I don't know." "I don't think so."}}

{{/* CODE */}}
{{$random := (index $responses (randInt (len $responses)))}}

{{$embed := sdict
  "author" (sdict "name" (printf "%s (%d)" .User.String .User.ID) "icon_url" (.User.AvatarURL "256"))
  "fields" (cslice 
      (sdict "name" "Question:" "value" (printf "%s" (reReplace `\A-8ball\s*\z` .Message.Content "")))
      (sdict "name" "Answer:" "value" $random)
  )
}}
{{sendMessage nil (cembed $embed)}}
