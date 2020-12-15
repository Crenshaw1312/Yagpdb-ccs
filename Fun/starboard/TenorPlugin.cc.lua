{{/*
Made by: Crenshaw#1312

Note: This essentially makes it work as it should, displaying gifs and that
Note: GIPHY is a bitch and refuses to give a usable .gif link, so GIPHY will be added later.

How-to: scroll down in the starboard CC til you find this (towards bottom):
                {{/* Giphy/Tenor Plugin Start*/}}
                {{/* Giphy/Tenor Plugin End*/}}
place the code below between the comments
look at the README.md in this folder for more
*/}}

        {{ if .Provider }}
					{{ if eq .Provider.Name "Tenor" }}
						{{ $gem := sendMessageRetID $chan (reReplace "/view/" .URL "/search/") }}
						{{ sleep 3 }}
						{{ if ($_ := (getMessage $chan $gem).Embeds) }}
							{{ with (index $_ 0) }}
								{{ $embed.Set "Image" (sdict "URL" .Thumbnail.ProxyURL) }}
							{{ end }}
						{{ end }}
						{{ deleteMessage $chan $gem 0 }}
					{{ end }}
				{{ end }}
