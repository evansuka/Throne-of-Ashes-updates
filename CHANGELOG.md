# Modifications des versions Windows

## Site web — 25 octobre 2026

- Nouveau fond « Throne Beneath the Blood Moon », fourni par l’utilisateur ; logo et téléchargement conservés.

## 0.14.37 — publiée le 26 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.37) et [validation Windows](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40312750282). Trois assets publics et latest vérifiés.

- Havrebrume : uniquement des sentiers de terre continus, bords irréguliers fondus dans l’herbe ; pavés et bordures de pierres retirés, y compris les raccords ajoutés aux maisons, à la chapelle et à la forge.
- Un seul maillage précalculé pour les sentiers : 8 102 triangles. Les détails conservés du village passent de 12 164 à 9 740 triangles ; aucune nouvelle lumière ou particule.
- Armures : les ouvertures du col et des manches révèlent le cou et les bras natifs des quatre héros, au lieu des intérieurs noirs opaques. Cinq modèles conservés ; proportions, mains, prises des armes et teintures inchangées.

61 contrôles du village et 469 contrôles visuels des armures réussis dans le vrai EXE Windows. Quatre classes, cinq armures, huit directions, repos/marche/attaque ; pixels comparés au corps natif dans la même pose équipée. Construction complète, six contrôles web, remplacement réel et six cas de récupération réussis. Source `a71f57a`, QA `aa83bcd`. Aucun accès aux sauvegardes joueur ; aucune mesure de FPS du PC affirmée.

## 0.14.36 — publiée le 26 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.36) et [validation Windows](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40302740827). Trois assets publics et latest vérifiés.

- Maisons : fenêtres dégagées, volets, portes ferrées, soubassements, seuils pavés, cheminées, jardinières et finitions de toiture.
- Chapelle : portail voûté, imposte/rosace, vitraux, contreforts corrigés, clocher ouvert et cloche visible.
- Place, bordures et raccords vers les services, berge du pêcheur, ateliers et abords des statues enrichis ; arbres gênant les accès écartés.
- Forge : collisions séparées du foyer, de l’enclume et du râtelier pour dégager l’emplacement de Borin. Dégagements du feu et du coffre corrigés.
- Trajets : contournement des PNJ, recalcul en cas de blocage et arrivée choisie dans une zone réellement accessible ; Blue évite les PNJ et réessaie si bloqué.
- Décor regroupé en six maillages statiques ; aucune nouvelle lumière ou particule.

57 contrôles dans le vrai EXE Windows : accès physique aux six services, dialogues et sélection du corps entier, cinq vues rendues, accès aux bâtiments/grotte, contournement d’Éléane et reprise face à un PNJ déplacé. Construction complète, régressions du jeu, remplacement réel et six cas de récupération réussis. Source `b2a6f10`. Le budget graphique ne constitue pas une mesure des FPS du PC.

## 0.14.35 — publiée le 26 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.35) et [validation Windows](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40285823265). Trois assets publics et latest vérifiés.

- Nouvelles fiches sombres : propriétés de base, plages physiques/élémentaires, cadence, critique, prérequis et pouvoirs séparés ; effets des uniques/légendaires décrits en clair.
- Nouveaux butins : ordinaire sans pouvoir magique ; bleu 2–3 ; rare 3–4 ; légendaire 3–4 plus un pouvoir exclusif. Groupes d’affixes par famille et six paliers de puissance.
- Les bonus affichés agissent réellement sur les attaques, sorts, protections et ressources. Conditions d’équipement vérifiées sans les bonus de l’objet entrant ou remplacé.
- Durabilité et réparations chez Borin conservées ; boucliers/carquois s’usent aux impacts, anneaux/amulettes sans usure.
- Valeur en or uniquement dans le commerce, en bas à gauche des fiches et des cases du marchand ; même calcul de prix pour l’affichage et la transaction.
- Anciennes pièces et uniques conservés sans nouveau tirage ni prérequis rétroactifs.

