# Throne of Ashes — jeu Windows autonome

La version **[0.14.87](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.87)** se lance directement, sans installateur ni lanceur séparé. Le code de développement reste dans un dépôt privé.

## Télécharger et jouer

Télécharger [**Throne-of-Ashes.exe**](https://github.com/evansuka/Throne-of-Ashes-updates/releases/latest/download/Throne-of-Ashes.exe), le placer dans un dossier accessible en écriture, par exemple `C:\Games\Throne of Ashes`, puis le lancer directement. Aucune installation ni demande administrateur n’est nécessaire si ce dossier est accessible à votre compte.

Utiliser ce fichier à la place de l’ancien Setup ou démarreur. Un raccourci Windows peut pointer directement vers ce jeu. Les sauvegardes et les personnages existants restent conservés au même emplacement.

Le jeu démarre en **fenêtre maximisée**, avec sa barre de titre et les boutons Windows. Le plein écran reste disponible ensuite par F11 ou les Options.

## Mises à jour dans le jeu

L’écran d’accueil affiche uniquement la version installée, fixée en bas à droite indépendamment du panneau des personnages. Une vérification s’effectue au démarrage : si une nouvelle version est disponible, une fenêtre propose **Faire la mise à jour** ou **Refuser**. Refuser laisse jouer sans téléchargement et sans nouvelle proposition pendant cette exécution. Une réponse reçue en partie attend le retour à l’accueil. Depuis l’accueil, ouvrir **Échap → Version** pour vérifier les mises à jour ou choisir **Mettre à jour et redémarrer** : le jeu télécharge et vérifie les fichiers, conserve une copie de secours, puis redémarre sur la nouvelle version. Une partie en cours n’est pas interrompue.

Depuis 0.14.74, cliquer sur **Faire la mise à jour** lance le téléchargement dans cette même fenêtre : progression, vérification et erreurs éventuelles y restent affichées. La page Version des Options reste accessible pour déclencher une mise à jour manuelle.

Depuis 0.14.79, l’annonce montre la nouvelle version, la version installée et **uniquement les nouveautés de la version proposée**, sans reprendre les versions précédentes. Le résumé reste visible pendant le téléchargement et peut être sélectionné. Les longs résumés défilent dans leur zone. Cette présentation devient disponible après installation de la 0.14.79.

En cas d’échec du nouveau démarrage, la version précédente est restaurée avec un seul lancement de secours. Hors ligne, le jeu reste utilisable. La copie `.previous` à côté de l’EXE est le secours du dernier remplacement.

## Sauvegardes et diagnostic

Les sauvegardes restent locales à chaque PC et ne sont pas synchronisées en ligne. Cette distribution ne crée ni entrée d’installation Windows ni nouveau dossier de sauvegarde. Les anciennes installations ne sont pas désinstallées automatiquement.

Les traces d’une mise à jour autonome se trouvent dans `%LOCALAPPDATA%\ThroneOfAshes\portable-updates`, dans le sous-dossier du dernier essai : `update.log` et `result.json`. Les anciens journaux de lanceur restent disponibles pour les anciens raccourcis.

## Vérification de la distribution

[Validation Windows 0.14.87 réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/41540829989) : animations temporelles, prises, combat, interface, diagnostic, sauvegardes et auto-remplacement vérifiés.

Les trois fichiers publics et le flux latest, avec et sans cache, ont été retéléchargés avec des empreintes conformes au paquet testé.

Détails et validations dans [l’historique](CHANGELOG.md).

## Paladin

Le bouclier porte un vrai coup, avec dégâts et son au contact. La prière se fait à genou, épée pointe au sol, en **maintenant le clic gauche sur la bulle de mana sacrée**. Relâcher arrête immédiatement la prière. L’ancienne icône de la page Compétences et ses raccourcis gratuits sont retirés. Les aptitudes ont des sons distincts. Le bouclier peut aussi frapper sans cible : le coup atteint un ennemi devant le héros lors du contact.

Sanctuaire (protection), Consécration (frappes sacrées) et Vigueur (régénération) deviennent des auras automatiques dans la barre. Une seule aura à la fois : en équiper une autre remplace la précédente, sans perdre le talent appris. Chacune possède son cercle distinct sous les pieds, maintenant animé même à l’arrêt : rotation et motifs internes en mouvement.

## Effets de combat

Le poison teinte légèrement les ennemis en vert, le froid et le gel en bleu ; les couleurs reviennent à la normale à l’expiration. Le Pas de l’ombre laisse des rémanences et possède son propre souffle sonore. La flèche empoisonnée montre une pointe et une traînée vertes.

Mur de feu : ligne de flammes limitée par les obstacles. Explosion ardente : cercle de feu grandissant depuis le sorcier, avec déclenchement sur les ennemis enflammés. Vague infernale : arc de feu qui avance en cône. Sons distincts et pause respectée.

## Arbres de compétences

**C** ouvre les trois branches de la classe ; **A** ouvre Personnage, **I** Inventaire. Les touches personnalisées restent préservées et configurables dans Options. Cliquer pour apprendre, glisser une active vers les quatre raccourcis, déplacer entre cases ou retirer au clic droit pendant la configuration. Les passifs appris fonctionnent automatiquement. Un seul ultime par héros ; les autres branches restent accessibles.

Les trois arbres utilisent toute la hauteur de la page, avec chemins de prérequis visibles. Toutes les icônes, ultimes compris, ont le format des raccourcis. Noms et descriptions apparaissent au survol. Aucun défilement. Les anciens skills sont retirés et leurs points rendus automatiquement une seule fois ; les nouveaux talents et l'ultime déjà appris restent conservés. Réinitialisation gratuite au village pendant l’équilibrage. Ressources de classe : Rage, Mana sacrée avec Prière, Mana sans régénération naturelle pour le Sorcier, Concentration. Vie à gauche, actions au centre, ressource à droite.

Valeurs initiales : un point par talent normal, trois par ultime, niveau 10 et quatre points dans sa branche pour un ultime. Les effets de soutien concernent le héros solo ; le multijoueur natif reste à porter.

## Fenêtres et barre d'actions

Les fenêtres latérales sont resserrées pour garder les potions et les quatre aptitudes accessibles au centre. Compétences et Inventaire partagent les mêmes dimensions. Le sac se trouve sous les bottes, les emplacements vides montrent seulement une silhouette sombre. Survoler une bulle affiche sa quantité actuelle/maximale. Les images des aptitudes remplissent leurs cases, avec les raccourcis juste dessous.

## Commandes solo

**Maj gauche + clic gauche** : attaquer sur place vers le pointeur, même sans cible. Maintenir le clic répète à la cadence normale ; relâcher le clic ou Maj arrête la répétition.

Dans le Chat, le texte est sélectionnable à la souris. **Ctrl+C** ou **Copier** récupère la sélection ; sans sélection, **Copier** récupère tout l’onglet courant, y compris les erreurs rouges du Debug.

Dans le chat, onglet **Système** : `/help`, `/get <nom ou identifiant de l’unique>` et `/portal <boss>`. [Liste complète des commandes](COMMANDES-SOLO.md). Les donjons se réinitialisent à l’ouverture d’une nouvelle partie ; équipement, progression et portails de gardiens déverrouillés restent conservés. Les portails temporaires de retour se ferment à la sortie de partie.

## Son absent

Depuis 0.14.72, le secours Windows utilise du PCM direct et le décodage WAV/MP3 de Godot. MCI et son pilote MPEG vidéo ne sont plus utilisés. Les erreurs de périphérique restent signalées.

Dans Échap → Option → Audio, cliquer sur **Réinitialiser la sortie audio**, puis **Tester les bruitages**. Le secours Windows est réellement relancé sans fermer le jeu. En secours, **Choisir la sortie Windows** permet de vérifier le périphérique par défaut ; après un changement, réinitialiser le son dans le jeu. Avec le pilote natif, le périphérique peut être choisi directement dans les Options. Le statut affiche les erreurs de lecture connues ; une sortie audible reste à confirmer sur votre PC.

La page **Échap → Version**, à l’accueil, contient aussi l’historique des versions. **Échap → Option** propose les onglets Audio, Graphique, Clavier et Gameplay ; les touches se personnalisent dans Clavier (ZQSD ou flèches par défaut, déplacement au clic conservé).

L’inventaire et la fiche Personnage restent actifs : le héros peut se déplacer et les ennemis continuent d’agir. Échap met le jeu en pause ; **Sauvegarder et quitter** revient à l’accueil.

La configuration du clavier affiche chaque action sur sa propre ligne, avec sa touche et **Modifier** à droite. Les quatre socles du village portent désormais les boss sous forme de statues de pierre. Le Viking porte un pantalon long sans short superposé.

Le prologue utilise les nouvelles voix P1 à P4, avec des scènes synchronisées sur les enregistrements. Pour le revoir : **Accueil → Échap → Cinématique**.

En 0.14.32 : sortie devant la grotte, pieds des statues dégagés, proportions du Viking ajustées à hauteur d’origine, taille de fenêtre conservée, nouveaux pas et contournement de la forge par Éléane. Le remplacement refuse aussi les tentatives concurrentes. Bruits de pas : Kenney Starter Kit FPS, MIT (2025), licence incluse dans le jeu.

La 0.14.32 rétablit la hauteur d’origine du Viking et ajuste le raccord du bassin au pantalon long ; le corps ne subit aucune réduction ni aucun étirement.

En **0.14.33**, les quatre héros conservent leurs proportions en combat, la garde n’affiche plus de bras en double, les poignées et boucliers suivent les poignets et la flèche normale de la Rôdeuse part au relâchement. Les largeurs des pantalons et bottes sont rééquilibrées. Audit Windows : 24 192 poses dans huit directions et 14 contrôles de coordination, sans échec. L’harmonisation des motifs est livrée en 0.14.34.

En **0.14.34**, les quatre héros retrouvent les mêmes tissus et motifs au repos, en garde et en combat. Hauteur, mains et prises d’armes conservées. Les pixels visibles du torse sont comparés dans cinq poses face/dos : 120 contrôles du vrai rendu Windows, sans échec.

En **0.14.35**, les nouveaux objets ordinaires n’ont aucun pouvoir magique, les bleus en ont 2–3, les rares 3–4 et les légendaires 3–4 plus un pouvoir exclusif. Les fiches présentent les dégâts, la cadence, le critique, les prérequis et les effets en clair. Durabilité et réparations chez Borin conservées, anneaux et amulettes sans usure. La valeur en or apparaît seulement dans le commerce, en bas à gauche. Les anciennes pièces gardent leurs caractéristiques.

En **0.14.37**, Havrebrume reçoit des maisons détaillées, une chapelle avec portail voûté et clocher ouvert, des chemins raccordés aux services et une berge aménagée. Les collisions de la forge et les trajets autour des PNJ sont corrigés. Les six services, les dialogues et les déplacements sont vérifiés dans le vrai jeu Windows.

Dans **Échap → Option → Gameplay**, choisir la taille des chiffres de dégâts infligés (aucun, petit, moyen, gros) et le mode ALT verrouillé pour le butin.

**TAB** ouvre et ferme la mini-carte pendant la partie, sans pause. Dans **Échap → Option → Gameplay**, choisir son coin et sa taille. Ville dévoilée, donjons explorés progressivement ; seul le triangle du héros est affiché. La carte démarre fermée à chaque nouvelle partie.

En **0.14.47**, les jauges de vie/mana utilisent beaucoup moins d’appels de dessin tout en conservant leur apparence. Les ennemis vivants se bloquent entre eux pour limiter leur superposition ; les cadavres restent franchissables. Audit de combats aux étages 1, 20, 40, 60, 80 et 100 ; mesures du cloud, pas des FPS de votre PC.

En **0.14.48**, les objets au sol se placent sur des positions voisines accessibles, sans superposition de leurs icônes dans les situations normales ; leur contenu et leur position restent sauvegardés. Chaque objet reste ramassable séparément.

En **0.14.49**, vente par glisser dans une boutique unique et rachat à +10 % (arrondi à l’or supérieur), renouvellement automatique du stock toutes les dix minutes. Échanges d’objets sous la souris, noms du butin cliquables, armes dix fois moins fragiles, icônes par paires, impacts du tourbillon et onde de choc. Capuche et raccord pantalon/bottes retouchés.

En **0.14.50**, l’or proche est ramassé automatiquement et l’équipement trouvé remplit les emplacements vides compatibles. Frappe puissante touche au contact visuel des armes ; nouvel impact court sur armure, butin davantage espacé, murs opaques si le héros est visible et chiffres des dégâts agrandis.

En **0.14.51**, la marche des quatre héros est retravaillée : retour du pied plus fluide, genoux plus souples et transfert du poids avec appui stabilisé. Départ et arrêt affinés, proportions au repos et vitesse de jeu conservées.

En **0.14.52**, prises et coups des quatre héros sont affinés : garde compacte, poignets orientés avec les avant-bras, préparation et retour de mêlée plus fluides. Armes et vêtements suivent la respiration native ; timing des dégâts conservé.

En **0.14.54**, les nouvelles prises montrent les doigts et le pouce autour du manche, avec les variantes de gants. Les haches au repos suivent leur vraie ancre. Windows valide aussi 5080 contrôles spécifiques, dont 48 sondes GPU sur le passage du manche derrière les doigts.

En **0.14.56**, prises de repos avec le pouce au-dessus des doigts, armes et bouclier rangés au village, capuche ajustée sans traversée de visage ou de cheveux. Windows valide aussi 5144 contrôles des prises et 5586 de rangement/capuche, dont 24 sondes GPU des zones couvertes.

En **0.14.57**, les quatre héros ont de nouvelles tenues et proportions, avec des poses d’accueil naturelles, un écu pour le Paladin et un bâton à deux mains. Les raccords des jambes des PNJ sont repris. Windows valide aussi 4158 contrôles des nouvelles postures/PNJ et 16 sondes GPU de texture.

En **0.14.58**, le Paladin retrouve sa tenue crème avec le nouvel écu, le Sorcier tient réellement son bâton à deux mains à l’accueil, les haches/épées pointent vers le haut au repos et les capuches sont recalées. Windows valide 561 contrôles ciblés supplémentaires.

En **0.14.59** : butin au premier plan, ALT de session, aperçu des compétences, réserves de ceinture descendantes, Cri de guerre remplissant les ressources, bras en marche et collisions alignées sur les rochers. Pas refaits et quatre répliques de clé ; [sources sonores](CREDITS-AUDIO-01459.md).

En **0.14.60** : prochain niveau de compétence uniquement au survol du +, arc de la Rôdeuse aux hanches, équipement à la même échelle carrée que le sac, bruit de pierre dédié et portail vertical à côté du héros, au clic, utilisable depuis la ceinture et limité à la session.

En **0.14.61** : ceinture entre armure et pantalon, sac à droite de la grille (double-clic pour ouvrir), fermetures carrées et retrait des cadres intérieurs. Or déposable et retirable dans le coffre partagé, par montant ou en totalité, conservé entre les héros.

En **0.14.62** : coffre dans sa fenêtre à gauche et vrai inventaire équipé à droite, boutons de fermeture bronze, or du coffre en bas à droite, emplacements d’armes de quatre cases, bijoux repositionnés, épées à leur hauteur réelle et paires de gants ouverts.

En **0.14.63** : cliquer la pièce d’or au coffre ouvre la petite fenêtre de dépôt/retrait. Marchand en grille avec onglets Armes, Armures, Bijoux et Divers, achat au double-clic et vente par glisser-déposer ; rachat à +10 % conservé et fermeture bronze.

En **0.14.65** : ceinture déroulée, petites quantités sans fond, inventaire au clic sans maintien, aperçu des attributs au survol du + et effets temporaires à droite du mana. Bâton Sorcier à deux mains au repos/en marche en donjon, départ des flèches de l’arc, tirs sur les silhouettes animées, feu ralenti et embelli, éclairs irréguliers même sans cible, quantité d’or au sol et musique de combat Flare sous CC BY-SA 3.0 avec crédits inclus.

## Nouveautés 0.14.82

- Compétences : 96 nouvelles icônes illustrées, lisibles dans les arbres et les raccourcis ; dimensions et commandes conservées.
- Sons : nouvelles identités de lancement et d’impact pour les quatre classes, contacts de bouclier métalliques, glace cristalline, foudre, flèches et magie sacrée différenciés.
- Effets : tourbillon du Viking, bannière de guerre, marteau sacré, protections, blizzard, mur de glace, tempête, pluie toxique et vrai double fantomatique équipé ; effets animés et mode atténué conservés.
- Éclairs : les traits et rebonds suivent les cibles réellement frappées. Coûts, points, ressources, statistiques et sauvegardes préservés.
- Accueil : Paladin et Sorcier de face, corps complets du Viking et de la Rôdeuse légèrement tournés vers l’intérieur ; arc incliné et flèche tenue dans la main libre.
- Personnages : marche de profil et de dos retravaillée, jambes de profil moins fines, raccord des bottes et pantalons ajusté.
- Inventaire : les rangées supplémentaires de la ceinture se déploient aussi avec la fenêtre ouverte ; texte d’aide du coffre retiré.

## Nouveautés 0.14.85

- Objets au sol : supprimés à la fin de la partie, y compris au village. Ils restent disponibles pendant les voyages de la même partie. Inventaire, équipement et coffre conservés ; une sauvegarde refusée ne supprime aucun objet. Un objet de quête non ramassé peut être retrouvé dans une prochaine partie.
- Portail de retour : apparition progressive, vortex et étincelles pendant l’ouverture, puis fermeture animée au retour au donjon. Zone de clic stable sur toute sa hauteur dès l’ouverture. Le passage exige toujours un clic.
- Sorcier : les neuf passifs apportent régénération de mana, récupération sur élimination, résistances, protection et contrôle, avec des icônes adaptées à leurs nouveaux effets.
- Armure de glace remplace Mur de glace au même emplacement : points appris et raccourcis conservés. Protection de 18 secondes, ou 24 avec Carapace boréale, réduction de dégâts, résistance au froid, plaques et givre visibles.
- Capuches : nouveaux dessins de tissu dans les huit directions, proportions affinées et visage visible ; icône d’inventaire assortie.
- Mini-carte du village : PNJ et Blue repérés, marqueurs de quêtes disponibles et de récompenses à récupérer. Les noms des PNJ apparaissent uniquement au survol dans le village.

## Nouveautés 0.14.86

- Options → Diagnostic : affichage des FPS et test de performances de deux minutes maximum, avec courbe des temps d’image, FPS moyens et bas, décompte des saccades et résumé sélectionnable.
- Rapport à copier ou exporter en JSON et CSV : matériel, réglages, lieu testé, temps de traitement du jeu, physique, rendu lorsque disponible, ennemis, projectiles, effets et erreurs. Les mesures indisponibles sont signalées ; les chemins personnels sont masqués. Aucun envoi automatique.
- Options → Graphique : résolution du rendu 3D réglable sans réduire l’interface, limite 30/60/120 FPS ou sans limite, et profil léger à 75 % avec ombres et effets réduits. La qualité adaptative respecte une limite volontaire de 30 FPS.
- Personnages déjà créés : le héros sélectionné et affiché seul est toujours de face, pour toutes les classes. Les quatre modèles présentés ensemble conservent leurs orientations distinctes.
- Capuches : volumes et ouverture du visage agrandis pour retrouver des proportions naturelles, sans réduire la tête native. Yeux, cheveux couverts et prises des armes conservés.

Pour signaler des ralentissements : Échap → OPTION → Diagnostic → DÉMARRER. Fermer les Options et reproduire le problème, puis ARRÊTER et EXPORTER JSON + CSV. Aucun envoi automatique ; le joueur choisit les fichiers à transmettre.

## Nouveautés 0.14.87

- Déplacements des quatre classes : appuis stabilisés au sol, trajectoires de pas adoucies, cadence adaptée à l’allure et petits pas de remise en place lors de l’arrêt.
- Postures et attaques : transferts de poids, bassin et épaules accompagnent le geste, en conservant les vrais points de prise des armes.
- Cri de guerre du Viking : nouvelle expression du corps entier, bras levés, appui fléchi et retour progressif à la garde, y compris lors d’une interruption.
- Ennemis : cadence accordée au déplacement et transitions de préparation et de récupération plus douces. Les silhouettes et équipements existants sont conservés.

Les ennemis en robe, les quadrupèdes et les boss demandent encore des membres dessinés séparément. Le prototype de flexion qui déformait leurs vêtements a été retiré. Les visages restent peints ; cette version ne prétend pas atteindre toute la fidélité des références ni convertir les acteurs en modèles 3D.
