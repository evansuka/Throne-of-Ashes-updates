# Modifications des versions Windows

## 0.14.9 — publiée le 23 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.9).

- Démarrage coordonné : le nouveau lanceur démarre le jeu réduit, attend sa confirmation avec le même identifiant de processus, termine son travail et masque sa fenêtre avant d’afficher le jeu. Aucun second lancement automatique ; contrôle des instances déjà ouvertes, y compris l’ancien nom de l’export.
- Secours sonore Windows lorsque l’initialisation WASAPI échoue et que Godot utilise le pilote muet Dummy. Lecture alternative des musiques, bruitages et voix par Windows MCI, avec les volumes existants et un arrêt lié au processus du jeu, sans redémarrer celui-ci.
- Les objets au sol ont une représentation visible ; leurs noms restent cachés par défaut. Maintenir ALT révèle les noms, relâcher ALT les masque. Dans Options, ALT verrouillé permet de basculer leur affichage à chaque pression. Le butin reste ramassable sans afficher son nom.
- Nouvelle illustration du pantalon de cuir, étroite et proportionnée, sur fond transparent ; l’illustration d’inventaire ne déforme pas l’équipement porté par le personnage.
- Les ennemis tués laissent leur corps allongé, une flaque et des éclaboussures de sang. Les corps n’ont ni collision ni barre de vie et sont restaurés lors d’un retour dans l’étage. Conservation plafonnée à 96 corps par étage.
- Chat redimensionnable par la poignée en haut à droite : tirer vers le haut et la droite pour agrandir, avec limites d’écran. Taille conservée lors de la fermeture/réouverture pendant la session ; déplacement toujours disponible.
- REVOIR L’INTRODUCTION déplacé de la colonne des personnages vers Options, disponible seulement pour un héros ayant déjà terminé ou passé sa première lecture. En partie, la relecture suspend le monde puis revient aux options.
- Marges intérieures des panneaux augmentées pour maintenir les objets et les descriptions à l’intérieur de la bordure artistique.

Le journal PC de 0.14.8 a confirmé une erreur WASAPI 0x80070006 suivie du pilote Dummy ; changer seulement le volume ne pouvait pas rendre le son. Le secours Windows est vérifié pour son intégration et son routage ; la sortie physique du PC reste à confirmer. Les journaux du lanceur montrent encore la version 0.14.2 et plusieurs démarrages séparés : ils ne permettent pas d’établir à eux seuls pourquoi le processus du jeu se serait fermé.

**Remplacer le lanceur du bureau par le nouveau `Throne-of-Ashes.exe` de cette release**, toutes ses fenêtres fermées. La mise à jour automatique du jeu ne remplace pas cet ancien fichier. Les sauvegardes sont conservées. En cas d’échec du secours audio, ses journaux sont dans le cache Windows, sous `ThroneOfAshes/audio-fallback/<PID>/audio-fallback.log`.

## 0.14.8 — publiée le 23 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.8).

- Protection contre un second lancement de partie lorsque le héros est déjà en jeu. Journaux enrichis avec version, identifiant du processus, pilote audio et durée de création du processus par le lanceur.
- Musique ajoutée aux donjons avec la piste sombre existante ; reprise si une piste s’arrête ou reste suspendue. Options : test des bruitages et réinitialisation de la sortie audio, sans changer les volumes choisis.
- Taille réduite des ennemis humains ordinaires aux étages 1 à 20, proche de celle du héros ; foulée plus naturelle, appuis alternés, mouvement des bras et respiration légère.
- Orientation des sprites plats corrigée, notamment Éléane et les ennemis : les profils suivent maintenant le sens réel du déplacement. Le rig du héros, ses armes et son sac restent préservés.
- Chat initialement dans le véritable coin inférieur gauche, panneau compact et semi-transparent, toujours déplaçable. La position par défaut suit les changements de taille de fenêtre tant que le joueur ne l’a pas déplacé.
- Le contenu du sac à dos s’ouvre à gauche et conserve l’inventaire à droite ; les transferts actualisent les deux fenêtres. Un nouveau héros commence sans sac : il doit en trouver et équiper un. Les sacs et objets des sauvegardes existantes sont conservés.
- Cendres un peu plus nombreuses uniquement au village, toujours discrètes ; réglages de qualité et Effets réduits conservés.
- Échap ouvre un menu fonctionnel depuis l’accueil et permet d’y revenir ; les options restent accessibles.
- Bouton QUÊTES dans le menu Échap en partie ; journal regroupant les quêtes en cours et terminées.

Le journal PC reçu montre un seul démarrage de Godot et plusieurs entrées en campagne, sans erreur fatale visible : la cause exacte de la fermeture/réouverture signalée reste à confirmer. Cette version ne prétend pas corriger un crash graphique établi. Les vérifications cloud ne valident pas les haut-parleurs du PC.

**Lanceur :** le PC utilisait encore le lanceur 0.14.2 pour installer le jeu 0.14.7. La mise à jour du jeu ne remplace pas le fichier du lanceur sur le bureau. Télécharger le nouveau `Throne-of-Ashes.exe` de cette release et remplacer l’ancienne copie, toutes les fenêtres du lanceur fermées. Les sauvegardes restent conservées.

## 0.14.7 — publiée le 23 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.7).

