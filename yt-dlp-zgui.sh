#!/bin/bash

mkdir -p ~/.yt-dlp-log

LINK=$(zenity --entry \
    --title="yt-dlp-zgui" \
    --text="Enter your link" \
    --entry-text="")

TMPLOG="$HOME/.yt-dlp-log/log.txt"

AUDIOORVIDEO=$(zenity --entry --title="yt-dlp-zgui" --text="Audio or Video? Enter 'audio' or 'video'" --entry-text="")
if [ "$AUDIOORVIDEO" = "audio" ]; then
    QUALITY=$(zenity --entry --title="yt-dlp-zgui" --text="Audio quality (1-10)" --entry-text="")
    FORMAT=$(zenity --entry --title="yt-dlp-zgui" --text="Audio format (Available: aac, alac, flac, m4a, mp3, opus, vorbis, wav)" --entry-text="")
    yt-dlp -x --audio-format "$FORMAT" --audio-quality "$QUALITY" "$LINK" 2>&1| tee "$TMPLOG" | zenity --progress --title="yt-dlp-zgui" --text="Downloading and converting" --pulsate --auto-close --time-remaining
elif [ "$AUDIOORVIDEO" = "video" ]; then
    FORMAT=$(zenity --entry --title="yt-dlp-zgui" --text="Video format (Available: avi, flv, mkv, mov, mp4, webm.)" --entry-text="")
    yt-dlp -f "$FORMAT" "$LINK" 2>&1 | tee "$TMPLOG" | zenity --progress --title="yt-dlp-zgui" --text="Downloading and converting" --pulsate --auto-close --time-remaining
else
    zenity --error --text="Invalid choice. Must be 'audio' or 'video'."
    exit 1
fi

EXIT_CODE=${PIPESTATUS[0]}

if [ $EXIT_CODE -eq 0 ]; then
    zenity --info --title="Done" --text="Conversion Complete!\nSaved to your home folder"
else
    zenity --title="Conversion failed" --text-info --filename="$TMPLOG"
fi


zenity --question --title="Logging" --text="Do you want to delete the log? The log is used for debugging and is saved in .yt-dlp-gui"

if [ $? -eq 0 ]; then

    rm -f "$TMPLOG"
    zenity --info --title="Cleanup" --text="Log deleted."
else

    zenity --info --title="Cleanup" --text="Log kept at: "$TMPLOG""
fi

