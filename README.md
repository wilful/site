### Base action

    NOW=$(date +'%F %X %z')
    FNAME=src/content/$(uuidgen).md
    cat > $FNAME << EOF
    Title: "Default_title"
    Date: $NOW
    Category: linux
    Authors: Andrey Semenov
    Tags: Default_tag
    EOF
    vim $FNAME

### Simple run

    THEME=waterspill-en; pushd src/; make html OUTPUTDIR=/srv/srv-nix.com/output/ PELICANOPTS="-t ../themes/${THEME}"; popd;
