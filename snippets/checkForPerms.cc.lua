{{/*Usage, put the number of permission you want to check for the user under "perm"
1 | CREATE_INSTANT_INVITE
2 | KICK_MEMBERS
3 | BAN_MEMBERS
4 | ADMINISTRATOR
5 | MANAGE_CHANNELS
6 | MANAGE_GUILD
7 | ADD_REACTIONS
8 | VIEW_AUDIT_LOG
9 | PRIORITY_SPEAKER
10 | STREAM
11 | VIEW_CHANNEL
12 | SEND_MESSAGES
13 | SEND_TTS_MESSAGES
14 | MANAGE_MESSAGES
15 | EMBED_LINKS
16 | ATTACH_FILES
17 | READ_MESSAGE_HISTORY
18 | MENTION_EVERYONE
19 | USE_EXTERNAL_EMOJIS
20 | VIEW_GUILD_INSIGHTS
21 | CONNECT
22 | SPEAK
23 | MUTE_MEMBERS
24 | DEAFEN_MEMBERS
25 | MOVE_MEMBERS
26 | USE_VAD
27 | CHANGE_NICKNAME
28 | MANAGE_NICKNAMES
29 | MANAGE_ROLES
30 | MANAGE_WEBHOOKS
31 | MANAGE_EMOJIS
*/}}

{{define "checkUserGlobalPerm"}}
     {{.Set "ret" 0}}
     {{range .groles}}
          {{- if in $.mroles .ID}}
               {{- $bitset := (printf "%b" .Permissions)}}
               {{- if gt (len $bitset) $.perm}}
                    {{- if eq (slice $bitset (sub (len $bitset) $.perm) (sub (len $bitset) (sub $.perm 1))) "1"}}{{$.Set "ret" 1}}{{end}}
               {{- end}}
          {{- end}}
     {{- end}}
{{end}}

{{template "checkUserGlobalPerm" ($x:= sdict "groles" .Guild.Roles "mroles" .Member.Roles "perm" 6)}}
{{$x.ret}}