19 832 contrôles dédiés sur 3 072 objets, douze niveaux, seize familles et 10 000 attaques, aussi réussis dans le vrai EXE Windows. Construction complète, 106 contrôles UI et 2 787 combat, captures natives, remplacement réel et six cas de récupération réussis. Source `02a0b9f`.

## 0.14.34 — publiée le 26 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.34) et [validation Windows](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40281142921). Trois assets publics et latest vérifiés.

- Motifs des quatre héros harmonisés entre repos, garde, attaque et compétences : soleil du Paladin, broderies du Sorcier, cuir de la Rôdeuse et tatouages du Viking.
- Buste et pans issus de la même texture native ; manches recolorées depuis cette identité en gardant les contours articulés.
- Tissu reconstitué derrière les bras dans les vues de profil, sans fragment de main immobile.
- Hauteur, jambes, véritables mains, prises d’armes et équipements portés conservés.

625 380 vérifications sur 24 192 poses, huit directions et 18 kits par classe ; 14 contrôles de coordination. Dans le vrai EXE Windows, 120 comparaisons de pixels face/dos dans cinq poses confirment les motifs visibles du torse (différence RGB maximale 0). Construction complète, captures natives, remplacement réel et six scénarios de récupération réussis. Les tenues restent composées de sprites articulés ; ce contrôle ne compare pas tous les pixels cachés par les bras et objets.

## 0.14.33 — publiée le 26 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.33) et [validation Windows](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40272072643). Trois assets publics et latest vérifiés.

- Quatre héros : mêmes jambes et bottes entre repos, marche, garde, attaque et compétences ; hauteur native de tête/casque conservée, vues de dos corrigées. Le Viking garde sa hauteur d’origine.
- Garde : une seule paire de bras et de mains, sans silhouette relaxée superposée.
- Poignets, poignées et boucliers raccordés pendant les interpolations d’animation.
- Rôdeuse : pose de tir normal et flèche au relâchement à 0,20 seconde ; pause, interruption par compétence et voyage traités sans flèche doublée. Les frames lentes n’écrasent plus une attaque en attente.
- Largeur des pantalons/bottes du Sorcier et de la Rôdeuse rééquilibrée.
- Instructions de téléchargement adaptées au jeu autonome, sans renvoi vers l’ancien lanceur.

24 192 poses, 18 kits par classe, huit directions : 492 324 vérifications et 14 contrôles de coordination, aussi réussis dans l’EXE Windows. Construction complète, prises, marche et captures natives vérifiées ; remplacement réel et récupération réussis. Certains motifs de tunique demandent encore des dessins harmonisés entre repos et combat ; les animations restent des sprites articulés.

## 0.14.32 — publiée le 25 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.32) et [validation Windows](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40220461046). Trois assets publics et latest vérifiés.

- Hauteur d’origine du Viking rétablie : retrait de l’abaissement du haut du corps ajouté en 0.14.31.
- Raccord du bassin et du pantalon long ajusté pour rééquilibrer les proportions, sans réduire ni étirer le corps, la tête, les mains ou les armes.

64 contrôles de hauteur dans huit directions, avec et sans équipement ; 38 888 équipement, 44 403 marche et 8 192 raccords réussis. Captures natives inspectées. Jeu exporté et remplacement réel validés sur Windows.

## 0.14.31 — publiée le 25 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.31) et [validation Windows](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40219089328). Trois assets publics et latest vérifiés.

- Sortie par les escaliers du premier étage : retour devant la grotte, sans modifier les retours par portail ou après défaite.
- Statues remontées au-dessus du dessus des socles pour dégager les pieds.
- Jambes du Viking raccourcies et torse/équipement repositionnés ensemble, prises d’armes préservées.
- Options : taille de fenêtre agrandie conservée ; le mode fenêtré n’est réappliqué que lors d’une vraie sortie du plein écran.
- Mise à jour : verrou exclusif sur le jeu, refus d’une seconde tentative concurrente et absence de nouvelle recherche immédiate après remplacement réussi. Le journal PC montre un seul lancement confirmé ; la double relance signalée n’a pas été reproduite.
- Huit sons de pas distincts adaptés depuis Kenney Starter Kit FPS (MIT), surfaces souples et pierre ; cadence des sons alignée sur les foulées.
- Éléane contourne les obstacles et la forge avec une grille adaptée à son corps ; récupération après blocage prolongé.

