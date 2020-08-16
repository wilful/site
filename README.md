THEME=../../pelican-themes/waterspill; pushd src/; make html OUTPUTDIR=/srv/srv-nix.com/output/ PELICANOPTS="-t ${THEME}"; popd;
