;-------------------------------------------------------------------------------
;                              Les Vérification et Check Interaction Social
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;                     Verif()
;-------------------------------------------------------------------------------

Func Verif()

	While 1
		;MsgBox(48, '"Entrer de verif"', "Entrer de verif ")
		$Combat = PixelGetColor(593, 610) ; Récupère la couleur, si un combat est lancé, la couleur est Orange.
		$Combat = Hex($Combat, 6)

		$niveau = PixelGetColor(940, 477) ; Récupère la couleur  où se trouve le bouton Ok lors d'un message de passage à un niveau supérieur.
		$niveau = Hex($niveau, 6)

		$echange = PixelGetColor(657, 348) ; Récupère la couleur  où se trouve le bouton Non lors d'une demande d'échange, invitation de groupe/guilde...
		$echange = Hex($echange, 6)

		If $CompteurPods = 10 Then ; On vérifie si le compteur de nombres de fois que l'on a coupé des ressources est égal à 10 ou variable choisi ( global dans future ? ).
			$CompteurPods = 0 ; Si c'est le cas, on remet le compteur à zéro.
			MouseClick("left", 1272, 854, 1, 1) ; On clique sur le bouton pour ouvrir l'inventaire.
			Sleep(2000) ; On attend 2sec, le temps que l'inventaire s'ouvre.
			$Pods = PixelGetColor(1174, 448) ; On récupère la couleur qui se trouve à l'endroit qui indique que l'inventaire est presque plein.
			$Pods = Hex($Pods, 6)
			If $Pods = 'FF6600' Then Call("Inventaireplein") ; On lance la fonction Inventraireplein si la couleur est Orange (la couleur de la barre de progression). coordonnées à 90% de la barre histoire de ne pas être plein d'ici les 10 prochains coups
			$Pods = PixelGetColor(1194, 449) ; On recupère la couleur à l'endroit qui indique si l'inventaire EST plein. 100% si on lance une série pour la premiere fois alors qu'on a oublié de vidé...
			$Pods = Hex($Pods, 6)
			If $Pods = 'FF6600' Then Call("Inventaireplein") ; On lance la fonction Inventaireplein... si l'inventaire est plein.
			MouseClick("left", 1583, 102, 1, 1) ; On clique sur fermer.
			Sleep(1000) ; On attend 1sec, le temps que l'inventaire se ferme.
		EndIf ; On ferme le If.

		If $Combat = '514A3C' Then Call("Fauchage") ; On teste si la couleur récupérée plus haut n'est pas celle qui indique un combat... (En fait on teste si le compteur pour cliquer sur 'Prêt' défile ou pas). Si le compteur ne défile pas, c'est qu'il n'y a pas de combats.
		If $Combat = 'FF6100' Then Call("Bip") ; On teste si la couleur récupérée plus haut est celle qui indique un combat... (En fait on teste si le compteur pour cliquer sur 'Prêt' défile ou pas). Si le compteur défile, c'est qu'il a un combat. On lance la fonction Bip().
		If $niveau = 'FF6100' Then Call("Niveau") ; On teste si le bouton Ok de passage à niveau est présent, si c'est la cas, on lance la fonction Niveau().
		If $echange = 'FF6100' Then Call("Echange") ; On teste si le bouton Non des échanges/invitations de guildes/invitations de goupes est présent, si c'est le cas, on lance la fonction Echange().

		$Combat = PixelSearch(0, 0, @DesktopWidth, @DesktopHeight, 0x0000FF, 0) ; On cherche la couleur bleu, qui indique q'un combat est en cours.
		If Not @error Then Call("Bip") ; Si la couleur est présente, on lance la fonction Bip().
		Sleep(100) ; On attend 0,1 secondes.

		Call("Fauchage") ; Si on arrive la, c'est que tout va bien

	WEnd
	;MsgBox(48, '"Sortie de verif"', "Sortie de verif ")
	$TestVerif = 0

EndFunc   ;==>Verif

;-------------------------------------------------------------------------------
;                     S'occupe du passage au niveau sup.
;-------------------------------------------------------------------------------

Func Niveau()
	MouseClick("", 940, 477) ; On clique sur Ok et on relance la fonction Verif() au cas ou... Si tout vas bien, Verif() relancera la fonction Fauchage() qui relancera la fonction Verif etc.
	Verif()
EndFunc   ;==>Niveau

;-------------------------------------------------------------------------------
;                     S'occupe des échanges/duels/guildes
;-------------------------------------------------------------------------------

Func Echange()
	MouseClick("", 940, 477, 1, 0) ; On clique sur non et on relance la fonction Verif() au cas ou...
	Verif()
EndFunc   ;==>Echange


;-------------------------------------------------------------------------------
;   S'occupe d'afficher un message quand l'inventaire est plein
;-------------------------------------------------------------------------------

Func Inventaireplein()
	MouseClick("left", 1583, 102, 1, 1) ; On clique sur la croix de l'inventaire pour le fermer.
	MsgBox(48, '"Fauche-Blé"', "Inventaire plein ! ")

	Exit 0
EndFunc   ;==>Inventaireplein