Construction complète, contrôles physiques du contournement de la forge, redimensionnement natif et captures des proportions/statues vérifiés. Remplacement réel et concurrence validés sur Windows. Pas de mesure des FPS ni du son physiquement entendu sur le PC.

## 0.14.30 — publiée le 25 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.30) et [validation Windows](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40217384472). Trois assets publics et latest vérifiés.

- Les nouvelles narrations P1, P2, P3 et P4 remplacent les quatre anciennes voix du prologue, sans réencodage.
- Scènes recalées sur les durées des fichiers, avec une seconde avant/après chaque narration : 55,064 secondes au total, sans coupure de voix.
- Textes, illustrations, volumes et possibilité de passer la cinématique conservés. Relecture depuis Accueil → Échap → Cinématique.

33 contrôles de cinématique réussis, régressions audio et vérification des quatre empreintes des MP3 dans le jeu exporté. Remplacement du jeu et récupération validés sur Windows ; son physique du PC non mesuré.

## 0.14.29 — publiée le 25 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.29) et [validation Windows](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40216616745). Trois assets publics et latest vérifiés.

- Clavier : une ligne compacte par action, libellé à gauche, touche actuelle et bouton Modifier à droite. La touche affichée est actualisée après modification ; Échap annule la saisie.
- Les socles portent Tharok, Velyra, Ilyss et Mordrath en pierre : mêmes silhouettes, armes et proportions que les boss du donjon. Statues immobiles, sans combat et visibles dès le début.
- Viking : short d’origine retiré au rendu, pantalon long raccordé depuis la taille jusqu’aux bottes. Mains et avant-bras natifs préservés, prises d’armes inchangées.

47 contrôles ciblés, régressions interface, marche et équipement réussis ; captures natives inspectées. Construction complète et remplacement réel du jeu validés sur Windows, sauvegardes conservées.

## 0.14.28 — publiée le 25 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.28) et [validation Windows réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40214302879). Trois fichiers publics et latest vérifiés.

- Pantalons longs et bottes raccourcies pour le Viking ; bottes du Sorcier raccourcies et affinées.
- Inventaire, Personnage et Sac à dos laissent le héros, les PNJ et les ennemis agir. Échap conserve la pause ; Option et les autres pages modales restent protégées.
- Inventaire sans défilement, équipement descendu et pantalon dans un emplacement plus haut et étroit. Toutes les rangées restent visibles ; les anciens objets excédentaires sont conservés et accessibles par pagination.
- Ligne de vue des quatre socles des gardiens dégagée : 127 arbres retirés, rendu, navigation et collisions du village reconstruits.
- Échap à l’accueil : Option, Cinématique, Version, Quitter. Version présente l’historique et la vérification des mises à jour en haut ; aucune recherche de mise à jour dans Option.
- Échap en partie : Option, Quêtes, Sauvegarder et quitter (retour à l’accueil), Retour au jeu. Un échec de sauvegarde conserve la partie ouverte.
- Options réparties en Audio, Graphique et Clavier ; touches personnalisables et conservées, doublons échangés, raccourcis actualisés dans la barre. Déplacement ZQSD ou flèches, en plus du clic.

33 contrôles ciblés natifs et captures aux résolutions 720p/900p/1080p, suites de marche/équipement/objets/sauvegardes, puis remplacement réel et récupération validés sur Windows. Aucun résultat de son physique ou FPS du PC déduit de ces essais.

## 0.14.27 — publiée le 25 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.27) et [validation Windows](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40205308747).

- Le bouton « Réinitialiser la sortie audio » relance réellement le lecteur de secours Windows, même lorsque son processus semble encore actif. Le jeu reste ouvert et aucun second lecteur n’est créé avant l’arrêt du précédent.
- Les erreurs de lecture signalées par Windows sont désormais remontées au jeu ; deux tentatives de récupération au maximum, avec possibilité de réessayer manuellement.
- L’état de la sortie audio se met à jour dans les Options : initialisation, réinitialisation ou erreur, au lieu de considérer une simple connexion au lecteur comme un son fonctionnel.
- Choix du périphérique de sortie lorsque le pilote audio natif est disponible, avec préférence conservée et retour à la sortie par défaut si le périphérique est absent.
- En mode secours, accès aux paramètres de son Windows pour sélectionner la sortie par défaut.

