function greade_return() {
    sum=`expr $1 + $2 + $3 + $4`
    
    if [ $sum -ge 80 ]; then
    	greade_show="A+"
    elif [ $sum -ge 75 ]; then
    	greade_show="A"
    elif [ $sum -ge 70 ]; then
    	greade_show="A-"
    elif [ $sum -ge 65 ]; then
    	greade_show="B+"
    elif [ $sum -ge 60 ]; then
    	greade_show="B"
    elif [ $sum -ge 55 ]; then
    	greade_show="B-"
    elif [ $sum -ge 50 ]; then
    	greade_show="C+"
    elif [ $sum -ge 45 ]; then
    	greade_show="C"
    elif [ $sum -ge 40 ]; then
    	greade_show="D"
    else
    	greade_show="F"
    fi
}

greade_return 12 13 28 10
grade=$greade_show
echo "$grade"
