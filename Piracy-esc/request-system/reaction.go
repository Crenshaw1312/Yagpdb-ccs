{{$uploader:=733362574401339412}}
{{$booster:=742769937126260819}}

{{/*NO TOUCHY TOUCHIES*/}}
{{$mssg := getMessage nil .ReactionMessage.ID}}
{{$item := (index .ReactionMessage.Embeds 0).Title}}
{{$requestee := toString (reFind "[0-9]{15,20}" ((index .ReactionMessage.Embeds 0).Description))}}
 
{{/*reaction order is blue,red,purple,yellow*/}}
 
{{if eq (toString .User.ID) $requestee}}
     {{if ge ((index $mssg.Reactions 1).Count) 2}}
          {{deleteMessage nil .ReactionMessage.ID 1}}
     {{else}}
          {{deleteMessageReaction nil .ReactionMessage.ID .User.ID "🔵" "🔴" "🟡" "🟣"}}
     {{end}}
{{end}}
 
{{/*check for uploader*/}}
{{if hasRoleID $uploader}}
 
{{/*for Blue*/}}
          {{if ge ((index $mssg.Reactions 0).Count) 2}}
               {{execAdmin "grep" .User}}
   {{/*this is bonus rep if the requestee is a server booster*/}}
               {{if targetHasRoleID (toInt $requestee) $booster}}
                    {{execAdmin "grep" .User}}
               {{else if hasRoleID $uploader}}
                    {{execAdmin "grep" .User}}
               {{end}}
               {{$ID := sendMessageRetID .Guild.SystemChannelID (joinStr "" "<@" $requestee "> :blue_circle: your request for `" $item "` was completed by " .User.String "!")}}
              {{sendMessage 734843270017843231 $item}}
              {{deleteResponse 1}}
              {{deleteMessage nil .ReactionMessage.ID 1}}
         {{end}}
 
{{/*for Red*/}}
         {{if ge ((index $mssg.Reactions 1).Count) 2}}
                 {{$ID := sendMessageRetID .Guild.SystemChannelID (joinStr "" "<@" $requestee "> :red_circle: your request for `" $item "` was deleted")}}
                 {{deleteMessage nil .ReactionMessage.ID 1}}
        {{end}}
 
{{/*for Purple*/}}
         {{if ge ((index $mssg.Reactions 3).Count) 2}}
                 {{$ID := sendMessageRetID .Guild.SystemChannelID (joinStr "" "<@" $requestee "> :purple_circle: re-submit your request for `" $item "` remember to use `--` for add info!")}}
                 {{deleteMessage nil .ReactionMessage.ID 1}}
         {{end}}
 
{{/*for Yellow*/}}
         {{if ge ((index $mssg.Reactions 2).Count) 2}}
                 {{$ID := sendMessageRetID .Guild.SystemChannelID (joinStr "" "<@" $requestee "> :yellow_circle: your request for `" $item "` is already in the drive")}}
                 {{deleteMessage nil .ReactionMessage.ID 1}}
         {{end}}
{{end}}