Ce correctif améliore la récupération après un démarrage silencieux ; la cause de l’échec initial de WASAPI sur le PC n’est pas établie. Les essais automatisés ne vérifient pas le son physiquement entendu sur ce PC.

## 0.14.26 — publiée le 25 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.26) et [validation Windows](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40196167179).

- Version et état des mises à jour centrés dans la zone de droite de l’accueil.
- Molette : aucun zoom du monde lorsqu’une fenêtre de jeu est ouverte.
- Collisions entre héros, personnages du village, Blue et ennemis vivants ; clic sur toute la silhouette pour sélectionner/interagir.
- Commandes solo dans le chat Système : /get pour chaque unique, /portal pour les cinq gardiens, /help pour l’aide.
- Cercles lumineux retirés des entrées et sorties d’étage ; escaliers et textes conservés.
- Nouvelle icône du jeu : trône devant la lune rouge (choix 5).
- Donjons réinitialisés à chaque nouvelle session du héros, progression, équipement, quêtes et portails débloqués conservés. Réinitialisation à l’ouverture d’une nouvelle partie depuis l’accueil, ou après relance du jeu ; une simple pause Échap ne réinitialise rien.

[Liste des commandes solo](COMMANDES-SOLO.md).

## 0.14.25 — publiée le 25 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.25) et [validation Windows](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40193054490).

- Version et état des mises à jour déplacés en bas à droite, sous les actions de création de personnage.
- Vérification et mise à jour accessibles dans Échap → Options, uniquement depuis l’accueil. La vérification automatique à l’accueil est conservée.
- Import de personnages web retiré de l’interface. Personnages et sauvegardes existants conservés.

## 0.14.24 — publiée le 25 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.24) et [validation Windows réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40191566642).

- Distribution autonome : le téléchargement principal est directement le jeu Windows, sans installateur ni lanceur séparé.
- L’écran d’accueil affiche la version installée et vérifie les nouvelles versions. Le jeu reste utilisable hors ligne.
- Le bouton « Mettre à jour et redémarrer » télécharge et vérifie la nouvelle version depuis le jeu ; le remplacement n’interrompt jamais une partie en cours.
- La version précédente est conservée. Un démarrage non confirmé restaure la version précédente avec un seul essai de secours, sans boucle de téléchargement.
- Sauvegardes, personnages et paramètres conservés. Aucun droit administrateur ni changement de protection Windows requis ; le dossier contenant le jeu doit être accessible en écriture.

Télécharger Throne-of-Ashes.exe, le placer dans un dossier personnel accessible en écriture, puis le lancer directement. Les anciens raccourcis restent utilisables, mais ne sont plus nécessaires pour la nouvelle distribution.

Remplacement réel du jeu depuis l’accueil et six scénarios de récupération réussis. Le téléchargement principal est directement le jeu Godot ; aucun Setup dans cette version.

## 0.14.23 — publiée le 25 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.23) et [validation Windows réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40189100085).

- Tailles des cinq régions harmonisées sur les proportions des premiers niveaux.
- Archers, mages et éclaireurs affinés ; guerriers lourds et chefs plus massifs.
- Molosses à une échelle cohérente ; gardiens réduits, Azhraël restant le plus grand.
- Largeur conservée à la mort, pieds ancrés, animations et statistiques de combat préservées.

Fermer le jeu puis rouvrir le lanceur pour recevoir la mise à jour.

## 0.14.22 — publiée le 25 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.22) et [validation Windows réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40177484590).

