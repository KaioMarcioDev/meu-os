# Diretórios
BOOT_DIR = boot
KERNEL_DIR = kernel
LIB_DIR = lib
TESTS_DIR = tests
IMAGES_DIR = images

# Ferramentas
NASM = nasm
QEMU = qemu-system-i386
DD = dd

# Arquivos
BOOT_BIN = $(BOOT_DIR)/boot.bin
KERNEL_BIN = $(KERNEL_DIR)/kernel.bin
OS_IMG = $(IMAGES_DIR)/meu_os.img

# Testes
TESTS = blink graphic info game clock animation

# Regra principal
all: $(OS_IMG)

# Cria a imagem do sistema operacional
$(OS_IMG): $(BOOT_BIN) $(KERNEL_BIN)
	$(DD) if=/dev/zero of=$@ bs=512 count=2880
	$(DD) if=$(BOOT_BIN) of=$@ bs=512 count=1 conv=notrunc
	$(DD) if=$(KERNEL_BIN) of=$@ bs=512 seek=1 conv=notrunc

# Compila o bootloader
$(BOOT_BIN): $(BOOT_DIR)/boot.asm
	$(NASM) -f bin -I $(LIB_DIR) -o $@ $<

# Compila o kernel
$(KERNEL_BIN): $(KERNEL_DIR)/kernel.asm
	$(NASM) -f bin -I $(LIB_DIR) -o $@ $<

# Executa o sistema operacional
run: $(OS_IMG)
	$(QEMU) -fda $(OS_IMG) -vga std

# Compila e executa testes
test-%: $(TESTS_DIR)/%/test_kernel.bin
	$(DD) if=$(BOOT_BIN) of=$(IMAGES_DIR)/test.img bs=512 count=1
	$(DD) if=$< of=$(IMAGES_DIR)/test.img bs=512 seek=1 conv=notrunc
	$(QEMU) -fda $(IMAGES_DIR)/test.img -vga std

# Compila os kernels de teste
$(TESTS_DIR)/%/test_kernel.bin: $(TESTS_DIR)/%/%_kernel.asm
	$(NASM) -f bin -o $@ $<

# Limpa os arquivos gerados
clean:
	rm -f $(BOOT_BIN) $(KERNEL_BIN) $(OS_IMG) $(IMAGES_DIR)/test.img
	for test in $(TESTS); do \
		rm -f $(TESTS_DIR)/$$test/test_kernel.bin; \
	done

# Mostra a estrutura do projeto
tree:
	@echo "Estrutura do projeto:"
	@find . -type f | sort | sed 's|[^/]*/|  |g'

.PHONY: all run clean tree $(addprefix test-,$(TESTS))