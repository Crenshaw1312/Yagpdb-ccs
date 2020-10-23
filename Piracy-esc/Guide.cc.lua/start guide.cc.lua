{{$e := cembed 
"title" (title "What Path?")
"description"  (joinStr "" "```css\n\n#1 [Books] eBooks audioBooks Manga Comics Magazines \n#2 [Movies and TV] DDL+Torrent Streaming Apps\n#3 [Games] General android+ios Bad+Sites\n#4 [Software] Download+Tools Torrent\n```")
"footer" (sdict "text" "Prof#9743 made these documents, Crenshaw#7860 put it into code")
}}
{{$id := sendMessageRetID nil $e}}
{{addMessageReactions nil $id ":one:" ":two:" ":three:" ":four:"}}
{{dbSetExpire .User.ID "guide" $id 300}}
