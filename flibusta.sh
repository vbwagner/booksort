#!/bin/sh
#
# This script processes monthy flibusta.lib updates. It expects that
# you've downloaded full flibusta fb2 archives via torrents and
# updates them monthly (if you keep files in your torrent client spool
# and replace torrent file monthly, only updates would be actually
# downloaded, but entire archive seeded).
#
SPOOL=/srv/transmission/downloads
ARCHIVE=fb2.Flibusta.Net
LIBRARY=/srv/files/books/Книги_в_формате_FB2

cd "$LIBRARY" || exit 2

if [ -e lastparsed ]; then
lastparsed=$(cat lastparsed)
else
lastparsed=0
fi
mkdir temp
for i in "$SPOOL/$ARCHIVE/"f*.zip; do
   #parse archive name
   base=${i%.zip}
   nums=${base#*-}
   first=${nums%-*}
   last=${nums#*-}
   if [ "$first" -lt "$lastparsed" ]; then
   	echo "${i##*/} already parsed. Skipping"
	continue
   fi
   # shellcheck disable=SC3037
   echo -n "${i##*/} unpacking"
   unzip -d temp "$i"
   # shellcheck disable=SC3037
   echo -n " sorting"
   booksort -m temp/*.fb2
   echo " done"
   failed="$(ls temp/*.fb2 2>/dev/null)"
   if [ -n "$failed"  ]; then
      mkdir -p failed
	  mv temp/*.fb2 failed
   fi
   lastparsed=$last
done
echo "$lastparsed">lastparsed
rmdir temp
# shellcheck disable=SC2012
failed="$(ls -1 failed/*.fb2 2>/dev/null|wc -l)"
if [ "$failed" -eq 0 ]; then
   rmdir failed
else
	echo "$failed files which cannot be parsed are kept in $(pwd)/failed" >&2
	exit 1
fi




