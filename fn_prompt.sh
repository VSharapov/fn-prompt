#!/bin/bash

#notify-send "Fn"
#set -x

lock_file="${HOME}/.fn_prompt"
resp_file="${HOME}/.fn_response"
for i in $lock_file $resp_file; do
	touch $i;
done

initial_value="$(cat $lock_file)"

if [ "$initial_value" == "0" ]; then
	echo "1" > $lock_file
	sleep 1
	new_value="$(cat $lock_file)"
	if [ $new_value == "1" ]; then
		echo 0 > $lock_file
	fi
fi

if [ "$initial_value" == "1" ]; then
	echo 2 > $lock_file
	if [ -e $resp_file ]; then rm $resp_file; fi
	# TODO: The next line does not block sometimes (for example if a 't' is open) and everything after it doesn't get run
	xterm -e bash -c "echo 'Enter command'; read -n 1 -t 3 && echo \$REPLY > $resp_file"
	command="$(if [ -e $resp_file ]; then cat $resp_file; fi)"
	#notify-send "$(cat $resp_file)"
	new_value="$(cat $lock_file)"
	if [ $new_value == "2" ]; then
		echo 0 > $lock_file
	fi
fi

###
case "$command" in
#	"a")
#		eog -f "${HOME}/Desktop/test/afk.png" &
#		;;
	"b")
		sleep 1; xset dpms force off &
		;;
	"d")
		~/Downloads/DiscordPTB/DiscordPTB &
		;;
	"e")
		gedit "$0" &
		;;
	"h")
		echo -e "connect 88:D0:39:6F:81:40" | bluetoothctl
		echo -e "connect FC:58:FA:F5:89:84" | bluetoothctl
		# firefox "https://news.ycombinator.com/" &
		;;
#	"j")
#		vlc /home/vasiliy/Music/playlist.xspf &
#		;;
#	"o")
#		otp.py &
#		;;
#	"p")
#		notify-send "$(otp.py)" &
#		;;
	"s")
		killall totem-audio-preview
		killall festival
		killall espeak
		killall aplay
		killall play
		;;
	"t")
		gnome-terminal --maximize --hide-menubar &
		;;
	"x")
		for i in {1..100}; do xte 'usleep 100000'; xte 'mouseclick 1'; done
#		for i in {1..100}; do xte 'usleep 6000'; xte 'mouseclick 1'; done
		;;
	"Z")
		xte 'mousemove 700 700'
		xte 'usleep 1900000'
		xte 'mousemove 1220 460'
		xte 'mouseclick 1'
		xte 'usleep 100000'
		xte 'mousemove 1275 555'
		xte 'mouseclick 1'
		xte 'usleep 200000'
		xte 'mouseclick 1'
		xte 'usleep 200000'
		xte 'mouseclick 1'
		xte 'usleep 200000'
		xte 'mouseclick 1'
		;;
esac