- Cinq royaumes inspirés des Chroniques : vingt découvertes, stèles et journal relisible.
- Tharok : liens vitaux à rompre ; Velyra : glace contaminée devenant poison ; Ilyss : échos temporels annoncés ; Mordrath : fournaises à interrompre ; Azhraël : Dernier Gardien devant les cinq chaînes anciennes brisées.
- Après la victoire, Vaelthar et Elyndra révèlent la vérité du trône. Trois fins avec confirmation et épilogues conservés par héros.
- Créer de nouveaux sceaux offre le Sceau du Dernier Serment ; prendre le trône, le Cœur du Nouveau Souverain ; briser le cycle, l’Éclat du Cycle Brisé.
- Une récompense par héros, coffre partagé si le sac est plein, un seul nouveau charme de destinée actif. L’ancienne Corne reste conservée avec ses bonus, sans nouvelle attribution.
- Réactions à Havrebrume et apparence du trône selon la fin. Compétences et sauvegardes existantes préservées.

Fermer le jeu puis rouvrir le lanceur pour recevoir la mise à jour.

## 0.14.21 — publiée le 25 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.21) et [validation Windows réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40172431413). Six étages rendus dans le vrai EXE Windows ; cinq fichiers publics et liens latest vérifiés.

- 1–20 : grottes rocheuses ordinaires, éboulis et stalagmites.
- 21–40 : grottes glaciales, cristaux et attaques froides avec ralentissement, y compris les zones du gardien.
- 41–60 : roche naturelle gagnée par les premières braises.
- 61–80 : cavernes volcaniques, lave et flammes plus présentes.
- 81–100 : enfer de basalte, lave animée et feu.
- Niveau 100 : trône gothique sur estrade, couronne de pointes et gemme rouge, dans la salle d’Azhraël.

Navigation, escaliers, progression et sauvegardes conservés. La lave du décor ne provoque pas de dégâts supplémentaires. Fermer le jeu et rouvrir le lanceur pour recevoir la mise à jour.

## 0.14.20 — publiée le 25 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.20) et [validation Windows réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40167551366). Les cinq fichiers publics et les liens latest ont été retéléchargés et vérifiés. [Installation réelle et second lancement validés](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40167882039), 28 contrôles : raccourci réel, jeu maintenu ouvert et réouverture sans téléchargement ni installation.

- Réparation des fichiers altérés et conservation d’une version de secours vérifiée.
- Refus de démarrage gérés sans téléchargement identique répété ; verrouillages temporaires distingués.
- Restauration manuelle de la version précédente après échec du jeu, sans redémarrage automatique.
- Cache historique facultatif et phases réelles affichées par le démarreur.
- Publication Windows obligatoire, numéros de version contrôlés et activation distinguée du nettoyage.

Treize scénarios de récupération et cinquante contrôles d’interface, dont clic sur la restauration, sont inclus dans la validation Windows. Exécuter une fois le nouveau Setup pour mettre à jour le démarreur installé. Sauvegardes conservées. La cause du premier refus Windows du PC n’est pas identifiée par ces corrections.

## 0.14.19 — publiée le 24 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.19) et [validation Windows réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40113346850). Les cinq fichiers publics, leurs empreintes et les liens latest ont été vérifiés. [Installation neuve complète validée](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40113587797) : Setup public, installation dans C:\Games\Throne of Ashes, raccourci réel, un seul PID de jeu et jeu toujours ouvert trente secondes après la fermeture du Setup, du démarreur et du lanceur.

- Le jeu se minimise explicitement avant de signaler qu’il est prêt, puis sa fenêtre est restaurée et recentrée à la transmission du lanceur.
- Un signal périodique du lanceur remplace le contrôle incorrect du processus parent sous Windows. Le jeu reste caché tant que le lanceur prépare la transmission, même au-delà de quinze secondes.
- Contrôle sur le vrai jeu exporté : dix-huit secondes d’attente sans affichage de l’accueil, puis même PID visible et toujours actif ; aucun redémarrage.
- Les corrections d’accueil, de performances et de repli du lanceur de la 0.14.18 sont incluses.

