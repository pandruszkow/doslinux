CC = i386-linux-musl-gcc
CFLAGS = -m32 -static -Os -Wall -Wextra
NASM = nasm
STRIP = i386-linux-musl-strip

.PHONY: all
all: hdd.img

.PHONY: clean
clean:
	rm -f hdd.img doslinux.com init

hdd.img: hdd.base.img doslinux.com init
	cp hdd.base.img hdd.img
	MTOOLSRC=mtoolsrc mmd C:/doslinux
	MTOOLSRC=mtoolsrc mcopy doslinux.com C:/doslinux/dsl.com
	MTOOLSRC=mtoolsrc mcopy init C:/doslinux/init
	MTOOLSRC=mtoolsrc mcopy linux-5.8.9/arch/x86/boot/bzImage C:/doslinux/bzimage
	MTOOLSRC=mtoolsrc mcopy busybox-1.32.0/busybox_unstripped C:/doslinux/busybox
	MTOOLSRC=mtoolsrc mmd C:/doslinux/rootfs

doslinux.com: doslinux.asm
	$(NASM) -o $@ -f bin $<

.PHONY: initrd/initrd.img
initrd/initrd.img:
	make -C initrd initrd.img

init: init.c
	$(CC) $(CFLAGS) -o $@ $<
	$(STRIP) $@