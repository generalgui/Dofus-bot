;-------------------------------------------------------------------------------
;                             MAIN
;-------------------------------------------------------------------------------


;==================== D�but du script ====================

#include "ChoixCouleur.au3"
#include "Audio.au3"
#include "Verification.au3"


; On initialise les variables en Global :

Global $Coord[2] ; On cr�� un tableau � 2 dimensions pour stocker les coordonn�es de la ressource d�tect�e plus bas.

Global $Compteur ; On cr�� un compteur pour stocker le nombre de fois que l'on envoie la commande pour couper la ressource.

Global $CompteurPods ; Idem que plus haut mais cette fois ci c'est pour stocker le nombre de fois que l'on coupe la ressource.

Global $TestVerif ; Variable pour tester si Verif() est lancer => prevention stack overflow

Global $Couleur = "avoine" ; Determine ressource recherch�. Disponible actuellement :  ble orge avoine fer cuivre ATTENTTION  TOUT MINUSCULE

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
;                                         Quitter
;-------------------------------------------------------------------------------

Func Bye()
	Exit 0
EndFunc   ;==>Bye