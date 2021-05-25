EXECUTABLE_NAME = stox
REPO = https://github.com/xbladesub/stox
VERSION = 1.0.0

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(EXECUTABLE_NAME)
BUILD_PATH = .build/apple/Products/Release/$(EXECUTABLE_NAME)
CURRENT_PATH = $(PWD)
RELEASE_TAR = $(REPO)/archive/$(VERSION).tar.gz

.PHONY: install build uninstall format_code publish release

install: build
	mkdir -p $(PREFIX)/bin
	cp -f $(BUILD_PATH) $(INSTALL_PATH)

build:
	swift build --disable-sandbox -c release --arch arm64 --arch x86_64

uninstall:
	rm -f $(INSTALL_PATH)

format_code:
	swiftformat Tests --stripunusedargs closure-only --header strip --disable blankLinesAtStartOfScope
	swiftformat Sources --stripunusedargs closure-only --header strip --disable blankLinesAtStartOfScope

publish: zip_binary bump_brew
	echo "published $(VERSION)"

bump_brew:
	brew update
	brew bump-formula-pr --url=$(RELEASE_TAR) stox

zip_binary: build
	zip -jr $(EXECUTABLE_NAME).zip $(BUILD_PATH)
