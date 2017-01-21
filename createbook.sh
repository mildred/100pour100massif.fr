#!/bin/bash

cd "$(dirname "$0")"
export PATH="$PATH:$PWD/bin"

prefix="$(sed -e '/galleryimage/,// d' content/photos.html)"
suffix="$(sed -e '0,/\/gallery/ d' content/photos.html)"
images=()

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

  if ! [[ -e "$copyright" ]]; then
    copyright="${image%/*}/copyright.txt"
  fi

  if ! [[ "$image" -ot "$thumbnail" ]]; then
    convert -quiet "$image" -thumbnail 250x250 +repage -unsharp 0x.5 -quality 80 "$thumbnail"
  fi

  if [[ -e "$copyright" ]]; then
    copyright="$(cat "$copyright")"
  else
    copyright=
  fi
  if [[ -e "$caption" ]]; then
    caption="$(cat "$caption")"
  else
    caption=
  fi
  image="/${image#static/}"
  thumbnail="/${thumbnail#static/}"
  images+=("{{% galleryimage file=\"$image\" size=\"$size\" thumbnail=\"$thumbnail\" caption=\"$caption\" copyrightHolder=\"$copyright\" %}}")
done

exec >content/photos.html
echo "$prefix"
for line in "${images[@]}"; do
  echo "$line"
done
echo "$suffix"
