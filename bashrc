if [ "$PS1" ]; then
  if [ "$BASH" ]; then
    PS1='\u@\h:\w\$ '
  else
    if [ "`id -u`" -eq 0 ]; then
      PS1='# '
    else
      PS1='$ '
    fi
  fi
fi

umask 022

#if [ $TERM = "Eterm" ]; then
#	export TERM = xterm
#fi

#alias oak='telnet toth.org.uk'
#alias eh='telnet eh.org 90210'
#alias scarlet='telnet scarlet.eu.org 2000'
#alias scarlet='telnet scarlet-citadel.co.uk 2000'
alias lynx='lynx -cfg ~/.lynx.cfg -accept_all_cookies'
alias vi='vim'
#alias whois='whois -h whois.geektools.com'
#alias tar='gtar'
#alias make='gmake'
alias aslook='whois -a -h whois.radb.net'
#alias ps='/usr/ucb/ps'
#alias metahills='telnet talker.pepperfish.net 1234'
alias cal='cal() { m=$1; y=$2; if [ "x$m" != "x" ]; then if  [ "x$y" != "x" ]; then if [ $m -gt 12 ]; then m=$2; y=$1; fi; fi; fi; ccal -col=/home/andy/.calcol $m $y; }; cal'
alias syncalmond='echo use syncman'
#alias syncpecan='rsync -avPCz pecan:{files,mail,.centerim,.dates} ~'
alias syncpecan='echo use syncmac'
#alias syncmac='pgrep skype >/dev/null || rsync --exclude '*swp' -auvPCz macadamia.milky.org.uk:{bin,files,mail,.gnupg,.centerim,.dates,.Skype*} ~'
alias syncmac='pgrep skype >/dev/null || rsync --exclude-from /home/andy/files/etc/syncmac-excludes.txt -auvPz macadamia.milky.org.uk:{bin,files,mail,.gnupg} ~'
alias gpgd='gpg -d ~/files/txt/stuff.gpg | grep "$@"'
function gpgdc() {
        acc=$1; shift
        charspec=$1; shift
        gpgd $acc | grep -Po ' passchars: \K[^ ][^ ]*' | cut -c $charspec
}
alias washing='countdown $((34 * 60 ))'
#alias drying='countdown $((55 * 60 ))'
alias drying='countdown $((62 * 60 ))'
#alias tap="ssh awhite@10.6.3.33"
#alias gdesktop="ssh awhite@10.6.3.27"
#alias vpngo="vpnclient connect WEBSYS user andrewwhite pwd $1"


#export LD_LIBRARY_PATH=/usr/local/lib:/opt/csw/lib
#export LD_LIBRARY_PATH_64=/usr/local/lib/sparcv9:/opt/csw/lib/sparcv9
export PATH=~/bin:$PATH
#alias support='telnet support.bbc.co.uk 5000'
#alias mtr='/opt/csw/sbin/mtr'
alias countdown='countdown() { COUNTDOWNLENGTH=$1; while test $COUNTDOWNLENGTH -gt 0; do echo -n "$COUNTDOWNLENGTH "; COUNTDOWNLENGTH=$[ $COUNTDOWNLENGTH - 1 ]; sleep 1; done; echo ""; }; countdown'
alias countup='N=-1; while :; do N=$[ $N + 1 ]; echo -n "$N "; sleep 1; done; countup'
alias flac_to_cdr='OUT=/home/andy/cdr_out; mkdir $OUT; A=0; FILENAME=playlist.txt; while read x ; do A=$[ $A + 1 ];printf -v B "%02d" $A; flac -d $x -o $OUT/$x.wav; mv $OUT/$x.wav $OUT/track_$B.wav; done <$FILENAME'
alias rip_and_flac='cdparanoia -B -d /dev/dvd && eject dvd && flacenc && rm *wav'
alias add_flac_img='metaflac --import-picture-from="3|image/jpeg|cover||a.jpg" *flac && metaflac --add-replay-gain *flac'
alias replace_flac_img='metaflac --remove --dont-use-padding --block-type=PICTURE *flac && metaflac --import-picture-from="3|image/jpeg|cover||a.jpg" --dont-use-padding *flac'
alias test_flacs='OK=1; for i in `find . -name "*flac"`; do  if [ $OK -eq 1 ]; then echo -n $i; flac -t $i >/dev/null 2>/dev/null;  if [ $? -eq 0 ]; then echo " - OK"; else echo " - NOT OK"; OK=0; fi; fi; done'
alias freedom='~/bin/countdown.pl 20241216' # Res

