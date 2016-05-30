;==================== D�but du script ====================

#include "ChoixCouleur.au3"

; On initialise les variables en Global :

Global $Coord[2] ; On cr�� un tableau � 2 dimensions pour stocker les coordonn�es de la ressource d�tect�e plus bas.

Global $Compteur ; On cr�� un compteur pour stocker le nombre de fois que l'on envoie la commande pour couper la ressource.

Global $CompteurPods ; Idem que plus haut mais cette fois ci c'est pour stocker le nombre de fois que l'on coupe la ressource.

Global $TestVerif ; Variable pour tester si Verif() est lancer => prevention stack overflow

Global $Couleur = "orge" ; Determine ressource recherch�. Disponible actuellement :  ble orge avoine fer cuivre ATTENTTION  TOUT MINUSCULE

Global $SurbriCouleur ;Couleur quand ressource en surbrillance



$Compteur = 0 ;

;-------------------------------------------------------------------------------
;                           Raccourcis claviers
;-------------------------------------------------------------------------------

HotKeySet("{ESC}", "Bye") ; On assigne la fonction Bye (Pour quitter) � la touche 'Echap'

;-------------------------------------------------------------------------------
;                               Ouvre Dofus
;-------------------------------------------------------------------------------

WinActivate("Dofus")

;-------------------------------------------------------------------------------
;                            S'occupe de faucher
;-------------------------------------------------------------------------------

Fauchage()

Func Fauchage()

	$TestVerif = 0

	$MyColor = GetColor ($Couleur) ; Fonction qui return le code couleur de la ressource en 0xHexa

	$SpleepTime = Random(5000, 10000, 1) ; (tpsMin,tpsMax, 1 = nombre entier )


	$Coord = PixelSearch(0, 0, @DesktopWidth, @DesktopHeight, $MyColor, 1)
	; on recherche la couleur de la ressource. Les coordonn�s seront stock�es dans $Coord[0] et $Coord[1].

	If Not @error Then ; On v�rifie si la couleur a bien �t� trouv�e.

		$Compteur = $Compteur + 1 ; On ajoute 1 au compteur.
		$CompteurPods = $CompteurPods + 1 ; Idem


		MouseMove($Coord[0], $Coord[1]) ; On d�place la souris sur les coordonn�es de la ressource
		$Color = PixelGetColor($Coord[0], $Coord[1]) ; On r�cup�re la couleur sous la souris.
		Hex($Color, 6) ; On la convertie en Hexad�cimal


		If Not $Color = $SurbriCouleur Then Verif() ;Si la couleur sous le curseur n'est pas celle d'une ressource en surbrillance, on lance la fonction Verif().
		MouseClick("left", $Coord[0], $Coord[1]) ; On clique sur la ressource.


		Sleep(500) ; On attend 0,5secs.


		MouseMove($Coord[0] + 3, $Coord[1] + 35) ; On d�place la souris sur les coordonn�es de "faucher" (Qui est �gale aux coordonn�es de la ressource + 31 +51), la commande se met en subrillance (Orange)
		$Color = PixelGetColor($Coord[0] + 10, $Coord[1] + 51) ; On r�cup�re la couleur � l'endroit o� est normalement faucher.
		Hex($Color, 6) ; On convertit la couleur.


		If Not $Color = "FF6600" Then Verif() ; Si ce n'est pas la couleur de la commande Faucher en surbrillance on lance la fonction Verif().
		MouseClick("left", $Coord[0] + 10, $Coord[1] + 51) ; On clique sur Faucher.


		$Combat = PixelSearch(0, 0, @DesktopWidth, @DesktopHeight, 0x0000FF, 0) ; On recherche la couleur qui caracterise un combat lanc�(Bleu ou Rouge, ici Bleu)
		If Not @error Then Call("Bip") ; Si il n'y a pas d'erreur (Ce qui veut dire que la couleur est pr�sente) c'est que le combat est lanc�. Donc on lance la fonction qui Bip.

		Sleep(5000) ; On attend 5sec

		$Combat = PixelSearch(0, 0, @DesktopWidth, @DesktopHeight, 0x0000FF, 0) ; Si l'utilisateur n'a pas encore arr�t� le script et que le combat est en cours on relance le Bip
		If Not @error Then Call("Bip")

		Sleep($SpleepTime) ; Enfin, on attends le temps calcul� au hasard plus haut avant de lancer la Fonction Verif() qui v�rifiera si un combat est lanc�, une demande d'�change/invitation dans un groupe affich�, un message de lvl sup�rieur affich�,... Etc. Puis Verif() relanceras la fonction de Fauchage.

	EndIf

	if $TestVerif = 0 Then
		$TestVerif = 1
		;MsgBox(48, '"Entrer de verif"', "Entrer de verif ")
		Verif() ; On lance la fonction Verif.

	EndIf


EndFunc   ;==>Fauchage