Lancer une fois le nouveau Setup pour remplacer un démarreur installé 0.14.16. Sauvegardes conservées. Le refus Windows code 5 du PC reste de cause externe non identifiée ; une version de lanceur refusée n’est plus téléchargée à chaque lancement. Une fenêtre du moteur peut apparaître pendant son initialisation graphique avant le chargement du jeu ; le contrôle du jeu prêt reste distinct. Aucun réglage de protection ou de droits Windows n’est modifié.

## 0.14.18 — publiée le 24 octobre 2026

[Release](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.18) et [validation Windows standard réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40104034950). Cinq fichiers publics et empreintes vérifiés. Le contrôle graphique supplémentaire du Setup a ensuite observé une fenêtre avant la fin du lanceur ; la transmission a été renforcée en 0.14.19.

- Les quatre classes de présentation gardent leur équipement fixe ; sélectionner un héros affiche uniquement ce héros et son équipement personnel.
- Une nouvelle installation commence avec une liste de héros vide ; les sauvegardes existantes sont conservées.
- Le monde du village n’est plus rendu derrière l’accueil ; seuls les aperçus visibles sont animés.
- Cache des paramètres de pose et découpage spatial du rendu des donjons, en conservant les attaches, les sols, les murs et les collisions.
- Qualité adaptative désactivable dans Options, dans la limite de la qualité choisie. Les FPS du testeur restent à confirmer.
- Repli sur un ancien lanceur vérifié après un refus Windows, si disponible ; la même version refusée n’est plus téléchargée systématiquement.

## 0.14.17 — publiée le 24 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.17). [Validation Windows réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40101135405) ; cinq fichiers publics, empreintes et flux de mise à jour vérifiés.

- Épées affinées dans le monde et l’inventaire, en conservant leur point de prise.
- Posture de garde en donjon et placement du bouclier du paladin revu selon l’angle.
- Potions et cases de la barre de raccourcis réduites.
- Emplacements d’armure et de pantalon agrandis, bijoux et ceinture espacés.
- Seize icônes de compétences dessinées pour la barre et la fiche personnage.
- Frappe sacrée du paladin accompagnée d’une épée divine qui fonce vers la cible ; dégâts et portée conservés.
- Cadavres avec épaisseur, flancs et contact au sol pendant la chute ; anciens cadavres sauvegardés compatibles.
- Vues diagonales d’Éléane corrigées pour suivre son déplacement au village.
- Commande Nouvelle expédition retirée du menu Échap.
- Version du Setup et du désinstalleur lisible dans les propriétés Windows grâce aux ressources VERSIONINFO.

Installation utilisateur dans C:\Games\Throne of Ashes et mise à jour automatique conservées. Les sauvegardes restent préservées. Cette version ne modifie aucun réglage d’AVG ni des protections Windows.


## 0.14.16 — publiée le 24 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.16). [Validation Windows réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40089548475) ; installation utilisateur et désinstallation vérifiées, cinq fichiers publics contrôlés.

- Installation limitée au compte utilisateur dans `C:\Games\Throne of Ashes`, avec les droits déjà accordés sur ce dossier ; aucun composant administrateur n’est extrait ou lancé.
- Raccourci sur le Bureau personnel et entrée de désinstallation dans les applications du compte utilisateur, sans écriture dans les réglages communs de Windows.
- Désinstalleur utilisateur installé avec l’application, supprimant seulement les fichiers connus de l’application ; sauvegardes et cache utilisateur conservés.
- Vérification et mise à jour du lanceur inchangées. Diagnostic détaillé disponible en cas de refus ; aucune permission ou protection Windows n’est modifiée.
- Un dossier non accessible au compte utilisateur reste refusé : l’installateur ne force pas l’accès. Le fonctionnement effectif sur le PC reste à confirmer.


## 0.14.15 — publiée le 24 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.15). [Validation Windows réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40087569673) ; destination C:\Games et fenêtre de diagnostic contrôlées, cinq fichiers publics vérifiés.

