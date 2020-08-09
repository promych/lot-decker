for file in assets/img/champions/*.webp
do
"C:\Program Files\libwebp\bin\cwebp.exe" -crop 10 10 100 100 -resize 120 120 "$file" -o "$file"
done