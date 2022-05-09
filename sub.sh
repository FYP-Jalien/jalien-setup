./copy.sh	
#alien.py submit test.jdl
for run in {1..10}; do alien.py submit test.jdl; done
