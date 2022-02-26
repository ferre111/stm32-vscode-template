.PHONY: all build cmake clean format

BUILD_DIR := build
BUILD_TYPE ?= Debug
PROJECT := hello_world_vs_code

all:build 

${BUILD_DIR}/Makefile:
	cmake \
	-B${BUILD_DIR} \
	-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
	-DCMAKE_TOOLCHAIN_FILE=gcc-arm-none-eabi.cmake \
	-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
	-G "Unix Makefiles"

cmake: ${BUILD_DIR}/Makefile 

build: cmake 
	$(MAKE) -C ${BUILD_DIR} --no-print-directory

SRCS := $(shell find . -name '*.[ch]' -or -name '*.[ch]pp')
format: $(addsuffix .format,${SRCS})

%.format: %
	clang-format -i $<

clean:
	rm -rf $(BUILD_DIR)

flash: all
	openocd -f interface/stlink.cfg -f target/stm32f1x.cfg -c "program $(BUILD_DIR)/${PROJECT}.elf verify reset exit"