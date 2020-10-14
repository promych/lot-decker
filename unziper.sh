DDIR="G:/runeterra/runeterra_archives"
LNGS=(
	"en_us"
	"de_de"
	"fr_fr"
	"it_it"
	"es_es"
	"ru_ru"
	"tr_tr"
	)
for lng in "${LNGS[@]}"
do
	CORE=$( find "${DDIR}" -name "core-${lng}.zip" )
	unzip -j "${CORE}" "${lng}/data/globals-${lng}.json" -d "${DDIR}"
	for num in 1 2 3
	do
		SET=$( find "${DDIR}" -name "set${num}-lite-${lng}.zip" )
		unzip -j "${SET}" "${lng}/data/set${num}-${lng}.json" -d "${DDIR}"
	done
done
cmd /k