export MAIL=/var/mail/${LOGNAME:?}
alias flacrmpic='metaflac --remove --block-type=PICTURE --dont-use-padding '
alias flaclist='D=/home/system/flac; find $D/ -name "*.flac" -type f |sort >$D/playlist.txt; rsync -avzP $D/playlist.txt mac:files/txt/flaclist.txt'
alias vidlist='D=/home/system/vids; find $D/ -name "*.*" -type f |sort >$D/vidlist; rsync -avzP $D/vidlist mac:files/txt/'
alias allflactime='D=/home/system/flac; T=`mktemp`; cd $D && unbuffer flactime -a . |tee $T && gzip - <$T |base64 |ssh mac "base64 -d |gzip -d | mutt -s \"musac counts\" -- andy"  && cd - && rm $T'
alias a='TZ=Australia/Sydney "$@"'
alias uk='TZ=Europe/London "$@"'
#alias wakecoco="wakeonlan -p 9 '1c:6f:65:b7:24:05'"
#alias wakecoco="wakeonlan -p 9 '48:5b:39:89:41:21'"
alias wakecoco="wakeonlan -p 9 'bc:5f:f4:23:4f:9a'"
alias wakecashew="wakeonlan -p 9 '00:0b:e0:f0:00:ed'"
alias restartwlan='killall -9 dhclient3; killall -9 wpa_supplicant; rmmod iwldvm; rmmod iwlwifi; rmmod mac80211; rmmod cfg80211; modprobe iwlwifi; killall wpa_supplicant NetworkManager'
alias ta='tmux new -A -s'
alias syncfileservers='rsync -avP --delete /home/ cashew:/home/'

function androidpush() {
	#AFS=/mnt/runtime/write/53B9-2AD2/mp3
	AFS=/storage/53B9-2AD2/mp3
	local pushed=0
	while test -n "$1"; do
		find "$1" -type f -name "*.mp3" |grep -q .
		if [ $? -eq 0 ]; then
			pushed=1
			echo "Running adb push \"$1\" $AFS"
			adb push "$1" $AFS
		else
			echo "Can't find *.mp3 in '$1'; skipping"
		fi
		shift
	done

	if [ $pushed -eq 1 ]; then
		echo "Rebuilding list of phone mp3s"
		adb shell find $AFS -type f > ~/files/txt/phonemp3list.txt
		rsync -avzP ~/files/txt/phonemp3list.txt mac:files/txt/
		adb shell df $AFS
	fi
}


function inter_shite () {
        cal
	#echo -n "Freedom: "; freedom
	#echo Wrong agency\!
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

	#cryptsetup luksOpen $luksdrive mnetcrypt && mount /mnt/mnetcrypt
	cryptsetup create mnetcrypt $luksdrive && mount /mnt/mnetcrypt
}

#alias luksmount='cryptsetup luksOpen /dev/sdg mnetcrypt; mount /mnt/mnetcrypt'
alias luksumount='umount /mnt/mnetcrypt && cryptsetup luksClose mnetcrypt'
#function alsamixer() {
#	if [ "$HOSTNAME" == "hazel" ]; then
#		/usr/bin/alsamixer -c 1
#	else
#		/usr/bin/alsamixer 
#	fi
#}
GIT_PROMPT_THEME=Single_line_Solarized
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'
alias ls='ls --color=auto'
source ~/.bash-git-prompt/gitprompt.sh
#alias tidydocker="docker ps -a |awk '{print \$1}' |grep -v CONTAINER |xargs docker rm; docker images |egrep -e '<none>|tcf' | awk '{print \$3}' |grep -v IMAG |grep -v |xargs docker rmi"
alias tidydocker='docker ps -a |awk '\''{print $1}'\'' |grep -v CONTAINER |xargs -r  docker rm; docker images |egrep -e '\''<none>|tcf'\'' | awk '\''{print $3}'\'' |grep -v IMAG  |xargs -r docker rmi'
alias units="units -H ''"
alias ripandflac='cdparanoia -B -d /dev/sr0 && eject cdrom && flacenc.js && rm *wav'
alias mount10tb='mkdir -p /mnt/10tb && cryptsetup create 10tb /dev/sdg && mount /dev/mapper/10tb /mnt/10tb'
# set -f can't be in the func? Fine
alias bccalc='set -f;bccalc'
function bccalc() {
	echo "scale=4; $@" | bc
	set +f
}
alias ozac='cd ~/files/bank && gnucash oz_accounts.gnucash && rm oz_accounts.gnucash*log && cd-'
alias sshgw='ssh -o KexAlgorithms=diffie-hellman-group1-sha1 milky@gw'
#alias showmethemoney='find ~/files/bank/ -name "$(date +%Y%m).csv" |xargs grep -h -m 1 . |awk -F, "{A=A+\$4} END { print A }"'

