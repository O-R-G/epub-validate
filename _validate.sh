#!/bin/bash

# requires compressed .epub or uncompressed .epub/
# zip files in correct sequence to make .epub
# then run epubcheck validator on result
# outputs 2 files
# uncompressed as proof.epub 
# compressed as validate.epub 
# and validation report on stdout

# cleanup 
rm -r proof.epub
rm -r validate.epub

# $1 = positional parameter (argument) 
DIR=$(pwd)
EPUB=$1

# zip?
# mimetype needs to be the first file in the archive
# flag -X makes sure mimetype does not have an extra field in its zip header
# then view contents of zip

if [[ $(file -b "$EPUB") == directory ]]; then
    echo "uncompressed .epub --> $EPUB"
    echo "cp --> proof.epub"
    echo "zip --> validate.epub"
    cp -r "$EPUB/." proof.epub

    # zip manually in correct order
    # cd "$EPUB"
    # zip -rqX "$DIR/validate.epub" mimetype META-INF/ OEBPS/;
    # zip -rqX "$DIR/validate.epub" mimetype META-INF/ EPUB/;
    # cd "$DIR"

    # zip via epubcheck
    # https://github.com/IDPF/epub3-samples/blob/master/pack-single.sh
    # cp folder w/o .epub extension first to save with epubcheck
    # (epubcheck adds extension) then cleanup
    cp -r "$EPUB/." validate
    java -jar epubcheck-4.2.2/epubcheck.jar validate/ -mode exp -save 
    rm -r validate/
else
    echo "compressed .epub --> $EPUB"
    echo "cp --> validate.epub"
    echo "unzip --> proof.epub"
    mkdir proof
    unzip -q "$EPUB" -d "$DIR/proof"
    mv proof proof.epub
    cp "$EPUB" validate.epub
fi 

# validate 
# provides a detailed report on stdout

java -jar epubcheck-4.2.2/epubcheck.jar validate.epub

wait
echo "** all processes finished. **"
echo "done."
exit
