{{/*
Made by: Crenshaw#1312
Credit: Joe_#0001 for making setRole PR
PR: https://github.com/jonas747/yagpdb/pull/750

Trigger Type: Command
Trigger: setRole

Note: setRole is limited once per CC.

Allows: PAGSTDB only!
*/}}
{{/*Put some role IDs below*/}}
{{ $x := shuffle (cslice 770291866208829470 769321900433473558 769321943547510804 771091923343376426) }}
{{ $x.Del (sub (len $x) 1) }}
{{ range $x }}
    {{ . }}
    {{ setRoles $.User.ID (cslice .) }}
    {{ sleep 1 }}
{{ end }}
done!
