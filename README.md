# Throne of Ashes — jeu Windows autonome

La version **[0.14.31](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.31)** se lance directement, sans installateur ni lanceur séparé. Le code de développement reste dans un dépôt privé.

## Télécharger et jouer

Télécharger [**Throne-of-Ashes.exe**](https://github.com/evansuka/Throne-of-Ashes-updates/releases/latest/download/Throne-of-Ashes.exe), le placer dans un dossier accessible en écriture, par exemple `C:\Games\Throne of Ashes`, puis le lancer directement. Aucune installation ni demande administrateur n’est nécessaire si ce dossier est accessible à votre compte.

Utiliser ce fichier à la place de l’ancien Setup ou démarreur. Un raccourci Windows peut pointer directement vers ce jeu. Les sauvegardes et les personnages existants restent conservés au même emplacement.

## Mises à jour dans le jeu

L’écran d’accueil affiche en bas à droite, sous la création de personnage, la version installée et vérifie la dernière version disponible. Depuis l’accueil, ouvrir **Échap → Version** pour vérifier les mises à jour ou choisir **Mettre à jour et redémarrer** : le jeu télécharge et vérifie les fichiers, conserve une copie de secours, puis redémarre sur la nouvelle version. Une partie en cours n’est pas interrompue.

En cas d’échec du nouveau démarrage, la version précédente est restaurée avec un seul lancement de secours. Hors ligne, le jeu reste utilisable. La copie `.previous` à côté de l’EXE est le secours du dernier remplacement.

## Sauvegardes et diagnostic

Les sauvegardes restent locales à chaque PC et ne sont pas synchronisées en ligne. Cette distribution ne crée ni entrée d’installation Windows ni nouveau dossier de sauvegarde. Les anciennes installations ne sont pas désinstallées automatiquement.

Les traces d’une mise à jour autonome se trouvent dans `%LOCALAPPDATA%\ThroneOfAshes\portable-updates`, dans le sous-dossier du dernier essai : `update.log` et `result.json`. Les anciens journaux de lanceur restent disponibles pour les anciens raccourcis.

## Vérification de la distribution

[Validation Windows 0.14.31 réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40219089328) : rendu des donjons, gardiens, récompenses, version à l’accueil, remplacement demandé par le bouton du jeu, nouveau processus maintenu ouvert et six cas de récupération. Les trois fichiers publics sont retéléchargés et comparés aux fichiers validés ; le téléchargement principal est le moteur Godot avec le jeu embarqué, sans Setup.

Détails et validations dans [l’historique](CHANGELOG.md).

## Commandes solo

Dans le chat, onglet **Système** : `/help`, `/get <nom ou identifiant de l’unique>` et `/portal <boss>`. [Liste complète des commandes](COMMANDES-SOLO.md). Les donjons se réinitialisent à l’ouverture d’une nouvelle partie ; équipement, progression et portails restent conservés.

## Son absent

Dans Échap → Option → Audio, cliquer sur **Réinitialiser la sortie audio**, puis **Tester les bruitages**. Le secours Windows est réellement relancé sans fermer le jeu. En secours, **Choisir la sortie Windows** permet de vérifier le périphérique par défaut ; après un changement, réinitialiser le son dans le jeu. Avec le pilote natif, le périphérique peut être choisi directement dans les Options. Le statut affiche les erreurs de lecture connues ; une sortie audible reste à confirmer sur votre PC.

La page **Échap → Version**, à l’accueil, contient aussi l’historique des versions. **Échap → Option** propose les onglets Audio, Graphique et Clavier ; les touches se personnalisent dans Clavier (ZQSD ou flèches par défaut, déplacement au clic conservé).

L’inventaire et la fiche Personnage restent actifs : le héros peut se déplacer et les ennemis continuent d’agir. Échap met le jeu en pause ; **Sauvegarder et quitter** revient à l’accueil.

La configuration du clavier affiche chaque action sur sa propre ligne, avec sa touche et **Modifier** à droite. Les quatre socles du village portent désormais les boss sous forme de statues de pierre. Le Viking porte un pantalon long sans short superposé.

Le prologue utilise les nouvelles voix P1 à P4, avec des scènes synchronisées sur les enregistrements. Pour le revoir : **Accueil → Échap → Cinématique**.

En 0.14.31 : sortie devant la grotte, pieds des statues dégagés, jambes du Viking raccourcies, taille de fenêtre conservée, nouveaux pas et contournement de la forge par Éléane. Le remplacement refuse aussi les tentatives concurrentes. Bruits de pas : Kenney Starter Kit FPS, MIT (2025), licence incluse dans le jeu.
