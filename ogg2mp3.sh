#!/bin/bash
set -x
# find . -name '*.ogg' | while read FILE; do oggdec -o - "$FILE" | lame - "$FILE.mp3" ; done

for a in *.ogg

do
OUTF=`echo "$a" | sed s/\.ogg$/.mp3/g`
INF=`echo "$a" | sed s/\.ogg$/.wav/g`

ARTIST=`ogginfo "$a" | grep ARTIST= | sed s/.*=//g`
TITLE=`ogginfo "$a" | grep TITLE= | sed s/.*=//g`
ALBUM=`ogginfo "$a" | grep ALBUM= | sed s/.*=//g`
GENRE=`ogginfo "$a" | grep GENRE= | sed s/.*=//g`
TRACKNUMBER=`ogginfo "$a" | grep TRACKNUMBER= | sed s/.*=//g`
DATE=`ogginfo "$a" | grep DATE= | sed s/.*=//g`

oggdec "$a" -o "$INF" && lame --noreplaygain -V0 \
         --add-id3v2 --pad-id3v2 --ignore-tag-errors --tt "$TITLE" --tn "${TRACKNUMBER:-0}" --ta "$ARTIST" --tl "$ALBUM" --ty "$DATE" --tg "${GENRE:-12}" \
         "$INF" "$OUTF" && rm -f *wav

# Delete input ogg files by specifying "-d"
if [ "$1" ] && [ "$1" = "-d" ] && [ $? -eq 0 ]
then
        rm "$a"
fi

done