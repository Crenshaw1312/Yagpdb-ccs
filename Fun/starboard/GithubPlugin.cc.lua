{{/*
Made by: Crenshaw#1312

How-to: scroll down in the starboard CC til you find this (towards bottom):
             {{/* Github Plugin Start*/}}
             {{/* Github Plugin End*/}}
place the code below between the comments
look at the README.md in this folder for more

Note: You can delete line 17 ("Thumbnail...) if you don't want github pfp to show.
*/}}

    {{ $pfp := $.ReactionMessage.Author.AvatarURL "256" }}
		{{ if eq $.ReactionMessage.Author.Avatar "df91181b3f1cf0ef1592fbe18e0962d7" }}
			{{ $embed = sdict
    	  "Author" .Author
        "Thumbnail" (sdict "url" $pfp)
				"Title" .Title
				"Description" .Description
 	 			"Fields" $embed.Fields
        "Timestamp" (or .Timestamp $embed.Timestamp currentTime )
				"Footer" (sdict "icon_url" $pfp "Text" "Github")
				"Color" (or $color .Color)
			}}
		{{ else if and (eq .Provider.Name "GitHub") (ge .Thumbnail.Width 500) (ge .Thumbnail.Width 250) }}
			{{ $embed.Set "Image" .Thumbnail }}
			{{ $embed.Del "Thumbnail" }}
		{{ end }}
