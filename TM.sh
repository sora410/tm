#!/bin/bash

# Settings
Q=(0 1 2)
S=('_' 'a' 'b')
q0=0; F=(2); L=-1; R=1;

# delta: Q×S → Q×S×{L,R} 
d0_=end;	d0a=(1 'a' $R); d0b=(0 'b' $R);
d1_=(2 'a' $L); d1a=(1 'b' $R); d1b=(1 'a' $L);
d2_=end; 	d2a=end; 	d2b=end;

# Controller
q=$q0; w="$1"; cur=0

echo "$w: "
while
	if [ 0 -le $cur -a $cur -lt ${#w} ]; then
		c=${w:$cur:1}
	else
		c='_'
	fi
	to=($(eval echo \${d"$q$c"\[\@\]}))
	echo '(q,w,cur): '"($q,$w,$cur)"
	# echo 'to: '"${to[@]}"
	if [ $to = end ]; then
		break
	fi
	q=${to[0]}
	if [ 0 -le $cur -a $cur -lt ${#w} ]; then
		w=$(echo "$w" | sed -e "s/./${to[1]}/$((cur + 1))")
	elif [ $cur -lt 0 ]; then
		for ((i=0; i < -cur - 1; ++i)) {
			w='_'"$w"
		}
		w="${to[1]}$w"
		cur=0
	else
		for ((i=0; i < cur - ${#w}; ++i)) {
			w="$w"'_'
		}
		w="$w${to[1]}"
	fi
	((cur += ${to[2]}))
	:
do :; done

for qf in "${F[@]}"; do
	if [ $qf -eq $q ]; then
		echo 'Accepted'
		exit 0
	fi
done
echo 'Rejected'
exit 1
