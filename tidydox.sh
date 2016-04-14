#!/bin/bash

RESOURCEDIR="/usr/local/share/tidydox"

DOCPARAMS="docparams.xml"

if [ "$#" -ge 1 ]; then
	DOCPARAMS="$1"
	echo Using parmeters from $DOCPARAMS
fi

rm -rf __doc
cp "$RESOURCEDIR"/Doxyfile .

doxygen  > /dev/null 2>&1

mkdir -p __doc/html

for i in __doc/xml/*.xml; do
	xsltproc --path . --path __doc/xml "$RESOURCEDIR"/compound.xsl "$i" \
		| xsltproc --path . --stringparam docparams $DOCPARAMS "$RESOURCEDIR"/page.xsl - \
		> __doc/html/`basename "${i%.*}.html"`
done

echo "Generating class index"
xsltproc --path . --path __doc/xml \
	--stringparam kind "class" --stringparam title "List of classes" "$RESOURCEDIR"/index.xsl \
	__doc/xml/index.xml \
	| xsltproc --path . --stringparam docparams "$DOCPARAMS" "$RESOURCEDIR"/page.xsl - > __doc/html/classes.html

echo "Generating file index"
xsltproc --path . --path __doc/xml \
	--stringparam kind "file" --stringparam title "List of files" index.xsl \
	__doc/xml/index.xml \
	| xsltproc --path . --stringparam docparams "$DOCPARAMS" "$RESOURCEDIR"/page.xsl - > __doc/html/files.html

echo "Generating namespace index"
xsltproc --path . --path __doc/xml \
	--stringparam kind "namespace" --stringparam title "List of namespaces" "$RESOURCEDIR"/index.xsl \
	__doc/xml/index.xml \
	| xsltproc --path . --stringparam docparams "$DOCPARAMS" "$RESOURCEDIR"/page.xsl - > __doc/html/namespaces.html

echo "Generating struct index"
xsltproc --path . --path __doc/xml \
	--stringparam kind "struct" --stringparam title "List of structs" "$RESOURCEDIR"/index.xsl \
	__doc/xml/index.xml \
	| xsltproc --path . --stringparam docparams "$DOCPARAMS" "$RESOURCEDIR"/page.xsl - > __doc/html/structs.html

echo "Generating API reference index"
xsltproc --path . --path __doc/xml apiref.xsl "$DOCPARAMS" \
	| xsltproc --path . --stringparam docparams "$DOCPARAMS" "$RESOURCEDIR"/page.xsl - > __doc/html/apiref.html

echo "Generating main page"
xsltproc --path . --path __doc/xml --stringparam docparams "$DOCPARAMS" "$RESOURCEDIR"/page.xsl index.xml > __doc/html/index.html

echo "Copying resources"
xsltproc --path . "$RESOURCEDIR"/resources.xsl "$DOCPARAMS" | xargs -d '\n' cp -t __doc/html