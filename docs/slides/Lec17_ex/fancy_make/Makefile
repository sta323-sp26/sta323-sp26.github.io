all: paper.html paper.pdf

paper.html: paper.qmd fig1/fig.png fig2/fig.png
	quarto render paper.qmd

paper.pdf: paper.qmd fig1/fig.png fig2/fig.png
	quarto render paper.qmd --to pdf

fig%/fig.png: fig%/fig.R
	cd $(<D);Rscript $(<F)

clean: 
	rm -f paper.html
	rm -f paper.pdf
	rm -f fig*/fig.png

.PHONY: all clean
