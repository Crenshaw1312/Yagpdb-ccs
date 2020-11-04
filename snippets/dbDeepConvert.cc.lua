{{ define "standardize" }}
    {{ $kind := kindOf .Value true }}
    {{ $typ := printf "%T" .Value }}
    {{ $arg := sdict }}
    {{ $result := "" }}

    {{ if and (eq $kind "map") (not (eq $typ "templates.Dict" "templates.SDict")) }}
        {{ $result = dict }}
        {{ range $k, $v := .Value }} {{ $result.Set $k $v }} {{ end }}
    {{ else if and (eq $kind "array" "slice") (ne $typ "templates.Slice") }}
        {{ $result = cslice.AppendSlice .Value }}
    {{ else if eq $typ "templates.Dict" "templates.SDict" "templates.Slice" }}
      {{ $result = .Value }}
    {{ end }}

    {{ if print $result }}
        {{ range $k, $v := $result }}
            {{ $kind := kindOf $v true }}
            {{ if eq $kind "array" "slice" "map" }}
                {{ $arg.Set "Value" $v }}
                {{ template "standardize" $arg }}
                {{ $result.Set $k $arg.Result }}
            {{ end }}
        {{ end }}
    {{ else }} {{ $result = .Value }} {{ end }}

    {{ .Set "Result" $result }}
{{ end }}