- Nouvelle destination demandée : `C:\Games\Throne of Ashes`, avec le raccourci Bureau vers ce dossier.
- Erreurs d’installation : fenêtre avec l’étape exacte, le code Windows et l’exception complète, copiable avec un bouton même si aucun journal ne peut être écrit.
- Journalisation des étapes d’extraction, demande UAC, installation et lancement ; repli du journal vers le dossier temporaire si son emplacement normal est indisponible.
- Une erreur de nettoyage ne masque plus l’erreur initiale lors du lancement du composant d’installation.
- L’installation dans C:\Games\Throne of Ashes, les autorisations Windows et les sauvegardes sont conservées. Cette version améliore le diagnostic ; elle ne déclare pas résolue la cause du refus d’accès signalé sur le PC.


## 0.14.14 — publiée le 24 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.14). [Validation Windows réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40086140642), avec vérification des manifestes embarqués ; cinq fichiers publics contrôlés.

- Installation Program Files : composant administrateur séparé avec un manifeste Windows demandant explicitement les droits nécessaires, au lieu de relancer le démarreur sans manifeste d’élévation.
- Lancement de la demande d’autorisation depuis le thread Windows adapté ; attente en arrière-plan pour conserver une fenêtre réactive.
- Le démarreur normal conserve un manifeste sans élévation pour lancer le jeu sous le compte utilisateur.
- Désinstallation confiée au même composant administrateur ; contrôles des manifestes réellement embarqués ajoutés à la validation Windows.
- Raccourci Bureau, mises à jour du lanceur et sauvegardes conservés. Le consentement UAC reste à confirmer sur le PC concerné ; aucune protection Windows n’est désactivée.


## 0.14.13 — publiée le 24 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.13). [Validation Windows réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40084645449) ; cinq fichiers publics et flux de mise à jour contrôlés.

- Installateur Windows : application et démarreur dans Program Files/Throne of Ashes, avec autorisation administrateur lors de l’installation.
- Raccourci Bureau vers le démarreur installé ; entrée dans la liste des applications Windows et désinstallation conservant les données utilisateur.
- Vérification automatique de la version du lanceur au démarrage : téléchargement et empreinte SHA-256 contrôlés, activation dans un dossier versionné, version précédente conservée et repli hors ligne.
- Les mises à jour du lanceur et du jeu restent dans le cache utilisateur pour éviter une demande administrateur à chaque démarrage. Le jeu est lancé sans élévation par une installation commencée depuis un compte standard.
- Sauvegardes existantes conservées. Les refus Windows et le son physique du PC restent à vérifier ; l’installation ne garantit pas la résolution d’un blocage de protection ou d’un problème matériel.


## 0.14.12 — publiée le 24 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.12). [Validation Windows réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40082970232) ; quatre fichiers publics et flux de mise à jour contrôlés.

- Nouveau décor de citadelle sous la lune rouge à l’accueil, derrière les quatre classes disponibles.
- Zone de sélection des personnages conservée à droite, sans image de fond ; commandes et personnages existants préservés.
- Logo original en haut de l’accueil. Proportions du décor conservées avec un recadrage centré.
- Site de téléchargement actualisé séparément : décor du trône, logo original en haut et texte sous Télécharger retiré.

Les sauvegardes sont conservées. Le diagnostic du lancement et du son physique sur le PC reste ouvert ; ce changement visuel ne constitue pas un correctif de cet incident.


## Site — 24 octobre 2026

- Nouveau fond du trône sous la lune rouge, logo original en haut et suppression du texte sous Télécharger. Affichage ordinateur et mobile vérifié.

## 0.14.11 — publiée le 24 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.11). [Validation Windows réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40075082687) ; quatre téléchargements contrôlés par SHA-256 et flux de mise à jour vérifié.

