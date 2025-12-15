# Makefile for qtodo plasmoid
# 自动将 package/ 拷贝到 ~/.local/share/plasma/plasmoids/<id>
# 并能使用 plasmoidviewer 运行

RUNTIME_DIR := $(shell pwd)
METADATA := $(RUNTIME_DIR)/metadata.json
INSTALL_BASE := $(HOME)/.local/share/plasma/plasmoids
PLASMOIDVIEWER := plasmoidviewer
RSYNC := rsync -a --delete
NAME := org.kde.plasma.vutronmusic-lyrics

# 尝试使用 python3 再回退到 python 以解析 metadata.json 中的 id 字段
# 备用更稳健（不依赖 make 解析时立即计算）的方式（在 recipe 中使用）：
# ID := $(shell python3 -c 'import json,sys;print(json.load(open("package/metadata.json")).get("id",""))' 2>/dev/null || python -c 'import json,sys;print(json.load(open("package/metadata.json")).get("id",""))' 2>/dev/null)

INSTALL_DIR := $(INSTALL_BASE)/$(NAME)
.PHONY: help install run clean

help:
	@echo "Usage: make <target>"
	@echo "Targets:"
	@echo "  install    Install the plasmoid into $(INSTALL_BASE)"
	@echo "  run        Install then run the plasmoid with $(PLASMOIDVIEWER)"
	@echo "  clean      Remove the installed plasmoid from $(INSTALL_BASE)"

# 默认不做任何事，避免在 make 没指定目标时直接运行
all: help

install:
	@# 确保安装基目录存在
	@mkdir -p "$(INSTALL_BASE)"
	@# 使用 rsync 同步并删除多余文件，保持目标与 package/ 一致
	@echo "Installing plasmoid '$(RUNTIME_DIR)' to '$(INSTALL_DIR)'"
	@$(RSYNC) "$(RUNTIME_DIR)/" "$(INSTALL_DIR)/"
	@echo "Installed."

run:
	@echo "Launching plasmoidviewer with '$(RUNTIME_DIR)'"
	@$(PLASMOIDVIEWER) --applet "$(RUNTIME_DIR)"

clean:
	@# 安全检查，避免误删根路径或不相关目录
	@case "$(INSTALL_DIR)" in "$(INSTALL_BASE)"/*) \
		echo "Removing '$(INSTALL_DIR)'"; rm -rf "$(INSTALL_DIR)"; \
		echo "Removed."; \
		;; \
	*) \
		echo "Refusing to remove '$(INSTALL_DIR)' because it is not under '$(INSTALL_BASE)'"; exit 1; \
	esac

