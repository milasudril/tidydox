install:
	mkdir -p /usr/local/share/tidydox
	cp Doxyfile *.xsl /usr/local/share/tidydox
	cp tidydox.sh /usr/local/bin/tidydox
	chmod o+x /usr/local/bin/tidydox
	chmod u+x /usr/local/bin/tidydox
