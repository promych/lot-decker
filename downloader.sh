MAJ=2
MIN=4
DDIR="G:/runeterra/runeterra_archives"
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
	)
rm -r $DDIR
mkdir $DDIR
for name in "${NAMES[@]}"
do
printf "https://dd.b.pvp.net/${MAJ}_${MIN}_0/${name}.zip\n" >> "${DDIR}/source.txt"
done
wget -P $DDIR -nv -i "${DDIR}/source.txt"
cmd /k