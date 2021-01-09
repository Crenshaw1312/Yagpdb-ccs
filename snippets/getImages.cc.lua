{{/*
Made by: Crenshaw#1312

Note: Scrapes all images from attachments and links, and adds it to a given embed with it's own field if there is more then one image.
      -They are linked and are displayed by the file name and the file type `FileName.Type` ex: example.png, this is linked to the image

Note: The emebed MUST have one field before it and the, you can try editing this in lines 29-35 (On Github)
      
Note: I'm not sure if this actually works, I did some editing so it'd work as a snippit, but I'm fairly sure it'll work
*/}}
  
  {{ $filegex := `https?://(?:\w+\.)?[\w-]+\.[\w]{2,3}(?:\/[\w-_.]+)+\.(png|jpe?g|gif|webp|mp4|mkv|mov|wav)` }}
  {{ $embed := sdict "Fields" (cslice (sdict "name" "wow look at that" "value" "totally useless" "inline" true)) }}
  {{ $attachLinks := cslice }}
  
	{{ range .ReactionMessage.Attachments }}
    {{- if reFind $filegex .URL -}}
       {{ $attachLinks = $attachLinks.Append .URL }}
    {{ end }}
	{{ end }}
	{{ $links := reFindAll $filegex .ReactionMessage.Content }}
	{{ $links = $attachLinks.AppendSlice $links }}
	{{ range $i,$v := $links }}
		{{ $name := reFind `/[^/]+$` $v }} {{ $name = slice $name 1 }}
		{{ if reFind `(?:png|jpg|jpeg|gif|webp|tif)$` $v }}
			{{ $embed.Set "Image" (sdict "url" $v) }}
		{{ end }}
		{{ $val := print (add $i 1) " **»** [" $name "](" $v ")" }}
		{{ if eq 2 (len $embed.Fields) }}
			{{ (index $embed.Fields 1).Set "Value" (print (index $embed.Fields 1).Value "\n" $val) }}
		{{ else }}
			{{ $embed.Set "Fields" ($embed.Fields.Append 
				(sdict "Name" "Attachments" "Value" $val "Inline" false)
			) }}
		{{ end }}
	{{ end }}
