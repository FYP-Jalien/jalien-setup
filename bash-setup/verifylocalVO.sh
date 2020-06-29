#!/bin/bash


#checks if JSh/ JBox can connect to JCentral
bash "${JALIEN_HOME}/testj" box &> /dev/null&
sleep 5

bash "${JALIEN_HOME}/jalien" &
sleep 5

fail_check=`ps --no-headers| grep "java" | wc -l`

if [[ $fail_check -ge 1 ]]; then {
	echo "Successfully connected! Cleaning up"
	pkill java &> /dev/null&
	pkill test &> /dev/null&
	sleep 10
}
else {
	echo "Setup failed. Could not connect to JCentral"
	exit 1
}
fi
exit 0