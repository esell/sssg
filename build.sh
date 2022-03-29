#!/bin/bash

#########################################################
# this is a fucking train wreck and you should not
# be using this. this is one of those projects that
# was done just to say that i had done it. you are
# going to see some scary stuff, some stuff you might
# not be able to un-see. 
# there are many assumptions made with this, and if
# you stray from those assumptions... well, may
# god have mercy on your soul.
#########################################################

BASE_URL="https://esheavyindustries.com/"
BASE_DIR="$PWD"
INPUT_DIR="$BASE_DIR/drafts"
OUT_DIR="$BASE_DIR/pub"
TEMPLATE_DIR="$BASE_DIR/templates"
STATIC_DIR="$BASE_DIR/static"

if [ ! -d "$OUT_DIR" ]; then
    mkdir -p "$OUT_DIR"
fi

if [ -f "all-posts.md" ]; then
    echo "deleting all-post.md..."
    rm "all-posts.md"
fi

if [ -f "postlist.md" ]; then
    echo "deleting postlist.md..."
    rm "postlist.md"
fi

# generate posts from markdown and die a little 
# on the inside
for file in `ls $INPUT_DIR`; do
    if [ -f "$INPUT_DIR/$file" ]; then
        OUT_FILE="${file%.*}"
        echo "generating $file"
        
        # date nonsense
        POST_DATE_RAW=`sed -n '/^[dD]ate:/p' $INPUT_DIR/$file`
        IFS=':' read -r -a POST_DATE_ARRAY <<< "$POST_DATE_RAW"
        POST_DATE_CLEAN="$(echo -e "${POST_DATE_ARRAY[1]}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
        SORTDATE=$(date -d "$POST_DATE_CLEAN" +%s)
        
        # title nonsense
        POST_TITLE_RAW=`sed -n '/^[tT]itle:/p' $INPUT_DIR/$file`
        IFS=':' read -r -a POST_TITLE_ARRAY <<< "$POST_TITLE_RAW"
        POST_TITLE_CLEAN="$(echo -e "${POST_TITLE_ARRAY[1]}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

        # safety first!
        unset IFS

        pandoc -o "$OUT_DIR/$OUT_FILE.html" -B "$TEMPLATE_DIR/header.html" -A "$TEMPLATE_DIR/footer.html" --template "$TEMPLATE_DIR/single.html" "$INPUT_DIR/$file"

        POST_SUMMARY=`grep -m 1 -P -o '(?<=<p>).*(?=</p>)' $OUT_DIR/$OUT_FILE.html |cut -d ' ' -f 1-40 | sed -e 's/<[^>]*>//'`
        echo "$SORTDATE%%$POST_TITLE_CLEAN%%/$OUT_FILE.html%%$POST_DATE_CLEAN%%$POST_SUMMARY..." >> "$BASE_DIR/all-posts.md"
    fi
done

# generate index
# this right here is a fucking masterpiece
echo "---" > "$BASE_DIR/postlist.md"
echo "posts:" >> "$BASE_DIR/postlist.md"
while read LINE; do
    echo "$LINE" | awk 'BEGIN{FS="%%"};{print "- title: "$2}' >> "$BASE_DIR/postlist.md"
    echo "$LINE" | awk 'BEGIN{FS="%%"};{print "  date: "$4}' >> "$BASE_DIR/postlist.md"
    echo "$LINE" | awk 'BEGIN{FS="%%"};{print "  link: "$3}' >> "$BASE_DIR/postlist.md"
    echo "$LINE" | awk 'BEGIN{FS="%%"};{print "  summary: "$5}' >> "$BASE_DIR/postlist.md"
done < <(sort -nr $BASE_DIR/all-posts.md)
echo "---" >> "$BASE_DIR/postlist.md"

pandoc -o "$OUT_DIR/index.html" -B "$TEMPLATE_DIR/header.html" -A "$TEMPLATE_DIR/footer.html" --template "$TEMPLATE_DIR/index.html" --metadata title="|| es Heavy Industries ||" "$BASE_DIR/postlist.md"

# copy over static stuff
cp -r "$STATIC_DIR" "$OUT_DIR/"
