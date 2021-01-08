{{/*
Trigger Type: Regex
Trigger: \A-(cl(one)?|s(wap)?|m(ove)?|st(eal)?|me(rge)?)?roles

Note* change the `-` at the begining of the regex to your prefix

Usage:
`mergeroles`/`meroles` Take all of both member's roles and give each members those roles.
`swaproles`/`sroles` Swap the roles of two members.
`stealroles`/`stroles` Given the roles in the first member, take those roles away from the second member.
`moveroles`/`mroles` Take the roles from the first member and give them to the second member.
*/}}

{{ if eq (len .CmdArgs) 2 }}
{{ $user1 := getMember (userArg (index .CmdArgs 0)) }}
{{ $user2 := getMember (userArg (index .CmdArgs 1)) }}
    {{ $list1 := $user1.Roles }} {{ $user1 := $user1.User }}
	{{ $list2 := $user2.Roles }} {{ $user2 := $user2.User}}
	{{- $cmd := reReplace `\A-` .Cmd "" -}}
	{{ if eq $cmd "cloneroles" "clroles" }}
		{{ range $list2 }}
			{{ takeRoleID $user2.ID . 0 }}
		{{ end }}
		{{ range $list1 }}
			{{ giveRoleID $user2.ID . }} 
		{{ end }}
		Successfully cloned the roles from **{{ $user1.Username }}** to **{{ $user2.Username }}**
	{{ else if eq $cmd "swaproles" "sroles" }}
		{{ range $list2 }}
			{{ takeRoleID $user2.ID . 0 }}
			{{ giveRoleID $user1.ID . }} 
		{{ end }}
		{{ range $list1 }}
			{{ giveRoleID $user2.ID . }}
			{{ takeRoleID $user1.ID . 0 }}
		{{ end }}
		Successfully swapped the roles between **{{ $user1.Username }}** and **{{ $user2.Username }}**
	{{ else if eq $cmd "moveroles" "mroles" }}
		{{ range $list1 }}
			{{ giveRoleID $user2.ID . }} 
		{{ end }}
		Successfully moved/added the roles from **{{ $user1.Username }}** to **{{ $user2.Username }}**
	{{ else if eq $cmd "stealroles" "stroles" }}
		{{ range $list1 }}
			{{ takeRoleID $user2.ID . }}
		{{ end }}
		Successfully stole/took the roles on **{{ $user1.Username }}** from **{{ $user2.Username }}**
	{{ else if eq $cmd "mergeroles" "meroles" }}
		{{ range $list1 }}
			{{ giveRoleID $user2.ID . }}
			{{ giveRoleID $user1.ID . }}
		{{ end }}
		{{ range $list2 }}
			{{ giveRoleID $user2.ID . }}
			{{ giveRoleID $user1.ID . }}
		{{ end }}
 		Successfully merged the roles between **{{ $user1.Username }}** and **{{ $user2.Username }}**
	{{ end }}
{{ else }}
{{ sendMessage nil (cembed
	"Title" "Role Manipulation"
	"Description" (joinStr "\n\n"
		"Every command needs two user mentions.\n`cloneroles`/`clroles` take one member's roles and set them equal to the other."
		"`mergeroles`/`meroles` Take all of both member's roles and give each members those roles."
		"`swaproles`/`sroles` Swap the roles of two members."
		"`stealroles`/`stroles` Given the roles in the first member, take those roles away from the second member."
		"`moveroles`/`mroles` Take the roles from the first member and give them to the second member."
	)
	"color" 0x4B0082
) }}
{{ end }}
