ASM = nasm

SRC_DIR = src
BUILD_DIR = build
ISO_DIR = iso

BOOTLOADER_SRC = $(SRC_DIR)/bootloader/boot.asm
MAIN_SRC = $(SRC_DIR)/main.asm

BOOTLOADER_BIN = $(BUILD_DIR)/bootloader.bin
MAIN_BIN = $(BUILD_DIR)/main.bin
BOOT_IMG = $(BUILD_DIR)/boot.img
ISO_IMG = $(BUILD_DIR)/bootable.iso

.PHONY: all clean iso always

# Build the final ISO image
all: $(ISO_IMG)

# Compile bootloader
$(BOOTLOADER_BIN): $(BOOTLOADER_SRC) | $(BUILD_DIR)
	$(ASM) $< -f bin -o $@

# Compile kernel/main
$(MAIN_BIN): $(MAIN_SRC) | $(BUILD_DIR)
	$(ASM) $< -f bin -o $@

# Combine bootloader + kernel into one bootable image (like the floppy used to do)
$(BOOT_IMG): $(BOOTLOADER_BIN) $(MAIN_BIN)
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=$(BOOTLOADER_BIN) of=$@ bs=512 count=1 conv=notrunc
	dd if=$(MAIN_BIN) of=$@ bs=512 seek=1 conv=notrunc

# Create ISO using El Torito spec
$(ISO_IMG): $(BOOT_IMG)
	mkdir -p $(ISO_DIR)
	cp $< $(ISO_DIR)/boot.img
	xorriso -as mkisofs -b boot.img -no-emul-boot -boot-load-size 4 -boot-info-table -o $@ $(ISO_DIR)
	rm -rf $(ISO_DIR)
# Ensure build directory exists
$(BUILD_DIR):
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR) $(ISO_DIR

