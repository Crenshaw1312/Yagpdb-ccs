{{/*Made by Crenshaw#7860
This is referneced in the reaction-ttt command please edit accordingly*/}}
{{if eq .ExecData "1️⃣"}}
	{{dbSetExpire 0 "letnum" "1" 10}}
{{else if eq .ExecData "2️⃣"}}
	{{dbSetExpire 0 "letnum" "2" 10}}
{{else if eq .ExecData "3️⃣"}}
	{{dbSetExpire 0 "letnum" "3" 10}}
{{else if eq .ExecData "4️⃣"}}
	{{dbSetExpire 0 "letnum" "4" 10}}
{{else if eq .ExecData "5️⃣"}}
	{{dbSetExpire 0 "letnum" "5" 10}}
{{else if eq .ExecData "6️⃣"}}
	{{dbSetExpire 0 "letnum" "6" 10}}
{{else if eq .ExecData "7️⃣"}}
	{{dbSetExpire 0 "letnum" "7" 10}}
{{else if eq .ExecData "8️⃣"}}
	{{dbSetExpire 0 "letnum" "8" 10}}
{{else if eq .ExecData "9️⃣"}}
	{{dbSetExpire 0 "letnum" "9" 10}}
{{end}}
