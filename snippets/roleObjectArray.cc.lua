{{/*
  Gets an array of all roles a user has (as role object, not ID)
  You only need one, use whatever best fits.
*/}}

{{/* BASIC VERSION */}}

{{ $all := (cslice) }}
{{ range .Guild.Roles }}
    {{ $role := . }}
    {{ range $.Member.Roles }}
        {{ if eq $role.ID . }}
            {{ $all = $all.Append $role }}
        {{ end }}
    {{ end }}
{{ end }}
{{ $all }}

{{/*BASIC VERSION END*/}}


{{/* DEFINE VERSION */}}

{{ define "roleArray" }}
	{{ $all := (cslice) }}
	{{ range .Guild.Roles }}
		{{ $role := . }}
		{{ range $.Member.Roles }}
			{{ if eq $role.ID . }}
				{{ $all = $all.Append $role }}
			{{ end }}
		{{ end }}
	{{ end }}
{{ .Set "Result" $all }}
{{ end }}

{{ $data := sdict "Guild" .Guild "Member" .Member }}
{{ template "roleArray" $data }}
{{ $data.Resault }}

{{/*DEFINE VERSION END*/}}
