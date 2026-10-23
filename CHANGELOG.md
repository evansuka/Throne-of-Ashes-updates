# Modifications des versions Windows

## 0.14.3 — publiée le 23 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.3).

- Écrire **Blue** dans le chat du village appelle Blue : il vient, s’assoit et jappe deux fois.
- Blue se relève et suit les déplacements pendant deux minutes de jeu actif à compter de son arrivée. Le délai ne se prolonge pas à chaque déplacement ; un nouvel appel relance le comportement.
- **Bleu** ne déclenche pas l’easter egg. La casse et les espaces autour de Blue sont tolérés.
- Pose assise et orientation corrigées ; le sprite assis ne sert plus d’image de marche.
- Bouton **Chat** en bas à gauche lorsque le panneau est fermé ; ouverture par clic ou Entrée, fermeture par la croix ou Échap.
- Fond du chat semi-transparent et texte opaque ; grand panneau au-dessus de la barre de compétences pour garder les commandes accessibles.
- Tests supplémentaires de navigation, de jappements et de délai ; captures Godot réelles et validation du paquet sur Windows. Sauvegardes conservées.

La fermeture signalée après environ 30 secondes de partie reste en cours de diagnostic, en attente des journaux du PC concerné. Aucun correctif de cette fermeture n’est annoncé dans cette version.

## 0.14.2 — publiée le 23 octobre 2026

[Télécharger le nouveau lanceur](https://github.com/evansuka/Throne-of-Ashes-updates/releases/download/v0.14.2/Throne-of-Ashes.exe). [Notes de la release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.2). Validation Windows réussie, dont 32 contrôles de la vraie fenêtre du lanceur ; quatre fichiers publics vérifiés par SHA-256.

- Opérations lourdes du lanceur en arrière-plan et affichage précis de la vérification, de l’extraction, de l’activation et du démarrage.
- Une erreur de lancement n’entraîne plus une seconde tentative automatique.
- Le jeu affiche les mises à jour disponibles sans se fermer ni ouvrir automatiquement le lanceur.
- Journaux de diagnostic `launcher.log` et `game.log` dans `%LOCALAPPDATA%/ThroneOfAshes`.
- Validation de la véritable fenêtre sur Windows, avec installation lente, panne de connexion, archive corrompue et erreur de démarrage ; sauvegardes conservées.

**Important :** remplacer l’ancien fichier du lanceur par le nouveau `Throne-of-Ashes.exe` de la release. Le jeu ne remplace pas automatiquement ce fichier sur le bureau. Ne pas supprimer les sauvegardes pour dépanner.

## 0.14.1 — 23 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.1).

- Démarche avec deux jambes articulées et des pieds moins écartés de face.
- Cadence des pas moins rapide, sans changer la vitesse de déplacement.
- Orientation stabilisée dans les huit directions pendant les déplacements et les transitions vers le combat.
- Sac repositionné vers le dos et affiné de profil ; profondeur du sac et du carquois adaptée à l'orientation.
- Poignées d'armes maintenues sur les véritables points de prise des mains, y compris lorsqu'une main est cachée.
- Contrôles supplémentaires sur les quatre classes, les différents équipements, les appuis des pieds et les prises d'armes.
- Notes détaillées incluses dans les archives ; vérification des paquets sur Windows avant activation de la release.

Les sauvegardes existantes sont conservées. Le multijoueur natif reste à terminer.

## 0.14.0

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.0). Récapitulatif des changements déjà décrits lors de cette livraison :

- Inventaire stabilisé, avec aperçu vert/rouge des cases pendant le déplacement d'objets.
- Réserve de ceinture corrigée pour ne plus recouvrir les fenêtres.
- Menus de dialogue explicites pour les six PNJ, avec accès aux services et quêtes.
- Douze histoires originales, avec distinction des sujets lus et non lus, mémorisée par héros.
- Lueur de survol des cibles interactives.
- Activation des PNJ uniquement par clic explicite, sans ouverture par contact ou pendant la marche par clic maintenu.
- Conservation des sauvegardes existantes ; chat Partie local en solo.

Les versions antérieures restent décrites dans [leurs releases GitHub](https://github.com/evansuka/Throne-of-Ashes-updates/releases).
