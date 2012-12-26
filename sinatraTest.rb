require "sinatra"
require "haml"
require "net/telnet"
get '/' do 
	haml :index
end

get '/pidora' do
	haml :pidora
end

post '/pidora' do
webserver = Net::Telnet::new('Host' => '10.0.1.9', 'Port' => 50000, 'Wait-time' => 0.5, 'Prompt' => /.*/, 'Telnet-mode' => false)
	@volUp = params[:volUp]
	if @volUp == "Down"
		webserver.cmd("@MAIN:VOL=Down 5 dB")
	elsif @volUp == "Up"
		webserver.cmd("@MAIN:VOL=Up 5 dB") 
	end
	haml :pidora
	puts @volUp
	puts @webserver
	haml :pidora
	@song=`cat song.txt`
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
%h1{:style => "color:white"} piTunes
%form(action='/pidora' method='POST')
	%h3
	%input(type='submit' name='volUp' value="Vol Down")
	%input(type='submit' name='volUp' value="Vol Up")
%html
	%h1
		<iframe src="song.html" width="180" height="50" align="middle" style="background-color: silver"></iframe>
<img src="art.jpg" width="600" height="600" align="middle"/>

