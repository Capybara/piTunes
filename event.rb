#!/usr/bin/ruby
#event-command script based on this post: http://francojc.wordpress.com/2011/12/03/pianobar-on-mac-osx/
trigger = ARGV.shift

if trigger == 'songstart'
songinfo = {}

STDIN.each_line { |line| songinfo.store(*line.chomp.split('=',2))}
`rm ~/Ruby/sinPan/public/*.* 2> /dev/null`
`wget -q --directory-prefix=$HOME/Ruby/sinPan/public/ "#{songinfo['coverArt']}"`
img=`ls $HOME/Ruby/sinPan/public/`
`mv $HOME/Ruby/sinPan/public/*.jpg $HOME/Ruby/sinPan/public/art.jpg`
title=songinfo['title']
artist=songinfo['artist']
`echo "<link href="txtstyle.css" rel="stylesheet" type="text/css" />" > $HOME/Ruby/sinPan/public/song.html`
`echo "#{title} by #{artist}" >> $HOME/Ruby/sinPan/public/song.html`
@songInfo="#{songinfo['title']}\nby #{songinfo['artist']}"
end

