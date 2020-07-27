#!/bin/bash

# bespoke remote-resources packaging for a-pre-program-for-graphic-design.epub
# takes compressed .epub (as generated by indesign)
# unzips to make package.epub
# then finds and replaces to insert corrected video tags
# and correct refs to video and audio in content.opf
# outputs package.epub 
        
# sed -i (edit in place) requires .bak in bash
# also requires double quotes for substitution when includng variables
# for correct expansion and double escaping of newline character
# is necc for sed substitition multiple lines, add, or insert syntax
# sed s = substitute, sed a = add, sed i = insert
# sed s delimiter can be any character that follows s
# $1 = positional parameter (argument) 

DIR=$(pwd)
EPUB=$1
REMOTE="https\:\/\/a-pre-program-for-graphic-design.org\/media"
# REMOTE="http\:\/\/a-pre-program-for-graphic-design.local\/media\/"
REMOTE_SUB="small"
# REMOTE_SUB="large"
# AUDIO_ONLY=true
# DRYRUN=true

# unzip
if [[ $DRYRUN ]]
then
    PACKAGE=package-
    PACKAGE_BASEPATH=$PACKAGE.epub/OEBPS
    rm -r $PACKAGE.epub
    cp -r proof.epub $PACKAGE.epub
    wait
    echo "cp package-.epub done"
else
    PACKAGE=package
    PACKAGE_BASEPATH=$PACKAGE.epub/OEBPS
    rm -r $PACKAGE.epub
    echo "compressed .epub --> $EPUB"
    echo "unzip --> $PACKAGE.epub"
    mkdir $PACKAGE
    unzip -q "$EPUB" -d "$DIR/$PACKAGE"
    mv $PACKAGE $PACKAGE.epub
fi

for f in $PACKAGE_BASEPATH/*.xhtml
do
    FILEIN=$f
    # grep | sed | sed (returns format 'I-1.mp4')
    VIDEO_FILENAME=$(grep '.*-.*\.mp4' $FILEIN | sed 's:^.*src="video/::' | sed 's:" type.*::')
    if [[ $VIDEO_FILENAME ]]    # [[ ]] wraps condition in quotes
    then

        # 0. set basenames

        VIDEO_BASENAME=${VIDEO_FILENAME%.*}
        FILEIN_BASENAME=${FILEIN##*/}
        FILEIN_BASENAME=${FILEIN_BASENAME%.*}

        # 1. cp resources

        cp ../video/gif/_dots.gif $PACKAGE_BASEPATH/image/_dots.gif
        cp ../video/audio/$VIDEO_BASENAME.m4a $PACKAGE_BASEPATH/video/$VIDEO_BASENAME.m4a            
        rm $PACKAGE_BASEPATH/video/$VIDEO_BASENAME.mp4

        # 2. edit .xhthml

        # add preload, add poster
        sed -i.bak "s/controls=\"controls\">/controls=\"controls\" preload=\"auto\" poster=\"image\/_dots.gif\">/" $FILEIN

        # generate nginx http_secure_link_module hash
        HASH=`echo -n "$REMOTE_SUB/$VIDEO_BASENAME.mp4sauce" | openssl md5 -hex`

        # update source, add fallbacks (: = delimiter, tabs for spacing)
        sed -i.bak "s:<source src=\"video/$VIDEO_BASENAME.mp4\" type=\"video/mp4\" />:<source src=\"$REMOTE/$HASH/$REMOTE_SUB/$VIDEO_BASENAME.mp4\" type=\"video/mp4\" /> \\
                    <source src=\"video/$VIDEO_BASENAME.m4a\" type=\"audio/mp4\" /> \\
                    Sorry, your e-reader does not support multimedia content.:" $FILEIN

        # 3. edit .opf

        # add property remote-resources
        sed -i.bak "s/<item id=\"$FILEIN_BASENAME\" href=\"$FILEIN_BASENAME.xhtml\" media-type=\"application\/xhtml+xml\" \/>/<item id=\"$FILEIN_BASENAME\" href=\"$FILEIN_BASENAME.xhtml\" media-type=\"application\/xhtml+xml\" properties=\"remote-resources\" \/>/" $PACKAGE_BASEPATH/content.opf

        # update resources, remote and local
        sed -i.bak "s/<item id=\"$VIDEO_BASENAME.mp4\" href=\"video\/$VIDEO_BASENAME.mp4\" media-type=\"video\/mp4\" \/>/<item id=\"$VIDEO_BASENAME.mp4\" href=\"$REMOTE\/$HASH\/$REMOTE_SUB\/$VIDEO_BASENAME.mp4\" media-type=\"video\/mp4\" \/> \\
        <item id=\"$VIDEO_BASENAME.m4a\" href=\"video\/$VIDEO_BASENAME.m4a\" media-type=\"audio\/mp4\" \/>/" $PACKAGE_BASEPATH/content.opf
    fi
done

# add _dots.gif
# (note sed BSD syntax)
sed -i.bak "/<item id=\"toc\"/a\\ 
\ \ \ \ \ \ \ \ <item id=\"_dots.gif\" href=\"image/_dots.gif\" media-type=\"image/gif\" />\\
" $PACKAGE_BASEPATH/content.opf

# clean up *.bak
rm -r $PACKAGE_BASEPATH/*.bak

# ls .epub contents
ls -R $PACKAGE.epub/

wait
echo "** all processes finished. **"
echo "done."
exit
