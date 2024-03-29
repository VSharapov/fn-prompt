#!/bin/bash

#notify-send "Fn"
#set -x
# Useful for debugging: 
#     while true; do date +"%s.%N `cat ~/.fnp_*`"; sleep 0.02 ; done

# Should these live in /tmp ? ... dunno
lock_file="${HOME}/.fnp_state"
resp_file="${HOME}/.fnp_response"
for i in $lock_file $resp_file; do
	touch $i;
done

# A terminal which you _don't_ normally use
#     i.e. Running a popup prompt with it won't disrupt anything
popup_term="$(which xterm)"
if [ -z "$popup_term" ]; then exit; fi
additional_popup_term_arguments="-geometry 50x10"
popup_term="${popup_term} ${additional_popup_term_arguments}"
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
if [ "$initial_value" == "" ]; then
	echo "0" > $lock_file
  initial_value="$(cat $lock_file)"
fi

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
	$popup_term -e bash -c "echo 'Enter command'; read -n 1 -t $in_wait && echo \$REPLY > $resp_file"
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
	"C")
		# Play around with night light color temperature in GNOME
		# https://gist.github.com/VSharapov/fc98acdbcb4d6a4f08573fd2708fcfff
		sleep 0.1 # I suspect opening an xTerm as the other is closing
		          #     might be what causes it to sometimes open with
		          #     3x1 dimensions (probably minimum possible), no
		          #     idea why it is so, but this seems to fix it.
		$popup_term -e bash -c 'ANSFILE=$(mktemp)
		TEMPKEY="org.gnome.settings-daemon.plugins.color night-light-temperature"
		while dialog --keep-tite --cancel-label "Done" --ok-label "Apply" \
		             --rangebox "Set color temperature \n 6500 is normal" \
		             0 0 1000 9999 \
		             $(gsettings get $TEMPKEY | cut -d " " -f 2) \
		             2>$ANSFILE
		do
		  gsettings set $TEMPKEY $(cat $ANSFILE)
		done; rm $ANSFILE'
		;;
	"d")
		~/Downloads/DiscordPTB/DiscordPTB &
		;;
	"e")
		# Edit this file
		gedit "$0" &
		;;
	"g")
		# Gif search
		sleep 0.1 # I suspect opening an xTerm as the other is closing
		          #     might be what causes it to sometimes open with
		          #     3x1 dimensions (probably minimum possible), no
		          #     idea why it is so, but this seems to fix it.
		$popup_term -e bash -c 'echo "Search for gif:" && read ;    \
firefox "https://google.com/search?q=${REPLY}&tbm=isch&tbs=itp:animated" ; \
echo Waiting for a new download to appear &&                               \
inotifywait -t 120 -e create -e moved_to ~/Downloads/ ;                    \
nohup nautilus ~/Downloads/ >/dev/null &                                   \
sleep 0.1' # Won't launch nautilus without this delay 🤷
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
	"X")
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
	"Z")
		systemctl suspend
		;;
esac

