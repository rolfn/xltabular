# Rolf Niepraschk, 2018-12-16, Rolf.Niepraschk@gmx.de

.SUFFIXES : .tex .ltx .dvi .ps .pdf .eps

MAIN = xltabular

LATEX = lualatex
TEX = tex
BIBER = biber

VERSION = $(shell awk '/ProvidesPackage/ {print $$2}' $(MAIN).sty)

BIBS = xltabular-doc.bib
DIST_DIR = $(MAIN)
DIST_FILES = $(MAIN).sty README.md $(MAIN)-doc.tex $(MAIN)-doc.pdf Changes \
  $(BIBS) xltabular-example.tex xltabular-example.inp
#  $(BIBS) xltabular-example-hyp.tex xltabular-example.tex xltabular-example.inp
ARCHNAME = $(MAIN)-$(VERSION).zip

all : $(MAIN)-doc.pdf

$(MAIN)-doc.bcf : $(MAIN)-doc.tex $(BIBS)
	$(LATEX) $<

$(MAIN)-doc.bbl : $(MAIN)-doc.bcf
	$(BIBER) -V $<
	$(LATEX) $(basename $<).tex

$(MAIN)-doc.pdf : $(MAIN)-doc.tex $(MAIN).sty $(MAIN)-doc.bib $(MAIN)-doc.bbl 
	$(LATEX) $<

dist : $(DIST_FILES)
	rm -rf $(DIST_DIR) $(ARCHNAME)
	mkdir -p $(DIST_DIR)
	cp -p $+ $(DIST_DIR)
	zip $(ARCHNAME) -r $(DIST_DIR)
	rm -rf $(DIST_DIR)

clean :
	$(RM) *.aux *.log *.glg *.glo *.gls *.idx *.ilg *.ind *.toc
	$(RM) *.bbl *.bcf *.blg *.lot *.out *.run.xml 

veryclean : clean
	$(RM) $(MAIN).pdf $(ARCHNAME)

debug :
	@echo $(ARCHNAME)
