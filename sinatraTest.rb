require "sinatra"
require "haml"
require "net/telnet"


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
	webserver = Net::Telnet::new('Host' => '10.0.1.9', 'Port' => 50000, 'Wait-time' => 0.5, 'Prompt' => /.*/, 'Telnet-mode' => false)
	@volUp = params[:volUp]
	@next = params[:next]
	@play = params[:play]
	if @volUp == "Down"
		webserver.cmd("@MAIN:VOL=Down 5 dB")
	elsif @volUp == "Up"
		webserver.cmd("@MAIN:VOL=Up 5 dB") 
	elsif @next == "next"
		`echo n > $HOME/.config/pianobar/ctl`
	end

	if @play == "play"
		if pgrep_wrap("pianobar")
			`echo p > $HOME/.config/pianobar/ctl`
		else
		`pianobar`
		delay 3
		haml :pidora
		end
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
	<meta http-equiv="refresh" content="10" >
%h1{:style => "color:silver;font-size:600%;"} π-Tunes
%form(action='/pidora' method='POST')
	%h3
	%input(type='submit' name='volUp' value="Down")
	%input(type='submit' name='volUp' value="Up")
	%input(type='submit' name='next' value="next")
	%input(type='submit' name='play' value="play")
%html
	%h1
		<iframe src="song.html" frameborder="5" width="180" height="50" align="middle" style="background-color: silver;color: #FFFFFF"></iframe>
<img src="art.jpg" width="600" height="600" align="middle"/>

