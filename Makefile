# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line
GH_PAGES_SOURCES = docs/source sarpy Makefile
SPHINXOPTS    = 
SPHINXBUILD   = python -msphinx
SPHINXPROJ    = sarpydocs
SOURCEDIR     = docs/source
BUILDDIR      = build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
html: Makefile
	sphinx-apidoc -f -o docs/source sarpy
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

gh-pages:
	git config --global user.email "mtejadac@ime.usp.br"
	git config --global user.name "ademirtc"
	git checkout gh-pages
	rm -rf build 
	git checkout master $(GH_PAGES_SOURCES)
	git reset HEAD
	make html
	mv -fv build/html/* ./
	mv sarpy.html index.html
	rm -rf $(GH_PAGES_SOURCES) build
	git add -A
	git commit -m "Generated gh-pages for `git log master -1 --pretty=short --abbrev-commit`" && git push origin gh-pages ; git checkout master 
	##git commit --allow-empty -m "Deploy to GitHub pages [ci skip]"
	# now commit, ignoring branch gh-pages doesn't seem to work, so trying skip
	# and push, but send any output to /dev/null to hide anything sensitive
	## git push --force --quiet origin gh-pages > /dev/null 2>&1
	# go back to where we started and remove the gh-pages git repo we made and used for deployment
	## cd ..
	## rm -rf gh-pages-branch
	echo "Finished Deployment!"