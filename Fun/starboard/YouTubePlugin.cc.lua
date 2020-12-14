{{/*
Made by: Crenshaw#1312

How-to: scroll down in the starboard CC til you find this (towards bottom):
             {{/* YoutTube Plugin Start*/}}
             {{/* YouTube Plugin End*/}}
place the code below between the comments
look at the README.md in this folder for more

Note: You can delete line 18 (on GitHub) to remove description to make it slimmer
*/}}

{{ if .Provider }}
	{{ if eq .Provider.Name "YouTube" }}
		{{ $embed = sdict
			  "Author" $embed.Author
  			"Title" (print "YouTube" "\n" .Title)
        "Description" .Description
  			"URL" .URL
  			"Thumbnail" (sdict "URL" "https://www.shareicon.net/data/2015/09/30/109355_media_512x512.png")
  			"Image" .Thumbnail
  			"Timestamp" $embed.Timestamp
  			"Footer" (sdict "icon_url" "https://www.shareicon.net/data/2015/09/30/109355_media_512x512.png" "text" "YouTube")
          	"Color" (or $color .Color)
          	"Fields" ($embed.Fields.Append (sdict 
             	"Name" "YouTube"
               	"Value" (print "**Creator: [" .Author.Name "](" .Author.URL ")**\n**Full Tab: [Link](" .Video.URL ")**")
                "Inline" true
            ))
 		}}
	{{ end }}
{{ end }}
