if [ "$PS1" ]; then
  if [ "$BASH" ]; then
    PS1='\u@\h:\w\$ '
  else
    if [ "`id -u`" -eq 0 ]; then
    else
      PS1='$ '
    fi
  fi
fi

umask 022


alias lynx='lynx -cfg ~/.lynx.cfg -accept_all_cookies'
alias vi='vim'
alias whois='whois -h whois.geektools.com'
alias aslook='whois -a -h whois.radb.net'
alias cal='cal() { m=$1; y=$2; if [ "x$m" != "x" ]; then if  [ "x$y" != "x" ]; then if [ $m -gt 12 ]; then m=$2; y=$1; fi; fi; fi; ccal -col=/home/andy/.calcol $m $y; }; cal'
alias syncalmond='echo use syncman'
alias syncpecan='echo use syncmac'
alias syncmac='pgrep skype >/dev/null || rsync --exclude-from /home/andy/files/etc/syncmac-excludes.txt -auvPz macadamia.milky.org.uk:{bin,files,mail,.gnupg,.centerim,.dates,.Skype*,.local} ~'
alias gpgd='gpg -d ~/files/txt/stuff.gpg | grep "$@"'
alias washing='countdown $((34 * 60 ))'
alias drying='countdown $((62 * 60 ))'


export PATH=~/bin:$PATH
alias countdown='countdown() { COUNTDOWNLENGTH=$1; while test $COUNTDOWNLENGTH -gt 0; do echo -n "$COUNTDOWNLENGTH "; COUNTDOWNLENGTH=$[ $COUNTDOWNLENGTH - 1 ]; sleep 1; done; echo ""; }; countdown'
alias countup='N=-1; while :; do N=$[ $N + 1 ]; echo -n "$N "; sleep 1; done; countup'
alias flac_to_cdr='OUT=/home/andy/cdr_out; mkdir $OUT; A=0; FILENAME=playlist.txt; while read x ; do A=$[ $A + 1 ];printf -v B "%02d" $A; flac -d $x -o $OUT/$x.wav; mv $OUT/$x.wav $OUT/track_$B.wav; done <$FILENAME'
alias rip_and_flac='cdparanoia -B -d /dev/dvd && eject dvd && flacenc && rm *wav'
alias add_flac_img='metaflac --import-picture-from="3|image/jpeg|cover||a.jpg" *flac && metaflac --add-replay-gain *flac'
alias replace_flac_img='metaflac --remove --dont-use-padding --block-type=PICTURE *flac && metaflac --import-picture-from="3|image/jpeg|cover||a.jpg" --dont-use-padding *flac'
alias test_flacs='OK=1; for i in `find . -name "*flac"`; do  if [ $OK -eq 1 ]; then echo -n $i; flac -t $i >/dev/null 2>/dev/null;  if [ $? -eq 0 ]; then echo " - OK"; else echo " - NOT OK"; OK=0; fi; fi; done'

export MAIL=/var/mail/${LOGNAME:?}
alias flacrmpic='metaflac --remove --block-type=PICTURE --dont-use-padding '
alias flaclist='D=/home/system/flac; find $D/ -name "*.flac" -type f |sort >$D/playlist.txt; rsync -avzP $D/playlist.txt mac:files/txt/'
alias vidlist='D=/home/system/vids; find $D/ -name "*.*" -type f |sort >$D/vidlist; rsync -avzP $D/vidlist mac:files/txt/'
alias allflactime='D=/home/system/flac; T=`mktemp`; cd $D && unbuffer flactime -a . |tee $T && gzip - <$T |base64 |ssh mac "base64 -d |gzip -d | mutt -s \"musac counts\" -- andy"  && cd - && rm $T'
alias a='TZ=Australia/Sydney "$@"'
alias uk='TZ=Europe/London "$@"'
alias wakecoco="wakeonlan -p 9 'bc:5f:f4:23:4f:9a'"
alias wakecashew="wakeonlan -p 9 '00:0b:e0:f0:00:ed'"
alias restartwlan='killall -9 dhclient3; killall -9 wpa_supplicant; rmmod iwldvm; rmmod iwlwifi; rmmod mac80211; rmmod cfg80211; modprobe iwlwifi; killall wpa_supplicant NetworkManager'
alias ta='tmux attach'
alias syncfileservers='rsync -avP --delete /home/ cashew:/home/'


function androidpush() {
	local pushed=0
	while test -n "$1"; do
		find "$1" -type f -name "*.mp3" |grep -q .
		if [ $? -eq 0 ]; then
			pushed=1
			echo "Running adb push \"$1\" /mnt/runtime/write/53B9-2AD2/mp3"
			adb push "$1" /mnt/runtime/write/53B9-2AD2/mp3
			shift
		else
			echo "Can't find *.mp3 in '$1'; skipping"
		fi
	done

	if [ $pushed -eq 1 ]; then
		echo "Rebuilding list of phone mp3s"
		adb shell find /mnt/runtime/write/53B9-2AD2/mp3 -type f > ~/files/txt/phonemp3list.txt
		rsync -avzP ~/files/txt/phonemp3list.txt mac:files/txt/
	fi
}


function inter_shite () {
        cal
}

if [ -z "$SSH_CLIENT" ]; then
        inter_shite
else
        if [ "x$SSH_TTY" != "x" ]; then
                inter_shite
        fi
fi

complete -r

function luksmount() {
	lukshost=`uname -n`;
	case $lukshost in
		pistachio|hazel)
			luksdrive=/dev/sdb
			;;
		almond)
			luksdrive=/dev/sde
			;;
		*)
			luksdrive=/dev/sdg
			;;
	esac

	cryptsetup create mnetcrypt $luksdrive && mount /mnt/mnetcrypt
}

alias luksumount='umount /mnt/mnetcrypt && cryptsetup luksClose mnetcrypt'
GIT_PROMPT_THEME=Single_line_Solarized
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'
alias ls='ls --color=auto'
source ~/.bash-git-prompt/gitprompt.sh
alias tidydocker="docker ps -a |awk '{print \$1}' |grep -v CONTAINER |xargs docker rm; docker images |egrep -e '<none>|tcf' | awk '{print \$3}' |grep -v IMAG |grep -v |xargs docker rmi"
alias units="units -H ''"
alias ripandflac='cdparanoia -B -d /dev/sr0 && eject cdrom && flacenc.js && rm *wav'
alias mount10tb='mkdir -p /mnt/10tb && cryptsetup create 10tb /dev/sdg && mount /dev/mapper/10tb /mnt/10tb'
alias bccalc='set -f;bccalc'
function bccalc() {
	echo "scale=4; $@" | bc
	set +f
}
alias ozac='cd ~/files/bank && gnucash oz_accounts.gnucash && rm oz_accounts.gnucash*log && cd-'
alias sshgw='ssh -o KexAlgorithms=diffie-hellman-group1-sha1 milky@gw'
function chromtmp() {
	T=$(mktemp -d) 
	chromium --user-data-dir=$T "$@"
        rm -rf $T
}
