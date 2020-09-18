{{/*Made by Crenshaw#7860
Trigger type- Regex: ^-req(uest)?
There is also other sites you can swap out in request-plugins
Just copy all of this and modify it aas needed*/}}

{{$args := parseArgs 1 "-request <item name> -- <item description (optional)> `Ex: -request Generator Rex -- tv show 2010`"
(carg "string" "name")}}
{{$ReqChanID := 755561118990336141}}{{/*replace the numbers with the channel ID you want requests to go to*/}}
{{$sect := "sector id goes here no in:"}}{{/*your gdrive sector ID, if you need help re-read the README.md or DM me*/}}
 
{{$split := (split (joinStr "" ($args.Get 0) "--") "--")}}
{{$name := (index $split 0)}}
{{$xinfo := (index $split 1)}}
 
{{$gdrive := (reReplace " " (joinStr "" "https://drive.google.com/drive/u/0/search?q=" ($name) "%20in:" ($sect)) "%20")}}
{{$1337 := (reReplace " " (joinStr "" "https://1337x.to/search/" ($name) "/1/") "-")}}
{{$kickass := (reReplace " " (joinStr "" "https://kickasstorrents.to/usearch/" ($name)) "-")}}
{{$rarbg := (reReplace " " (joinStr "" "https://rarbg.to/torrents.php?search=" ($name)) "+")}}
{{$IMDB := (reReplace " " (joinStr "" "https://www.imdb.com/find?q=" ($name) "&ref_=nv_sr_sm") "+")}}
{{$google := (reReplace " " (joinStr "" "https://www.google.com/search?q=" ($name)) "+")}}
{{$avatar := (joinStr "" "https://cdn.discordapp.com/avatars/" (toString .User.ID) "/" .User.Avatar ".png") }}
 
{{$e := cembed 
    "title" (title $name)
    "description" (joinStr "" "🔵 =I'll do it  |  🔴 =Not happening \n 🟡 =Already have it  |  🟣 =Too much/little information \n :arrow_down: **Additonal information**:arrow_down:  \n" ($xinfo) "\n" "-from "  .User.Mention)
    "color" 4645612 
    "fields" (cslice
        (sdict "name" "Google search" "value" (print "[google](" $google ")") "inline" true)
        (sdict "name" "Gdrive Search" "value" (print "[Gdrive](" $gdrive ")") "inline" true) 
        (sdict "name" "1337x search" "value"  (print "[1337x](" $1337 ")") "inline" true) 
        (sdict "name" "Rarbg search" "value"  (print "[Rarbg](" $rarbg ")") "inline" true) 
        (sdict "name" "Kickass Torrents search" "value" (print "[KAT](" $kickass ")") "inline" true)
        (sdict "name" "IMBD search" "value" (print "[IMDB](" $IMDB ")") "inline" true))
    "thumbnail" (sdict "url" $avatar)}}
 
{{$id:=sendMessageRetID $ReqChanID $e}}
{{addMessageReactions $ReqChanID $id "🔵" "🔴" "🟡" "🟣"}}
{{deleteTrigger 5}}
{{deleteResponse 5}}
{{sendDM (joinStr "" "Your request has been sent for " "`" $name "`" "\n" "You can delete your request by reacting with :red_circle:")}}
