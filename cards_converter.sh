for file in assets/img/cards/*.png
do
"C:\Program Files\libwebp\bin\cwebp.exe" -q 80 "$file" -o "${file%.png}.webp"
done