{{/*
Made by: Crenshaw#1312

How-to: scroll down in the starboard CC til you find this:
             {{/* Twitter Plugin Start*/}}
             {{/* Twitter Plugin End*/}}
place the code below between the comments
look at the README.md in this folder for more
*/}}
			{{ if ($p := reFind `https?://twitter\.com/.+/status/\d+(?:\s)?` (toString $.ReactionMessage.Content)) }}
				{{ if (eq .Footer.IconURL "https://abs.twimg.com/icons/apple-touch-icon-192x192.png") }}
					{{ $likes := "N/A" }} {{ $reposts := "N/A" }} {{ $description := .Description }}
					{{ if ge (len .Fields) 1 }} {{ $likes = (index .Fields (sub (len .Fields) 1)).Value }} {{ end }}
					{{ if ge (len .Fields) 2 }} {{ $reposts = (index .Fields (sub (len .Fields) 2)).Value }} {{ end }}
					{{ range (reFindAll `\#\w+` .Description) }}
						{{ $embed.Set "Description" (reReplace . $description (print "[" . "](" (print "https://twitter.com/hashtag/" (slice . 1)) ")")) }}
						{{ $description = $embed.Description }}
					{{ end }}
					{{ $embed = sdict
    					"Author" $embed.Author
  					"Title" (print "Twitter\n" .Author.Name )
  					"URL" $p
 					"Thumbnail" (sdict "URL" .Footer.IconURL)
  					"Description" $embed.Description
					"Image" (or .Image .Thumbnail)
    					"Color" (or $color .Color)
    					"Footer" .Footer
    					"Timestamp" .Timestamp
    					"Fields" ($embed.Fields.Append (sdict
					  "Name" "Twitter"
                            		  "Value" (print "**Likes: " $likes "**\n**Reposts: " $reposts "**\n**Avatar: [Link](" .Author.IconURL ")**")
					  "Inline" true
					 )) 
					}}
				{{ end }}
			{{ end }}
