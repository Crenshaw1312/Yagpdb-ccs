{{/*
Trigger Type: Regex
Trigger: .*

What it does:
Helps with getting a response from a given channel

Programmer Usage:
`{{ dbSet 0 "expecting" (sdict "anything" "CHANNELID") }}`
you can have multiple values in the sdict,
I suggest adding a small delay, so this command can run
*/}}

{{ if (dbGet 0 "expecting").Value }}
	{{ $all := sdict (dbGet 0 "expecting").Value }}
	{{ range $key, $value := $all }}
		{{ if eq (toString .Channel.ID) (reFind `\d{18}` $value) }}
			{{ $all.Set $key .Message.ID }}
		{{ end }}
	{{ end }}
	{{ dbSet 0 "expecting" $all }}
{{ end }}
