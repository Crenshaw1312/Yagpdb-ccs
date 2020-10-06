{{/*THis is the Games one*/}}{{/*THis is the Games one*/}}
{{/*THis is the Games one*/}}{{/*THis is the Games one*/}}
{{if .ReactionMessage.Embeds}}
{{$x := (index .ReactionMessage.Embeds 0)}}
{{if and (eq $x.Title "Games") (eq (userArg .ReactionMessage.Author).ID 204255221017214977)}}
{{/*For 1 or General*/}}
     {{if ge ((index .ReactionMessage.Reactions 0).Count) 2}}
           {{$e := cembed
           "title" (title "Games-General")
           "description" (joinStr "" "https://fitgirl-repacks.site/ -these repacks are hihgly compressed however they take several hours to install. These games are mostly for people with slower internet connections.\nhttps://cs.rin.ru/forum/viewforum.php?f=10 -arguably the best cracked games forum.\nhttps://rarbg.to/ -once more, RARBG is on this list and for good reason. They have scene releases on the tracker.\nhttps://www.gamestorrents.io/ -like the url, it has good games torrents.\nhttp://rutor.info/games -this is a Russian repack site. I recommend using Google Translate to browse the games.\nhttp://www.ovagames.com/ and https://scnlog.me/ are good for scene releases.\nhttps://gamecopyworld.com/games/index.php - good website for cheats and standalone cracks.")}}
                          {{editMessage nil .ReactionMessage.ID $e}}
          {{end}}
{{/*For 2 or Android/ios*/}}
     {{if ge ((index .ReactionMessage.Reactions 1).Count) 2}}
          {{$e := cembed
          "title" (title "Games-Android/IOS")
          "description" (joinStr "" "https://forum.mobilism.org/index.php is a fantastic site for mobile cracked games.\nhttps://www.iphonecake.com/ is good for iOS cracks.")}}
               {{editMessage nil .ReactionMessage.ID $e}}
               {{end}}
{{/*For 3 or Bad sites*/}}
     {{if ge ((index .ReactionMessage.Reactions 2).Count) 2}}
          {{$e := cembed
          "title" (title "Games-Bad Sites")
          "description" (joinStr "" "IGG-GAMES- They steal other releases and inject ads into the games and their website. They even caused one of the best games trackers to go down because of their retardedness.\nCorepack- they inject malware into stolen releases.\nOceanOfGames- once more, silly kids have injected malware into games.\nDISCLAIMER- no scene group(like Codex, CPY-Games, or Skidrow) will have their own website and any website claiming to be, know or have access to a scene group is a big scam.")}}
               {{editMessage nil .ReactionMessage.ID $e}}
      {{end}}
{{end}}
{{/*This is for Books*/}}{{/*This is for Books*/}}
{{/*This is for Books*/}}{{/*This is for Books*/}}
{{if and (eq $x.Title "Books") (eq (userArg .ReactionMessage.Author).ID 204255221017214977)}}
{{/*For 1 or eBooks*/}}
     {{if ge ((index .ReactionMessage.Reactions 0).Count) 2}}
           {{$e := cembed
           "title" (title "Books-eBooks")
           "description" (joinStr "" "https://b-ok.cc/\nhttps://b-ok.org/\nhttps://libgen.is/\nhttps://the-eye.eu/public/Books/\nhttp://gen.lib.rus.ec/\nhttps://www.gutenberg.org/ -for your classics.\nhttps://sci-hub.tw/ - for scientific papers\nhttps://forum.mobilism.org/viewforum.php?f=106 - good for requesting ebooks.")}}
                          {{editMessage nil .ReactionMessage.ID $e}}
          {{end}}
{{/*For 2 or audioBooks*/}}
     {{if ge ((index .ReactionMessage.Reactions 1).Count) 2}}
           {{$e := cembed
           "title" (title "Books-audioBooks")
           "description" (joinStr "" "http://audiobookbay.nl/\nhttps://the-eye.eu/public/AudioBooks/\nhttps://librivox.org/\nhttps://audiobooks.cloud/")}}
                          {{editMessage nil .ReactionMessage.ID $e}}
          {{end}}
{{/*For 3 or Manga*/}}
     {{if ge ((index .ReactionMessage.Reactions 2).Count) 2}}
           {{$e := cembed
           "title" (title "Books-Manga")
           "description" (joinStr "" "https://mangadex.org/\nhttps://wuxiaworld.site/\nhttp://kissmanga.com/\nhttps://mangaplus.shueisha.co.jp/\nhttps://comix-load.in/\nhttps://manga.fascans.com/\nhttps://fanfox.net/\nhttps://www.viz.com/ (It only has the 3 latest chapters)")}}
                          {{editMessage nil .ReactionMessage.ID $e}}
          {{end}}
{{/*For 4 or Comics*/}}
     {{if ge ((index .ReactionMessage.Reactions 3).Count) 2}}
           {{$e := cembed
           "title" (title "Books-Comics")
           "description" (joinStr "" "http://getcomics.info/\nhttps://www.comicextra.com/\nhttps://readcomiconline.to/\nhttps://readcomicbooksonline.net/\nhttps://comix-load.in/")}}
                          {{editMessage nil .ReactionMessage.ID $e}}
          {{end}}
{{/*For 5 or Magazines*/}}
     {{if ge ((index .ReactionMessage.Reactions 4).Count) 2}}
           {{$e := cembed
           "title" (title "Books-Magazines")
           "description" (joinStr "" "http://pdf-giant.com/\nhttps://magazinelib.com/\nhttps://magazinesdownload.org/ - magazines hosted on free, fast, file hosting sites.\nhttp://ebook3000.com/")}}
                          {{editMessage nil .ReactionMessage.ID $e}}
          {{end}}
{{end}}
{{/*for Movies and TV*/}}{{/*for Movies and TV*/}}
{{/*for Movies and TV*/}}{{/*for Movies and TV*/}}
{{if and (eq $x.Title "Movies And TV") (eq (userArg .ReactionMessage.Author).ID 204255221017214977)}}
{{/*For 1 or DDL and Torrent*/}}
     {{if ge ((index .ReactionMessage.Reactions 0).Count) 2}}
           {{$e := cembed
           "title" (title "Movies and TV-DDl And Torrents")
           "description" (joinStr "" "https://1337x.to/ - this is good for movies and TV shows and is also one of the best all-round trackers\nhttps://rarbg.to/ - very organised tracker and you can search by IMDB tags.\nhttps://rutracker.org/ - good for niche movies and is a very good tracker.\nhttps://eztv.io/ - tv shows are uploaded very quickly.\nhttps://hevcbay.com/ - tiny-sized x265 encodes.\nhttp://snahp.it/\nhttps://torrentgalaxy.to/\nhttps://www.ettv.to/home/\nhttp://psarips.com/\nhttps://gdrivedl.xyz/\nhttps://megaddl.co/movies - Mega DDL links.\nhttps://moviefiles.org/ -google drive download links so VPN is not necessarily needed.")}}
                          {{editMessage nil .ReactionMessage.ID $e}}
          {{end}}
{{/*For 2 or Streaming*/}}
     {{if ge ((index .ReactionMessage.Reactions 1).Count) 2}}
           {{$e := cembed
           "title" (title "Movies and TV-Streaming")
           "description" (joinStr "" "https://www3.fmovies.to/\nhttps://www.himovies.to/\nhttps://www.soap2day.com/\nhttps://yesmovies.ag/")}}
                          {{editMessage nil .ReactionMessage.ID $e}}
          {{end}}
{{/*For 3 or Apps*/}}
     {{if ge ((index .ReactionMessage.Reactions 2).Count) 2}}
           {{$e := cembed
           "title" (title "Movies and TV-Apps")
           "description" (joinStr "" "https://beetvapk.net/\nhttps://novatv.app/\nhttps://mediaboxhd.net/- has an iOS and Android version.\nhttps://vivatv.io/\nhttps://www.typhoontv.me/\nhttps://www.morpheustvhd.com/")}}
                          {{editMessage nil .ReactionMessage.ID $e}}
          {{end}}
{{end}}
{{/*For Software*/}}{{/*For Software*/}}{{/*For Software*/}}{{/*For Software*/}}{{/*For Software*/}}
{{/*For Software*/}}{{/*For Software*/}}{{/*For Software*/}}{{/*For Software*/}}{{/*For Software*/}}
{{if and (eq $x.Title "Software") (eq (userArg .ReactionMessage.Author).ID 204255221017214977)}}
{{/*For 1 or Apps*/}}
     {{if ge ((index .ReactionMessage.Reactions 0).Count) 2}}
           {{$e := cembed
           "title" (title "Software-Download Tools")
           "description" (joinStr "" "-Youtube-dl is a fantastic command-line tool for downloading youtube videos. It is currently available on GitHub and has a website. For those who cannot use the command-line there is also a GUI version.\n-SoundCloud Downloader FireFox Extension- this extension downloads music from SoundCloud and is available from this link: https://addons.mozilla.org/en-US/firefox/addon/soundcloud-dl/. Credits go to /u/ImTwain for development.\n-Skillshare-dl is a wonderful tool to download Skillshare Videos. It is available here: https://github.com/mrwnwttk/skillshare-dl.\n-Omnibus is a comic-downloader application which uses the website getcomics.info to get comics. You can download from this GitHub link: https://github.com/fireshaper/Omnibus.\n-Anime-dl is another command-line tool which can download whole seasons and episodes from a range of anime streaming sites. Donwload link: https://github.com/vn-ki/anime-downloader.")}}
                          {{editMessage nil .ReactionMessage.ID $e}}
          {{end}}
{{/*For 2 or Torrent*/}}
     {{if ge ((index .ReactionMessage.Reactions 1).Count) 2}}
           {{$e := cembed
           "title" (title "Software-Download Tools")
           "description" (joinStr "" "http://w13.monkrus.ws/ is a wonderful site for applications like Adobe from a trusted uploader(Monkrus).\nhttps://rarbg.to/ is a good software indexer.\nhttp://rutracker.org/ is a wonderful tracker and is used for video software and plug-ins.\nhttps://www.cgpeers.com/ is great for graphics-related software however it is private.")}}
                          {{editMessage nil .ReactionMessage.ID $e}}
          {{end}}
{{end}}
{{end}}