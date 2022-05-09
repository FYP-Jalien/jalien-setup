(cd vol ; sudo docker-compose down)
../jalien/compile.sh cs
bin/jared --jar ../jalien/alien-cs.jar --volume ./vol/
(cd vol; sudo docker-compose up)
