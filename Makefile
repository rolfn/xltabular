# Rolf Niepraschk, 2014-10-24, Rolf.Niepraschk@gmx.de

.SUFFIXES : .tex .ltx .dvi .ps .pdf .eps

MAIN = xltabular

LATEX = lualatex
TEX = tex
BIBER = biber

VERSION = $(shell awk '/ProvidesPackage/ {print $$2}' $(MAIN).sty)

BIBS = xltabular-doc.bib
DIST_DIR = $(MAIN)
DIST_FILES = $(MAIN).sty README.md $(MAIN)-doc.tex $(MAIN)-doc.pdf Changes \
  $(BIBS)
ARCHNAME = $(MAIN)-$(VERSION).zip

all : $(MAIN)-doc.pdf

$(MAIN)-doc.bcf : $(MAIN)-doc.tex $(BIBS)
	$(LATEX) $<

$(MAIN)-doc.bbl : $(MAIN)-doc.bcf
	$(BIBER) -V $<

$(MAIN)-doc.pdf : $(MAIN)-doc.tex $(MAIN).sty $(MAIN)-doc.bib $(MAIN)-doc.bbl 
	$(LATEX) $<
	$(BIBER) $*
	$(LATEX) $<
	$(LATEX) $<

dist : $(DIST_FILES)
	rm -f $(DIST_DIR) $(ARCHNAME)
	mkdir -p $(DIST_DIR)
	cp -p $+ $(DIST_DIR)
	zip $(ARCHNAME) -r $(DIST_DIR)
	rm -rf $(DIST_DIR)

clean :
	$(RM) *.aux *.log *.glg *.glo *.gls *.idx *.ilg *.ind *.toc

veryclean : clean
	$(RM) $(MAIN).pdf $(MAIN).sty $(ARCHNAME)

debug :
	@echo $(ARCHNAME)