- Coffres en bois et ferrures avec serrure, rivets et couvercle animé ; variante dorée des coffres rares. Les coffres ouverts restent visibles au retour dans l’étage sans fournir de nouveau butin.
- Portail de retour à glyphes et double anneau, avec lumière réduite et mouvement figé lorsque les effets lumineux sont atténués.
- Arches de pierre et passages colorés pour les quatre portails de gardiens. Placement rapproché de la clairière et zones de sélection alignées sur les arches ; déblocage et destinations conservés.
- Préparation, frappe et récupération visuelles différenciées pour la mêlée, les brutes, archers et mages de toutes les régions. Respiration et mouvements des bras affinés, pieds ancrés pendant les attaques.
- Cycle de trot spécifique aux chiens et molosses, transitions de phase continues et mouvement d’attaque abaissé. Déformations procédurales des sprites existants, sans remplacement des illustrations.
- Cadavres moins rouges, mieux séparés des flaques et du sol, avec silhouettes couchées légèrement courbées.
- Un seul corps bascule du sprite debout vers le sol, au lieu du doublon ennemi qui s’efface/cadavre déjà couché. Durées adaptées aux quadrupèdes, bipèdes et boss ; pause respectée et collisions immédiatement retirées.
- Sauvegarder ou quitter un étage pendant la chute conserve le cadavre final sans rejouer la mort au retour. Aucun changement du format de sauvegarde, du butin, des dégâts ou des délais d’impact.
- Nouveaux contrôles des coffres, portails, animations et transitions de mort intégrés à la construction Windows ; captures natives et suivi conservés dans le dépôt de développement.

Construction et contrôles Windows réussis. Ces améliorations visuelles ne constituent pas un correctif du refus d’accès au lanceur ou du son physique signalés sur le PC ; ces incidents restent à vérifier avec le lanceur récent. Multijoueur natif et synchronisation des sauvegardes restent à porter.


## 0.14.10 — publiée le 23 octobre 2026

[Télécharger cette version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.10).

- Mort du héros : suppression du bouton qui pouvait fermer le message tout en laissant une interface bloquée. Le retour au village reste accessible.
- Inventaire : utiliser une potion après avoir refermé le contenu du sac ne rouvre plus ce dernier involontairement.
- Sauvegardes : récupération de la copie de secours même si le fichier principal manque ; un fichier principal endommagé ne remplace plus une copie de secours valide lors de la sauvegarde suivante.
- Validation des données imbriquées avant chargement, complétion des anciens champs manquants et conservation des métadonnées inconnues. Les fichiers illisibles sont conservés pour diagnostic.
- Import web : migration des armes contenues dans le sac à dos et des identifiants des objets de quête ; un import refusé conserve la partie existante.
- Marche : raccord du pantalon et de la botte corrigé au niveau du genou, notamment de profil pour le Sorcier et le Rôdeur, sans modifier les mains ni les prises des armes.
- Butin au sol : proportions originales des icônes respectées, véritable icône pour l’or et espacement des noms révélés avec ALT afin de limiter leur chevauchement. Placement mis en cache lorsque la scène et la caméra restent fixes.
- Équipement : comparaison des bonus de base et des gemmes additionnés correctement, notamment pour les boucliers ; affichage des bonus de compétences de classe et de la propriété indestructible.
- Nouvelle icône autonome de la Corne du Souverain dans l’inventaire et le butin.
- Lanceur : démarrage visible des versions antérieures à 0.14.9 lors d’un repli hors ligne ; une erreur de transmission de fenêtre est journalisée sans fermer ni relancer le jeu.
- Secours audio Windows : détection de l’arrêt du lecteur et des erreurs de communication, commandes vérifiées et cache distinct pour les sons sans chemin. Options affiche l’interruption ; RÉINITIALISER LA SORTIE AUDIO permet un nouvel essai sans redémarrer le jeu.
- Audit étendu et contrôles de régression ajoutés : sauvegardes, mort et fenêtres, affichage multitailles, butin, vrais sous-processus du lanceur et cycle du secours audio. Rapport et captures conservés dans le dépôt de développement pour la continuité cloud/PC.

**Remplacer manuellement l’ancien lanceur par le fichier `Throne-of-Ashes.exe` de cette release**, toutes ses fenêtres fermées. La mise à jour du jeu ne remplace pas la copie du lanceur sur le bureau. Les sauvegardes sont conservées.

Les essais cloud ne reproduisent pas le refus Windows d’accéder à la copie du bureau OneDrive et ne valident pas les haut-parleurs du PC. Les anciens journaux reçus ne suffisent pas à établir la cause d’une fermeture réelle. Le multijoueur natif et la synchronisation des sauvegardes avec les comptes web restent à porter.

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
