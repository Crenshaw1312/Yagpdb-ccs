{{/*
Made by: Crenshaw#1312

Trigger Type: Reaction
Trigger: Added + Removed reactions

Requirements: pollCreate.cc.lua
              pollDelete.cc.lua
   (optionla) pollList.cc.lua
*/}}

{{ range ($allPolls := dbTopEntries "poll|%%|%%|%%|%%" 100 0) }}
{{/*Make variables+set up*/}}
	{{ $_ := split (slice .Key 5) "|" }}
{{ $chanID := toInt (index $_ 0) }} {{ $msgID := toInt (index $_ 1) }} {{ $title := index $_ 2 }} {{ $type := index $_ 3 }} {{ $hasVoted := false}} {{ $value := (cslice).AppendSlice .Value }}
{{ if and (not $.User.Bot) (eq (toInt $msgID) (toInt $.ReactionMessage.ID)) }}
{{/*Has the user voted?*/}}
		{{ range $value }}
			{{- if eq (toString $.User.ID) (toString .) -}}
				{{ $hasVoted = true }}
			{{ end }}
		{{ end }}
 
{{/*Dealing with vote*/}}
		{{- if eq $type "single" -}}
			{{ if and $hasVoted $.ReactionAdded }} {{/*They have already voted once, delete what they just voted*/}}
				{{ deleteMessageReaction nil $.ReactionMessage.ID $.User.ID $.Reaction.Emoji.Name }}
			{{ else if and (not $hasVoted) $.ReactionAdded }} {{/*Has not voted before, save their vote*/}}
				{{ $value = $value.Append $.User.ID }}
			{{ else if and $hasVoted (not $.ReactionAdded) }} {{/*Removed their vote, remove them from already voted*/}}
				{{ $oldVotes := $value}} {{ $value = (cslice) }}
				{{- range $oldVotes -}}
					{{- if ne (toString $.User.ID) (toString .) -}}
						{{- $value = $value.Append (toString .) -}}
					{{ end }}
				{{- end -}}
			{{ end }}
 
{{/*Saving any new data*/}}
			{{ dbSet .UserID .Key $value }}
 
{{/*Error in $type?*/}}
		{{ else if ne $type "multiple" }}
			Please fix the `poll create` Custom Command in the control pannel, an invalid poll type has been set has the default in the configuration values.
			{{ deleteResponse 5 }}
		{{ end }}
	{{ end }}
{{ end }}
