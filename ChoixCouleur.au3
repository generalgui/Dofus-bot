#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.8.0
 Auteur:         MonNom

 Fonction du Script :
	Modèle de Script AutoIt.

#ce ----------------------------------------------------------------------------

; Début du script - Ajouter votre code ci-dessous.

Func GetColor ($Couleur)

	;RAPPEL :

	;FERMIER
	;Couleur du ble 0xF5CC12
	;Couleur Orge 0x546800
	;Couleur Avoine 0xC76E00

	;MINEUR
	;Couleur Fer 0xE3E2D1
	;Couleur Cuivre 0xD38440

	Switch $Couleur
     Case "orge"


	Case "ble"

		 return 0xF5CC12

	Case "avoine"

		 return 0xC76E00

	Case "fer"

		 return 0xE3E2D1

	Case "cuivre"

		 return 0xD38440


     Case Else
         MsgBox(0, ErreurGetColor", "$Couleur est inconnu")

	EndSwitch

EndFunc
