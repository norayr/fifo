VOC = /opt/voc/bin/voc
BUILD="build"
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir_path := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

all:
		mkdir -p $(BUILD)
		cd $(BUILD) && \
		$(VOC) -s \
		$(mkfile_dir_path)/src/fifo.Mod
		cd $(BUILD) && \
		$(VOC) $(mkfile_dir_path)/tst/testFifo.Mod -m

clean:
		if [ -d "$(BUILD)" ]; then rm -rf $(BUILD); fi
