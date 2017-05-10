#!/bin/bash

cd "$(dirname "$0")"
export PATH="$PATH:$PWD/bin"

prefix="$(sed -n -e '0,/gallery title/ p' content/photos.html)"
suffix="$(sed -n -e '/< .gallery/,// p' content/photos.html)"
images=()

for image in static/images/gallery/*; do
  case "$image" in
    *.thumbnail.*)
      if ! [ -e "${image//.thumbnail./.}" ]; then
        rm -f "$image"
      fi
      ;;
  esac
done

for image in static/images/gallery/*; do
  case "$image" in
    *.thumbnail.*|*.txt)
      continue
      ;;
  esac

  caption="${image%.*}.txt"
  copyright="${image%.*}.copyright.txt"
  thumbnail="${image%.*}.thumbnail.${image##*.}"
  size="$(identify -ping -format "%wx%h" "$image")"
  orient="$(identify -verbose "$image" | grep exif:Orientation | xargs sh -c 'echo "$1"')"

  if ! [[ -e "$copyright" ]]; then
    copyright="${image%/*}/copyright.txt"
  fi

  if ! [[ "$image" -ot "$thumbnail" ]] || [[ "$1" -nt "$thumbnail" ]]; then
    convert -quiet "$image" -thumbnail 250x250 +repage -unsharp 0x.5 -quality 80 -auto-orient "$thumbnail"
  fi

  if [[ -e "$copyright" ]]; then
    copyright="$(cat "$copyright" | tr '\n' ' ')"
  else
    copyright=
  fi
  if [[ -e "$caption" ]]; then
    caption="$(cat "$caption" | tr '\n' ' ')"
  else
    caption=
  fi
  image="/${image#static/}"
  thumbnail="/${thumbnail#static/}"
  images+=("{{% galleryimage file=\"$image\" size=\"$size\" thumbnail=\"$thumbnail\" caption=\"$caption\" copyrightHolder=\"$copyright\" orientation=\"$orient\" %}}")
  echo "$image"
done

tmpfile=/tmp/$$

(
echo "$prefix"
echo "<!-- gallery -->"
for line in "${images[@]}"; do
  echo "$line"
done
echo "<!-- end gallery -->"
echo "$suffix"
) >"$tmpfile"

if ! cmp "$tmpfile" content/photos.html >/dev/null; then
  mv "$tmpfile" content/photos.html
else
  rm -f "$tmpfile"
fi
