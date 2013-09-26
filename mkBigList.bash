#!/usr/bin/env bash

# temp dir
txtdir=txtfiles
[ ! -d $txtdir ] && mkdir -p $txtdir

# error logs and final output
[ -r errors.txt ] && rm errors.txt
[ -r BigList.txt ] && rm BigList.txt

# for each SoundsRating
for d in /mnt/B/bea_res/Data/Tasks/CogEmoSoundsRating/Basic/*/*/Raw; do
 datedir=$(dirname $d)
 date=$(basename $datedir)
 subj=$(basename $(dirname $datedir))
 txtfile=$txtdir/$subj.$date.eprime.txt

 # do this each time so we can maintain error log
 count=$(ls $d/*txt 2>/dev/null |wc -l)
 [ "$count" -ne 1 ] && echo "$d has $count txt files!" | tee -a errors.txt && continue

 # copy and convert if we haven't
 if [ ! -r  $txtfile ]; then
  cp $d/*txt $txtfile 
  dos2unix $txtfile
 fi


 # reduce file to what we care about, add subj and date columns
 # see  output of
 #  perl -ne 'chomp; print "\n" if /SoundStim/;if(/RESP|wav|RT:/){s/^\W*//g;print "$_\t"};' SoundRatings_WithMEGSoundsAV_12152011-10370-1.txt |haed
 perl -ne 'chomp; print "\n" if /SoundStim/;if(/RESP|wav|RT:/){s/^.*://g;print "$_\t"};END{print "\n"}' $txtfile |
  sed '/^$/d' | sed "s/^/$subj\t$date\t/" |
  tee $txtdir/$subj.$date.reduced.txt >> BigList.txt
 
 count=$(cat $txtdir/$subj.$date.reduced.txt | wc -l)
 [ "$count" -lt 84 ] && echo "$subj $date has $count wave files!" | tee -a errors.txt && continue
done