function showmethemoney() {
    B=~/files/bank;
    RT=0;
    OSD=foo;
    BDIR=(acc1 acc2 acc3)

    for bd in ${BDIR[@]}; do
        for b in $(find $B/$bd -type d); do
            find  $b -maxdepth 1  -type f -exec false {} + && continue
            SD=$(echo $b | sed -e "s!$B/!!" -e 's!/.*!!');
            if [[ $OSD != $SD ]]; then
                OSD=$SD;
                ST=0;
            fi;
            for c in `ls $b/*|sort -nr |head -1`;
            do
                echo -n "$c: ";
                T=$(sort -nr < $c | head -1 | sed 's/.*,\r*//');
                RT=$(bc <<< "$RT + $T");
                ST=$(bc <<< "$ST + $T");
                echo "$T ('$OSD' running total $ST)";
            done;
        done;
    done;
    echo TOTAL: $RT
}

function ctt() {
	T=$(mktemp -d -p /dev/shm) 
	#torify chromium --user-data-dir=$T --password-store=basic "$@" 2>/dev/null
	chromium --user-data-dir=$T --password-store=basic --proxy-server=socks5://localhost:9050 "$@" 2>/dev/null
	rm -rf $T
}

function ctp() {
	chromtmp --proxy-server=milky.org.uk:8085 "$@"
}

function ct() {
	chromtmp "$@"
}

function chromtmp() {
	T=$(mktemp -d -p /dev/shm) 
	chromium --user-data-dir=$T --password-store=basic "$@" 2>/dev/null
	rm -rf $T
}

function gct() {
	T=$(mktemp -d -p /dev/shm) 
	google-chrome --user-data-dir=$T --password-store=basic "$@" 2>/dev/null
	rm -rf $T
}

function palemoontmp {
	T=$(mktemp -d -p /dev/shm) 
	palemoon --profile $T
	rm -rf $T
}

function pt {
	T=$(mktemp -d -p /dev/shm) 
	palemoon --profile $T
	rm -rf $T
}

function ptt {
	T=$(mktemp -d -p /dev/shm) 
	torify palemoon --profile $T
	rm -rf $T
}


function piplayolder {
        ST=$(flacinfo $1 2>/dev/null |grep -Po 'INF\| time: \K.*')
        if [ $? -ne 0 ]; then
           echo >&2 "Can't get file time for $1"
           return 1
        fi
	cat $1 | nc -q 0 pihole 3000
        if [ $? -eq 0 ]; then
             echo "$1 playing on pi; sleep for $ST"
             sleep $ST
        else
            echo "Play fail"
            return 1
        fi
}

function piplayold {
	trickle -u 1412 ffmpeg -i $1 -vn -acodec pcm_s16le -f wav -ar 44100 - | nc -q 0 pihole 3000
}

function piplay {
	ffmpeg -i "$1" -vn -acodec pcm_s16le -f wav -ar 44100 - | ssh pihole "mpv -" 
}

MAILPATH="$MAIL?what now (ie new mail)"

#alias xs='killall -CONT xscreensaver ; xscreensaver-command -lock && sudo pm-suspend; sleep 60 && killall -STOP xscreensaver'
#alias xs='xscreensaver&; sleep 2; xscreensaver-command -lock; killall -9 xscreensaver'

if [ `hostname` != "macadamia.milky.org.uk" ]; then
  alias xs='(lxlock&); sudo pm-suspend'
  alias qiv='qiv -R'
  export PATH=$HOME/.tfenv/bin:$HOME/.tgenv/bin:$HOME/.pyenv/bin:$PATH
  which pyenv >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    pyenv shell 3.14.5
  fi
alias assume-aws='export AWS_ACCOUNT=111111111111; export AWS_PROFILE=my-aws-acc ;export AWS_REGION=eu-west-1;aws-azure-login --no-sandbox --no-prompt'
fi
export HISTIGNORE=' *'
alias ffmpeg_identfy='ffprobe -v error -show_format -show_streams'
alias ffmpeg_probe='ffprobe -v error -show_format -show_streams'
alias viv='vivaldi --password-store=basic'
alias chrom='chromium --password-store=basic --user-data-dir=chromium'
alias w='w --terminal'
