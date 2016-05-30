#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.8.0
 Auteur:         MonNom

 Fonction du Script :
	Mod�le de Script AutoIt.

#ce ----------------------------------------------------------------------------

; D�but du script - Ajouter votre code ci-dessous.

Func GetColor ($Couleur)

	;RAPPEL COULEUR:

	;FERMIER
	;Couleur du ble 0xF5CC12
	;Couleur Orge 0x546800
	;Couleur Avoine 0xC76E00

	;MINEUR
	;Couleur Fer 0xE3E2D1
	;Couleur Cuivre 0xD38440


	;RAPPEL SURBRILLANCE:
	; ble surbrillance E2C95A
	; orge surbrillance 8CD342
	; fer surbrillance BCBBB2

	Switch $Couleur
		Case "orge"

			$SurbriCouleur = "8CD342"
			return 0x546800

	Case "ble"

		$SurbriCouleur = "E2C95A"
		 return 0xF5CC12

	Case "avoine"

		$SurbriCouleur = "" ; TODO surbri avoine
		 return 0xC76E00

	Case "fer"
		$SurbriCouleur = "BCBBB2"
		 return 0xE3E2D1

	Case "cuivre"

		$SurbriCouleur = "" ; TODO surbri cuivre
		 return 0xD38440


     Case Else
         MsgBox(0, "ErreurGetColor", "$Couleur est inconnu")
		 Exit 0

	EndSwitch

EndFunc
