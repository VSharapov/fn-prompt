#!/bin/bash

#notify-send "Fn"
#set -x
# Useful for debugging: 
#     while true; do date +"%s.%N `cat ~/.fn_prompt`"; sleep 0.02 ; done

# Should these live in /tmp ? ... dunno
lock_file="${HOME}/.fn_prompt"
resp_file="${HOME}/.fn_response"
for i in $lock_file $resp_file; do
	touch $i;
done

# How fast you must hit Fn twice - `man sleep` says:
#     "NUMBER need not be an integer." - try 0.3 =)
fn_wait=1
# xTerm will stay open listening for input this long: (try 1 instead)
in_wait=3

# Explanation of lock_file magic values:
#     0 - Fn has NOT been pressed recently
#     1 - Fn HAS been pressed recently
#     2 - xTerm is open, waiting for a command
initial_value="$(cat $lock_file)"

# From 0 to 1...
if [ "$initial_value" == "0" ]; then
	echo "1" > $lock_file
	sleep $fn_wait
	# ... and if it's still 1, back to 0
	new_value="$(cat $lock_file)"
	if [ $new_value == "1" ]; then
		echo 0 > $lock_file
	fi
fi

# From 1 to 2...
if [ "$initial_value" == "1" ]; then
	echo 2 > $lock_file
	if [ -e $resp_file ]; then rm $resp_file; fi
	# TODO: The next line does not block sometimes (for example if a 't' is open) and everything after it doesn't get run
	# TODO: Wait... I don't think this ^^^ is true.
	xterm -e bash -c "echo 'Enter command'; read -n 1 -t $in_wait && echo \$REPLY > $resp_file"
	command="$(if [ -e $resp_file ]; then cat $resp_file; fi)"
	#notify-send "$(cat $resp_file)"
	# ... and hopefully this is always true
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
		# Blank screen
		sleep 1; xset dpms force off &
		;;
	"d")
		~/Downloads/DiscordPTB/DiscordPTB &
		;;
	"e")
		# Edit this file
		gedit "$0" &
		;;
	"h")
		# Headphones
		echo -e "connect 88:D0:39:6F:81:40" | bluetoothctl
		echo -e "connect FC:58:FA:F5:89:84" | bluetoothctl
		# # Hacker news
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
		# SILENCE!
		killall totem-audio-preview
		killall festival
		killall espeak
		killall aplay
		killall play
		;;
	"t")
		# Bigterm
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

