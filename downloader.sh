MAJ=4
MIN=1
DDIR="D:/runeterra/runeterra_archives"
NAMES=(
	"core-en_us"
	"core-es_es"
	"core-de_de"
	"core-fr_fr"
	"core-it_it"
	"core-ru_ru"
	"core-tr_tr"
	"set1-lite-en_us"
	"set1-lite-es_es"
	"set1-lite-de_de"
	"set1-lite-fr_fr"
	"set1-lite-it_it"
	"set1-lite-ru_ru"
	"set1-lite-tr_tr"
	"set2-lite-en_us"
	"set2-lite-es_es"
	"set2-lite-de_de"
	"set2-lite-fr_fr"
	"set2-lite-it_it"
	"set2-lite-ru_ru"
	"set2-lite-tr_tr"
	"set3-lite-en_us"
	"set3-lite-es_es"
	"set3-lite-de_de"
	"set3-lite-fr_fr"
	"set3-lite-it_it"
	"set3-lite-ru_ru"
	"set3-lite-tr_tr"
	"set4-lite-en_us"
	"set4-lite-es_es"
	"set4-lite-de_de"
	"set4-lite-fr_fr"
	"set4-lite-it_it"
	"set4-lite-ru_ru"
	"set4-lite-tr_tr"
	"set5-lite-en_us"
	"set5-lite-es_es"
	"set5-lite-de_de"
	"set5-lite-fr_fr"
	"set5-lite-it_it"
	"set5-lite-ru_ru"
	"set5-lite-tr_tr"
	"set6-lite-en_us"
	"set6-lite-es_es"
	"set6-lite-de_de"
	"set6-lite-fr_fr"
	"set6-lite-it_it"
	"set6-lite-ru_ru"
	"set6-lite-tr_tr"
	"set6cde-lite-en_us"
	"set6cde-lite-es_es"
	"set6cde-lite-de_de"
	"set6cde-lite-fr_fr"
	"set6cde-lite-it_it"
	"set6cde-lite-ru_ru"
	"set6cde-lite-tr_tr"
	)
rm -r $DDIR
mkdir $DDIR
for name in "${NAMES[@]}"
do
printf "https://dd.b.pvp.net/${MAJ}_${MIN}_0/${name}.zip\n" >> "${DDIR}/source.txt"
done
wget -P $DDIR -nv -i "${DDIR}/source.txt"
exit