{{/*
  Gets an array of all roles a user has (as role object, not ID)
*/}}

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
