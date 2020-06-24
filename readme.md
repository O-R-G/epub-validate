# epub-validate
Version 1.0.0
O-R-G inc.  
Last updated 24 June 2020

## INSTRUCTIONS

This is a simple .epub validator and .epub proof generator script. Requires Java and uses epub-check-4.2.2. The latest version of epub-check can be found here: 

https://github.com/w3c/epubcheck/releases/

The bash script:

+ requires compressed .epub or uncompressed .epub/
+ zip files in correct sequence to make .epub
+ then run epubcheck validator on result
+ outputs 2 files
+ uncompressed as proof.epub
+ compressed as validate.epub
_ and validation report on stdout

To run, simply 

	admin : add, edit, and delete entries plus edit HTML
	main  : add, edit, and delete entries
	guest : view entries only, cannot modify

### EDIT . . .

--

### NOTES

1. As you use this interface, it should become increasingly transparent to you. As you work in OPEN-RECORDS-GENERATOR, use the GENERATE > button consistently to check your work and to see live changes you have just made to your website.
2. OPEN-RECORDS-GENERATOR automatically sorts object lists based on each object's fields. Objects are sorted by their Rank (ascending) field. So, to make a RECORD appear first in the Menu, give it a RANK of 1. Alternately, you could rank your RECORDS 100, 200, 300 and they would still appear in ascending order. Doing it this way makes it easier to add new RECORDS in between as needed without re-ranking the list.
3. OPEN-RECORDS-GENERATOR supports rich text editing within its Synopsis, Detail, and Notes fields. You are easily able to make text bold, add links, and embed images that are uploaded to that record. You can also use toggle the field mode to allow for HTML markup. This will allow you to use the full extent of the HTML markup language, including <embed> tags, such as from youtube.com, vimeo, issuu or other sites. 
4. RECORDS can be hidden from the website by prepending a "." to the Name field. This will make it still accessible to those with a direct URL and editable, but will not be shown in other parts of the website.

## VERSION HISTORY
+ 1.0 -- June 2020 : initial version, possibly terminal
