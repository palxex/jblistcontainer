TARGET=jblistcontainer
CC=gcc

$(TARGET): main.m crt1.o
	$(CC) $^ -o $@ -framework MobileCoreServices
	strip $@
	ldid -S $@

install: $(TARGET)
	scp -P${THEOS_DEVICE_PORT} $< root@${THEOS_DEVICE_IP}:/usr/bin
	ssh -p${THEOS_DEVICE_PORT} root@${THEOS_DEVICE_IP} ldid -S /usr/bin/$<

clean: $(TARGET)
	rm $<