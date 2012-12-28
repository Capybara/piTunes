require "sinatra"
require "haml"
require "net/telnet"


@s = 12
def pgrep_wrap(process)
	pid = `pgrep -if #{process}`
	if pid.strip.to_i > 0
		return true
	else
		return false
	end
end


get '/' do 
	haml :index
end

get '/pidora' do
	haml :pidora
end

post '/pidora' do
	@s=`cat $HOME/Ruby/sinPan/station.txt`
	@s=@s.to_i
	@volUp = params[:volUp]
	@quit = params[:quit]
	@next = params[:next]
	@play = params[:play]
	@NS = params[:NS]
	if @volUp == "Down"
		webserver = Net::Telnet::new('Host' => '10.0.1.9', 'Port' => 50000, 'Wait-time' => 0.2, 'Prompt' => /.*/, 'Telnet-mode' => false, 'Timeout' => 0.5)
		webserver.cmd("@MAIN:VOL=Down 5 dB")
	elsif @volUp == "Up"
		webserver = Net::Telnet::new('Host' => '10.0.1.9', 'Port' => 50000, 'Wait-time' => 0.2, 'Prompt' => /.*/, 'Telnet-mode' => false, 'Timeout' => 0.5)
		webserver.cmd("@MAIN:VOL=Up 5 dB") 
	elsif @next == "next"
		`echo -n "n" > $HOME/.config/pianobar/ctl`
	elsif @quit == "quit"
		`echo -n "q" > $HOME/.config/pianobar/ctl`
	elsif @NS == "NS"
		if @s < 26
			@s+=1
		else
			@s=1
		end
		`echo s#{@s} > $HOME/.config/pianobar/ctl`
		`echo #{@s} > $HOME/Ruby/sinPan/station.txt`
	end

	if @play == "play"
			`echo -n "p" > $HOME/.config/pianobar/ctl`
			haml :pidora
		# added else `pianobar` but would make it freeze on execution
	end
haml :pidora
end
__END__
%html
	%head
	%title Pidora 
	%body
		#header
		%h1  Pidora av
		#content
		=yield
	%footer
		%a(href='/') Back to index
@@ index
%html
	%head
	%p{:style => "color:red"}
%ul
	%li
		%a(href='/pidora') Pidora
@@ pidora
%html{:style => "background-color:green;text-align:center"}
%head
-#	<meta http-equiv="refresh" content="15" >
%h1{:style => "color:silver;font-size:600%;"} π-Tunes
%form(action='/pidora' method='POST')
	%h3{:style => "background-color:silver"}
	%input(STYLE="background-color:silver" type='submit' name='volUp' value="Down")
	%input(STYLE="background-color:silver" type='submit' name='volUp' value="Up")
	%input(STYLE="background-color:silver" type='submit' name='next' value="next")
	%input(STYLE="background-color:silver" type='submit' name='play' value="play")
	%input(STYLE="background-color:silver" type='submit' name='quit' value="quit")
	%input(STYLE="background-color:silver" type='submit' name='NS' value="NS")
%html
	%h1{:style => "color:silver;font-size:200%;"}
		<meta http-equiv="refresh" content="5" >
		= `cat $HOME/Ruby/sinPan/public/song.html`
		<txt src="song.html" frameborder="5" width="180" height="50" align="middle" style="background-color: silver;color: #FFFFFF"></txt>
<img src="art.jpg" width="600" height="600" align="middle"/>

