# epub-validate
Version 1.1.0
O-R-G inc.  

### INSTRUCTIONS

This is a simple .epub validator and .epub proof generator script. Requires Java and uses epub-check-4.2.2. The latest version of epub-check can be found here: 

https://github.com/w3c/epubcheck/releases/

(Also available via homebrew.)

The bash script:

+ requires either a compressed .epub or an uncompressed .epub/
+ if given a compressed .epub, then unzips files to make .epub/ and then zips files in correct sequence to make .epub
+ if given an uncompressed .epub, then zips files in correct sequence to make .epub and then unzips files to make .epub/
+ runs epub-check validator on the resulting packaged .epub
+ outputs two files: uncompressed as proof.epub and compressed as validate.epub plus detailed validation report on stdout

To run, simply
    
    ./__validate /path/to/your.epub

Also includes __package, a bespoke remote-resources packaging script

    ./__package /path/to/your.epub [-a] [-d] [-p]

--

### VERSION HISTORY
+ 1.0 -- June 2020 : initial version, possibly terminal
+ 1.1 -- July 2020 : add __package
