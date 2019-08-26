TARGET=jblistcontainer
CC=gcc

$(TARGET): main.m crt1.o
	$(CC) $^ -o $@ -framework MobileCoreServices
	strip $@
	#without local ldid, remote ldid will crash on unc0ver
	ldid -S $@

install: $(TARGET)
	scpmux $< /usr/bin
	sshmux sh -x codesign /usr/bin/$<

clean: $(TARGET)
	rm $<