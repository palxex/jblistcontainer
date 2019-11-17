TARGET=jblistcontainer
CC=gcc

$(TARGET): main.m crt1.o
	$(CC) $^ -o $@ -framework MobileCoreServices
	strip $@
	ldid -S $@

install: $(TARGET)
	scpmux $< /usr/bin

clean: $(TARGET)
	rm $<