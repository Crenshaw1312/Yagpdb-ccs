{{/*Made by Crenshaw#7860
Trigger type- Regex: ^-req(uest)?
Just copy all of this and modify it as needed*/}}
{{$Fields:=true}} {{/*Set to false if you don't want any search links*/}}
{{/* Toggle to false for what searches you want*/}}
{{$gdrive:=true}}  {{$1337x:=true}}
{{$kickass:=true}}{{$rarbg:=true}}
{{$IMDB:=true}}   {{$google:=true}}
{{$sect := "0ANfffJKx6vCrUk9PVA"}}{{/*your gdrive sector ID, if you need help re-read the README.md or DM me*/}}
{{$ReqChanID := 755561118990336141}}{{/*replace the numbers with the channel ID you want requests to go to*/}}

{{/*NO TOUCHY THOUCHY*/}}
{{$args := parseArgs 1 "-request <item name> -- <item description (optional)> `Ex: -request Generator Rex -- tv show 2010`"
(carg "string" "name")}}
{{$fields:=cslice}}
{{$split := (split (joinStr "" ($args.Get 0) "--") "--")}}
{{$name := (index $split 0)}}
{{$xinfo := (index $split 1)}}

{{if $Fields}}
{{if $gdrive}}{{$fields = $fields.Append (sdict "name" "Gdrive Search" "value" (print "[Gdrive](" (reReplace " " (joinStr "" "https://drive.google.com/drive/u/0/search?q=" ($name) "%20in:" ($sect)) "%20") ")") "inline" true)}}{{end}}
{{if $1337x}}{{$fields = $fields.Append (sdict "name" "1337x search" "value"  (print "[1337x](" (reReplace " " (joinStr "" "https://1337x.to/search/" ($name) "/1/") "-") ")") "inline" true)}}{{end}}
{{if $kickass}}{{$fields = $fields.Append (sdict "name" "KAT search" "value" (print "[KAT](" (reReplace " " (joinStr "" "https://kickasstorrents.to/usearch/" ($name)) "-") ")") "inline" true)}}{{end}}
{{if $rarbg}}{{$fields = $fields.Append (sdict "name" "Rarbg search" "value"  (print "[Rarbg](" (reReplace " " (joinStr "" "https://rarbg.to/torrents.php?search=" ($name)) "+") ")") "inline" true)}}{{end}}
{{if $IMDB}}{{$fields = $fields.Append (sdict "name" "IMBD search" "value" (print "[IMDB](" (reReplace " " (joinStr "" "https://www.imdb.com/find?q=" ($name) "&ref_=nv_sr_sm") "+") ")") "inline" true)}}{{end}}
{{if $google}}{{$fields = $fields.Append (sdict "name" "Google search" "value" (print "[google](" (reReplace " " (joinStr "" "https://www.google.com/search?q=" ($name)) "+") ")") "inline" true)}}{{end}}
{{end}}
 
{{$e := cembed 
    "title" (title $name)
    "description" (joinStr "" "🔵 =I'll do it  |  🔴 =Not happening \n 🟡 =Already have it  |  🟣 =Too much/little information \n :arrow_down: **Additonal information**:arrow_down:  \n" ($xinfo) "\n" "-from "  .User.Mention)
    "color" 4645612 
    "fields" ($fields)
    "thumbnail" (sdict "url" (.User.AvatarURL "256"))}}
 
{{$id:=sendMessageRetID $ReqChanID $e}}
{{addMessageReactions $ReqChanID $id "🔵" "🔴" "🟡" "🟣"}}
{{deleteTrigger 5}}
{{deleteResponse 5}}
{{sendDM (joinStr "" "Your request has been sent for " "`" $name "`" "\n" "You can delete your request by reacting with :red_circle:")}}
