export QUARTUS_PATH=/opt/altera/13.0sp1/quartus/bin/

all:
	make -C quartus all

clean:
	make -C quartus clean

program:
	make -C quartus program

