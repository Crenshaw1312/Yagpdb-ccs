# Starboard plugins
Starboard works fine without the plugins, there's GitHub, Twitter, and YouTube.

_but it's so much better_

Please know, that these plugins only work with my starboard system.

## Custom/Contributing
So, if you know what you're doing here's a short explanation and requirements if you want to make your own, or PR one.

Format:
```
{{ if condition(s) }} {{/* To make sure it's the right thing*/}}
{{/* Below is where you can customize*/}}
    {{ $emebd = sdict
    "Stuff"
    }}
{{ end }}
```
Notes:
- `$embed` variable is what the starboard would've been without the plugin
- `.` is the first embed of the message.

Required:
- `"Fields" $embed.Fields` Use .Append for more fields
- `"Author" $embed.Author` The author should always be whomever posted
- `"Color" (or $color <other color>)` I don't care what you do with <other color>, just make sure it defaults to the config color.

## GitHub
There is a few different versions of it, I suggest trying it for yourself, it doesn't do much but it makes it look a lot nicer, I suggest adding it.
It supports, profiles, webhook posts, files, as long as it is done via link.

## Twitter
![Tiwitter Plugin](https://i.ibb.co/5RgLj7Z/Twitter-Plugin.png)

## YouTube
![url=https://imgbb.com/](https://i.ibb.co/Hns7121/with-YT-plugin.png)
![url=https://imgbb.com/](https://i.ibb.co/LdBpxSN/Without-YT-plug.png)
