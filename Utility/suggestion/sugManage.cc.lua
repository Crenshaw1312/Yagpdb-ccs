{{/*
Made by: Crenshaw#1312

Trigger Type: Regex
Trigger: \A-s(ug|uggestion(s)?)?\s?(del(ete)?|deny|com(ment)?|ap(prove)?|imp(lement)?|q(oute)?)

Usage:
  Base: -suggestion/-sug/-s
  
  -sug del/delete/deny <sugNum> [reason]
      ^Remove a suggestion
      
  -sug com/comment <sugNum> <comment>
      ^Comment on a suggestion (supports multipule comments and editing them)
      
  -sug ap/approve <sugNum> [reason]
      ^Approve of a suggestion
      
  -sug imp/implement <sugNum> [reason]
      ^Implement a suggestion, youve done what this suggestion asked
      
  -sug q/quote <sugNum>
      ^Anyone can use this, quote a suggestion

Note: `-sug implement` and `-sug approve` both make it so the suggestion WILL NOT be deleted after given seconds in sugCreate.cc.lua
Note: MAKE SURE TO PUT THE CORRECT SUGGESTION CHANEL IN CONFIG VALUES
*/}}

{{/* CONFIGURATION VALUES START*/}}
{{ $sugChan := 796916867586719784 }} {{/* (CHANNEL ID) suggestions channel*/}}
{{ $notify := 770299126528606208 }} {{/* (CHANNEL ID) or (false) notify the author of the suggestion of mod actions to it?*/}}
{{ $impChan := 770299126528606208 }} {{/* (CHANNEL ID) or (false) channel to send implemented suggestions to, false to disable*/}}
{{ $rolesS := cslice 770291866208829470 }} {{/* (ROLED IDs) role(s) that can manage suggestions*/}}
{{ $reason := false }} {{/* (true) or (false), weather or not a reason is required*/}}
{{/* CONFIGURATION VALUES END*/}}

{{/* role requirement*/}}
{{ $mangR := false }}
{{range .Member.Roles}} {{if in $rolesS .}}{{$mangR = true}}{{end}}{{end}}

{{/* Reason management*/}}
{{ if $reason }} {{ $reason = 2 }} {{ else }} {{ $reason = 1 }} {{ end }}
{{ $a := parseArgs $reason "Sug num and optional reason" (carg "int" "sugCount") (carg "string" "reason") }}
{{ if not (reFind `\A-s(ug|uggestion)?\s?q(uote)?` .Cmd ) }}{{ if ($a.IsSet 1) }} {{ $reason = $a.Get 1 }} {{ else }} {{ $reason = "None provided" }} {{ end }} {{ end }}

{{/* Getting suggestion and other data*/}}
{{ if ($db := (dbGet 0 (print "sugs|" ($a.Get 0)))) }}
	{{ $id := toInt $db.Value }}
	{{ $msg := getMessage $sugChan $id }}
	{{ $embed := structToSdict (index $msg.Embeds 0) }}
	{{ $f := cslice }}
	{{ range $embed.Fields }}
		{{ $f = $f.Append (structToSdict .) }}
	{{ end }}
	{{ $embed.Set "Fields" $f }}

	{{ $cmd := reReplace `\A-s(ug|uggestion)?\s?` .Cmd "" }}
	{{ $action := 0 }}

{{/* Comment add/edit*/}}
	{{ if and $mangR (eq $cmd "com" "comment") }}
{{/* Has the user already commented?*/}}
		{{ $foundCom := false }}
		{{ if $embed.Fields }}
			{{ range $i, $v := $embed.Fields }}
				{{ if eq $.User.String $v.Name }}
					{{ $foundCom = (add $i 1) }}
				{{ end }}
			{{ end }}
		{{ end }}
{{/* handle accordingly*/}}
		{{ if and $foundCom ($a.IsSet 1) }}
			{{ $embed.Fields.Set (sub $foundCom 1) (sdict "Name" .User.String "Value" (print "_Comment »_ " ($a.Get 1)) "Inline" true) }}
			{{ $action = "updated comment" }}
		{{ else if (not ($a.IsSet 1)) }}
  	        {{ sendMessage nil "Please place text for your comment" }}
		{{ else if and (not $foundCom) ($a.IsSet 1) }}
			{{ $embed.Set "Fields" ($embed.Fields.Append (sdict "Name" .User.String "Value" (print "_Comment »_ " ($a.Get 1)) "Inline" true)) }}
			{{ $action = "added comment" }}
		{{ end }}
		{{ editMessage $sugChan $id (cembed $embed) }}

{{/* Delete suggestion*/}}
	{{ else if and $mangR (eq $cmd "del" "delete" "deny") }}
		{{ deleteMessage $sugChan $id 0 }}
		{{ dbDel 0 $db.Key }}
		{{ $action = "deleted suggestion" }}

{{/* Quote suggestion*/}}
	{{ else if eq $cmd "q" "qoute" }}
		{{ $embed.Set "URL" (print "https://discord.com/channels/" .Guild.ID "/" $sugChan "/" $id) }}
		{{ $embed.Set "Title" (print "Quote | " $embed.Title) }}
		{{ $embed.Set "Footer" (sdict "Icon_URL" (.User.AvatarURL "256") "Text" (print "Quoted by " .User.String)) }}
		{{ $embed.Del "Timestamp "}}
		{{ sendMessage nil (cembed $embed)}}

{{/* Approve Suggestion*/}}
	{{ else if and $mangR (eq $cmd "ap" "aprove") }}
		{{ if not (reFind "APPROVE" $embed.Title)}}
			{{ $embed.Set "Title" (reReplace `\s#` $embed.Title " (APPROVED) #") }}
			{{ editMessage $sugChan $id (cembed $embed) }}
			{{ dbDel 0 $db.Key }}
			{{ dbSet 0 $db.Key $db.Value }}
			{{ $action = "suggestion approved" }}
		{{ else }}
			This suggestion has already been approved
		{{ end }}

{{/* Implement Suggestion*/}}
	{{ else if and $mangR (eq $cmd "imp" "implement" "implemented") }}
		{{ $embed.Set "Title" (reReplace `(\(APPROVED\))?\s#` $embed.Title " (IMPLEMENTED) #") }}
		{{ $embed.Set "Footer" (sdict "Text" (print .User.String " implemented this ")) }}
		{{ $embed.Set "Timestamp" currentTime }}
		{{ if $impChan }}
			{{ $embed.Set "Description" (print $embed.Description "\nReason: " $reason) }}
			{{ sendMessage $impChan (complexMessage "content" (userArg (index $msg.Mentions 0)).Mention "embed" (cembed $embed)) }}
			{{ deleteMessage $sugChan $id 0 }}
			{{ $action = 0 }}
		{{ else }}
			{{ editMessage $sugChan $id (cembed $embed) }}
			{{ $action = "suggestion implemented" }}
		{{ end }}
		{{ dbDel 0 $db.Key }}
	{{ end }}

{{/* Notfiy?*/}}
	{{ if and $notify $action }}
		{{ sendMessage $notify (complexMessage "content" (userArg (index $msg.Mentions 0)).Mention "embed" (cembed
			"Title" (title $action)
			"Description" (print "[Suggestion #" ($a.Get 0) "](" (print "https://discord.com/channels/" .Guild.ID "/" $sugChan "/" $id) ") action was done by " .User.Mention "\nReason: " $reason)
			"Color" $embed.Color
		)) }}
	{{ end }}

{{ else }}
Invalid suggestion number
{{ end }}
{{ deleteTrigger 5}}