;-------------------------------------------------------------------------------
;                     Verif()
;-------------------------------------------------------------------------------

Func Verif()

	While 1
		;MsgBox(48, '"Entrer de verif"', "Entrer de verif ")
		$Combat = PixelGetColor(593, 610) ; R�cup�re la couleur, si un combat est lanc�, la couleur est Orange.
		$Combat = Hex($Combat, 6)

		$niveau = PixelGetColor(940, 477) ; R�cup�re la couleur  o� se trouve le bouton Ok lors d'un message de passage � un niveau sup�rieur.
		$niveau = Hex($niveau, 6)

		$echange = PixelGetColor(657, 348) ; R�cup�re la couleur  o� se trouve le bouton Non lors d'une demande d'�change, invitation de groupe/guilde...
		$echange = Hex($echange, 6)

		If $CompteurPods = 10 Then ; On v�rifie si le compteur de nombres de fois que l'on a coup� des ressources est �gal � 10 ou variable choisi ( global dans future ? ).
			$CompteurPods = 0 ; Si c'est le cas, on remet le compteur � z�ro.
			MouseClick("left", 1272, 854, 1, 1) ; On clique sur le bouton pour ouvrir l'inventaire.
			Sleep(2000) ; On attend 2sec, le temps que l'inventaire s'ouvre.
			$Pods = PixelGetColor(1174, 448) ; On r�cup�re la couleur qui se trouve � l'endroit qui indique que l'inventaire est presque plein.
			$Pods = Hex($Pods, 6)
			If $Pods = 'FF6600' Then Call("Inventaireplein") ; On lance la fonction Inventraireplein si la couleur est Orange (la couleur de la barre de progression). coordonn�es � 90% de la barre histoire de ne pas �tre plein d'ici les 10 prochains coups
			$Pods = PixelGetColor(1194, 449) ; On recup�re la couleur � l'endroit qui indique si l'inventaire EST plein. 100% si on lance une s�rie pour la premiere fois alors qu'on a oubli� de vid�...
			$Pods = Hex($Pods, 6)
			If $Pods = 'FF6600' Then Call("Inventaireplein") ; On lance la fonction Inventaireplein... si l'inventaire est plein.
			MouseClick("left", 1583, 102, 1, 1) ; On clique sur fermer.
			Sleep(1000) ; On attend 1sec, le temps que l'inventaire se ferme.
		EndIf ; On ferme le If.

		If $Combat = '514A3C' Then Call("Fauchage") ; On teste si la couleur r�cup�r�e plus haut n'est pas celle qui indique un combat... (En fait on teste si le compteur pour cliquer sur 'Pr�t' d�file ou pas). Si le compteur ne d�file pas, c'est qu'il n'y a pas de combats.
		If $Combat = 'FF6100' Then Call("Bip") ; On teste si la couleur r�cup�r�e plus haut est celle qui indique un combat... (En fait on teste si le compteur pour cliquer sur 'Pr�t' d�file ou pas). Si le compteur d�file, c'est qu'il a un combat. On lance la fonction Bip().
		If $niveau = 'FF6100' Then Call("Niveau") ; On teste si le bouton Ok de passage � niveau est pr�sent, si c'est la cas, on lance la fonction Niveau().
		If $echange = 'FF6100' Then Call("Echange") ; On teste si le bouton Non des �changes/invitations de guildes/invitations de goupes est pr�sent, si c'est le cas, on lance la fonction Echange().

		$Combat = PixelSearch(0, 0, @DesktopWidth, @DesktopHeight, 0x0000FF, 0) ; On cherche la couleur bleu, qui indique q'un combat est en cours.
		If Not @error Then Call("Bip") ; Si la couleur est pr�sente, on lance la fonction Bip().
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
;                     S'occupe des �changes/duels/guildes
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
	MsgBox(48, '"Fauche-Bl�"', "Inventaire plein ! ")

	Exit 0
EndFunc   ;==>Inventaireplein

;-------------------------------------------------------------------------------
;                              S'occupe du BIP
;-------------------------------------------------------------------------------

Func Bip()



	Beep(349 * 2, 500)
	Beep(262 * 2, 500)
	Beep(349 * 2, 500)
	Beep(262 * 2, 500)
	Beep(294 * 2, 500)
	Sleep(10000)
	Beep(349 * 2, 500)
	Beep(262 * 2, 500)
	Beep(349 * 2, 500)
	Beep(262 * 2, 500)
	Beep(294 * 2, 500)
	Sleep(10000)
	Beep(349 * 2, 500)
	Beep(262 * 2, 500)
	Beep(349 * 2, 500)
	Beep(262 * 2, 500)
	Beep(294 * 2, 500)

	Exit 0 ; Exit...

EndFunc   ;==>Bip

;-------------------------------------------------------------------------------
;                                         Quitter
;-------------------------------------------------------------------------------

Func Bye()
	Exit 0
EndFunc   ;==>Bye