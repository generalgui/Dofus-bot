;-------------------------------------------------------------------------------
;                              S'occupe du BIP
;-------------------------------------------------------------------------------


#include <Sound.au3>


Func Bip()

	SoundPlay("son.mp3", 1) ; TODO Gestion couleur drapeau de marquage bleu sur mini map concidere comme en combat.... Prendre une autre couleur peut être?? Ou alors preciser coordonner precis via ratio...TODO
							; La couleur checker est le bleu des PA qui n'apparait qu'en combat...
	Exit 0

EndFunc