# Build: make
# Docker: docker build -t keyval . && docker run --rm --user "$(id -u):$(id -g)" -v "$PWD:/work" keyval make

BUILDDIR = build
SRC      = keyval.md

TYPST_COMPILE = typst compile \
    --font-path /usr/share/fonts \
    --font-path "$${XDG_DATA_HOME:-$$HOME/.local/share}/fonts"

.PHONY: all clean
.INTERMEDIATE: $(BUILDDIR)/keyval-a4.typ $(BUILDDIR)/keyval-screen.typ

all: $(BUILDDIR)/keyval.html $(BUILDDIR)/iosevka-regular.woff2 \
     $(BUILDDIR)/keyval-a4.pdf $(BUILDDIR)/keyval-screen.pdf

$(BUILDDIR)/keyval.html: $(SRC) style.html
	mkdir -p $(BUILDDIR)
	pandoc -f markdown -t html5 --standalone \
	    --include-in-header style.html \
	    $< -o $@

$(BUILDDIR)/iosevka-regular.woff2: iosevka-regular.woff2
	mkdir -p $(BUILDDIR)
	cp $< $@

$(BUILDDIR)/keyval-a4.typ: $(SRC)
	mkdir -p $(BUILDDIR)
	{ printf '#set text(font: ("STIX Two Text", "Iosevka"), size: 12pt)\n'; \
	  printf '#set page(paper: "a4", margin: (x: 47mm, y: 15mm))\n'; \
	  printf '#set par(justify: true)\n\n'; \
	  printf '= keyval\n\n'; \
	  pandoc -f markdown -t typst $<; \
	} > $@

$(BUILDDIR)/keyval-screen.typ: $(SRC)
	mkdir -p $(BUILDDIR)
	{ printf '#set text(font: ("STIX Two Text", "Iosevka"), size: 12pt)\n'; \
	  printf '#set page(width: 133mm, height: 280mm + 8pt, margin: (x: 8mm, y: 8mm))\n'; \
	  printf '#set par(justify: true)\n\n'; \
	  printf '= keyval\n\n'; \
	  pandoc -f markdown -t typst $<; \
	} > $@

$(BUILDDIR)/%.pdf: $(BUILDDIR)/%.typ
	$(TYPST_COMPILE) $< $@

clean:
	$(RM) -r $(BUILDDIR)
