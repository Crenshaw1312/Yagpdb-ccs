{{/*Not made by Crenshaw#7860*/}}
{{$args:=parseArgs 1 "Please provide something to spam" (carg "string" "text")}}
{{$id:=sendMessageRetID nil "\n."}}
{{/*Copy and paste the part below as much as you want till you run out of characters
There's probably a max that discord has but eh
Try messing around with the number next to sleep so it seems like the command may be done... ALTHOUGH IT'S NOT
Go bananas*/}}
{{sleep 1}}
{{editMessage nil $id (joinStr "" (getMessage nil $id).Content "\n" ($args.Get 0))}}
{{editMessage nil $id (joinStr "" (getMessage nil $id).Content "\n" ($args.Get 0))}}
{{editMessage nil $id (joinStr "" (getMessage nil $id).Content "\n" ($args.Get 0))}}
{{editMessage nil $id (joinStr "" (getMessage nil $id).Content "\n" ($args.Get 0))}}
{{editMessage nil $id (joinStr "" (getMessage nil $id).Content "\n" ($args.Get 0))}}
