#!/bin/bash

cd "$(dirname "$0")"

s(){
	"$@" >/dev/null 2>&1 &
	disown
}

term(){
	gnome-terminal -e "$*"
}

pause(){
	echo
	echo -e "\033[0;32mOpération terminée, pour continuer appuyez sur ENTREE\033[0m"
	read
}

update-submodule(){
	git submodule update --remote --force --init publish
	(
		cd publish
		git checkout --detach
		git branch -D gh-pages
		git checkout -b gh-pages
	)
}

server=false

while true; do
	clear
	echo "100% massif"
	echo "==========="
	echo "0. Quitter"
	echo "1. Voir le site en cours de construction"
	echo "2. Construire le site"
	echo "3. Publier le site"
	echo
	echo -n "Choix: "
	read ans
	case "$ans" in
		r)
			exec "$0" "$@"
			;;
		0)
			exit 0
			;;
		1)
			if ! $server; then
				update-submodule
				s term hugo server
				server=true
			fi
			sleep 1
			s firefox http://localhost:1313/
			;;
		2)
			update-submodule
			s term hugo server
			server=true
			;;
		3)
			echo
			echo "Quelle modification avez vous faite ?"
			echo -n "Message : "
			read msg
			(
				update-submodule
				set -e -x
				hugo
				./deploy.sh
				git add -A
				git commit -m "${msg:-Automatic commit}"
				git remote -v
				git push origin HEAD
			)
			pause
			;;
		*)
			echo -n "Choix invalide, veuillez choir un numéro"
			sleep 0.5
			echo -n .
			sleep 0.5
			echo -n .
			sleep 0.5
			echo -n .
			sleep 0.5
			;;
	esac
done

