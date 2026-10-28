# Throne of Ashes — jeu Windows autonome

La version **[0.14.50](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.50)** se lance directement, sans installateur ni lanceur séparé. Le code de développement reste dans un dépôt privé.

## Télécharger et jouer

Télécharger [**Throne-of-Ashes.exe**](https://github.com/evansuka/Throne-of-Ashes-updates/releases/latest/download/Throne-of-Ashes.exe), le placer dans un dossier accessible en écriture, par exemple `C:\Games\Throne of Ashes`, puis le lancer directement. Aucune installation ni demande administrateur n’est nécessaire si ce dossier est accessible à votre compte.

Utiliser ce fichier à la place de l’ancien Setup ou démarreur. Un raccourci Windows peut pointer directement vers ce jeu. Les sauvegardes et les personnages existants restent conservés au même emplacement.

## Mises à jour dans le jeu

L’écran d’accueil affiche uniquement la version installée, fixée en bas à droite indépendamment du panneau des personnages. Une vérification s’effectue au démarrage : si une nouvelle version est disponible, une fenêtre propose **Faire la mise à jour** ou **Refuser**. Refuser laisse jouer sans téléchargement et sans nouvelle proposition pendant cette exécution. Une réponse reçue en partie attend le retour à l’accueil. Depuis l’accueil, ouvrir **Échap → Version** pour vérifier les mises à jour ou choisir **Mettre à jour et redémarrer** : le jeu télécharge et vérifie les fichiers, conserve une copie de secours, puis redémarre sur la nouvelle version. Une partie en cours n’est pas interrompue.

En cas d’échec du nouveau démarrage, la version précédente est restaurée avec un seul lancement de secours. Hors ligne, le jeu reste utilisable. La copie `.previous` à côté de l’EXE est le secours du dernier remplacement.

## Sauvegardes et diagnostic

Les sauvegardes restent locales à chaque PC et ne sont pas synchronisées en ligne. Cette distribution ne crée ni entrée d’installation Windows ni nouveau dossier de sauvegarde. Les anciennes installations ne sont pas désinstallées automatiquement.

Les traces d’une mise à jour autonome se trouvent dans `%LOCALAPPDATA%\ThroneOfAshes\portable-updates`, dans le sous-dossier du dernier essai : `update.log` et `result.json`. Les anciens journaux de lanceur restent disponibles pour les anciens raccourcis.

## Vérification de la distribution

[Validation Windows 0.14.50 réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40689861428) : 16 482 contrôles de tenue intégrée et de remplacement par les équipements, quatre restitutions exactes des pixels de base, 24 074 contrôles d’équipement porté et 672 036 graphiques. Quatre héros, huit directions, ensembles mixtes/teints/uniques ; remplacement demandé dans le jeu, nouveau processus maintenu ouvert et six cas de récupération. Les trois fichiers publics et latest sont retéléchargés et comparés aux fichiers validés ; téléchargement direct du jeu Godot, sans Setup.

Détails et validations dans [l’historique](CHANGELOG.md).

## Commandes solo

Dans le chat, onglet **Système** : `/help`, `/get <nom ou identifiant de l’unique>` et `/portal <boss>`. [Liste complète des commandes](COMMANDES-SOLO.md). Les donjons se réinitialisent à l’ouverture d’une nouvelle partie ; équipement, progression et portails restent conservés.

## Son absent

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