- Premier volet des **Murmures des Cendres** : cinématique d’ouverture de **57 secondes** consacrée à Eldharyn et à sa destruction inexpliquée.
- Quatre illustrations originales : la cité avant la chute, le silence nocturne, les ruines et les survivants, puis Havrebrume sous les cendres. Transitions douces, ouverture et fermeture au noir.
- Narration française synthétique masculine, grave et posée, avec sous-titres complets. Aucune cause ni identité responsable du désastre n’est dévoilée.
- Accompagnement musical discret et réglages de volume existants : Musique pour l’accompagnement, Bruitages pour la voix, Volume général pour les deux.
- Lecture au premier lancement d’une partie pour chaque héros ; **PASSER** ou **Échap** permet de poursuivre immédiatement. La lecture terminée ou passée est mémorisée dans la sauvegarde du héros.
- Bouton **VOIR L’INTRODUCTION** dans le menu pour revoir le prologue ; cette lecture revient au menu et ne lance pas de partie.
- La campagne reste à l’arrêt pendant la cinématique ; le décor 3D est masqué pour éviter un rendu inutile derrière les illustrations. Les voix et la musique s’arrêtent proprement à la sortie.
- Contrôles de synchronisation, de décodage des quatre voix, de sauvegarde du marqueur par héros et de retour au jeu/menu ; captures du véritable rendu Godot et crédits des ressources conservés.

Priorité 1 livrée : le prologue. La quête du prêtre, les trois documents, les nouveaux dialogues et la scène après le premier boss restent à venir. La fermeture après 30 secondes de gameplay reste en cours de diagnostic ; aucun correctif de cet arrêt annoncé ici.

## 0.14.6 — publiée le 23 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.6).

- **Blue** ne vient et ne suit le personnage que lorsqu’on écrit `Blue` dans le chat. Cliquer sur le chien ne déclenche plus l’appel ; `Bleu` reste ignoré.
- **Sélection à la souris :** contour doré fin et discret suivant la silhouette réelle des PNJ, du chien, des coffres, des accès et du butin ; suppression des cadres rectangulaires autour des objets. Projection de sélection alignée sur la caméra du jeu.
- **Touches C et I :** une première pression ouvre Personnage ou Inventaire, une seconde referme la même fenêtre. Les deux fenêtres restent utilisables indépendamment ; I referme aussi le sous-écran Sac à dos.
- **Marchand :** ouvrir Commerce affiche aussi l’inventaire et l’équipement à droite. Achats, ventes et modifications de l’inventaire actualisent les fenêtres et l’or affiché.
- **Chat :** onglet Partie par défaut, fenêtre initialement en bas à gauche et déplaçable par sa barre de titre, position conservée pendant la session et déplacement limité à l’écran. Le fond reste semi-transparent.
- **Entrée :** envoie et efface le message en gardant le chat ouvert et le champ actif. Une entrée vide ne ferme pas la fenêtre. La croix et Échap ferment toujours le chat.
- **Grotte :** dégagement des arbres qui masquaient l’entrée et son approche dans la vue isométrique, avec mise à jour de la navigation du village.
- Contrôles supplémentaires des clics, des touches, des transactions, de la saisie réelle et du glissement du chat ; captures du véritable rendu Godot. Les sauvegardes existantes sont conservées.

La fermeture signalée après environ 30 secondes de partie reste en cours de diagnostic ; aucun correctif de cet arrêt n’est annoncé ici.

## 0.14.5 — publiée le 23 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.5).

- Quelques cendres grises tombent du ciel lentement, avec une dérive et une apparition aléatoires, uniquement dans le village de Havrebrume.
- Petits flocons espacés et peu opaques pour préserver la visibilité du décor et des personnages.
- Aucun effet à l’accueil ni en donjon ; suspension pendant la pause et reprise au retour au village.
- Densité liée aux réglages de qualité existants, encore réduite avec Effets réduits ; maximum de 36 particules, sans collisions, lumières ni ombres supplémentaires.
- Contrôles des changements de zone et de la pause, captures Godot inspectées, archives et lanceur vérifiés sur Windows. Sauvegardes conservées.

L’incident de fermeture après environ 30 secondes de partie reste en cours de diagnostic ; aucun correctif de cet arrêt n’est annoncé ici.

## 0.14.4 — publiée le 23 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.4).

- Voix du prêtre au clic : « Que les dieux soient avec vous ».
- Voix du marchand au clic : « Bonjour, comment puis-je vous aider ? ».
- Lecture à l’ouverture du dialogue du PNJ sélectionné, après l’approche si nécessaire ; aucune salutation au simple contact ni pendant la marche maintenue.
- Une seule voix de PNJ à la fois. Les clics répétés ne superposent pas les phrases et les sous-menus ne les rejouent pas.
- La phrase du marchand peut se terminer pendant l’ouverture du commerce. Les voix s’arrêtent au retour à l’accueil ou au changement de zone.
- Volume réglé par Bruitages et par le volume général. Les deux MP3 fournis sont conservés sans altération.
- Tests supplémentaires de lecture, de volume, de ciblage des PNJ et de fin sans boucle ; paquet vérifié sur Windows et sauvegardes conservées.

L’incident de fermeture après environ 30 secondes de partie reste en cours de diagnostic ; aucun correctif de cet arrêt n’est annoncé ici.

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
