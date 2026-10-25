# Throne of Ashes — jeu Windows autonome

La version **[0.14.26](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.26)** se lance directement, sans installateur ni lanceur séparé. Le code de développement reste dans un dépôt privé.

## Télécharger et jouer

Télécharger [**Throne-of-Ashes.exe**](https://github.com/evansuka/Throne-of-Ashes-updates/releases/latest/download/Throne-of-Ashes.exe), le placer dans un dossier accessible en écriture, par exemple `C:\Games\Throne of Ashes`, puis le lancer directement. Aucune installation ni demande administrateur n’est nécessaire si ce dossier est accessible à votre compte.

Utiliser ce fichier à la place de l’ancien Setup ou démarreur. Un raccourci Windows peut pointer directement vers ce jeu. Les sauvegardes et les personnages existants restent conservés au même emplacement.

## Mises à jour dans le jeu

L’écran d’accueil affiche en bas à droite, sous la création de personnage, la version installée et vérifie la dernière version disponible. Depuis l’accueil, ouvrir **Échap → Options** pour vérifier les mises à jour ou choisir **Mettre à jour et redémarrer** : le jeu télécharge et vérifie les fichiers, conserve une copie de secours, puis redémarre sur la nouvelle version. Une partie en cours n’est pas interrompue.

En cas d’échec du nouveau démarrage, la version précédente est restaurée avec un seul lancement de secours. Hors ligne, le jeu reste utilisable. La copie `.previous` à côté de l’EXE est le secours du dernier remplacement.

## Sauvegardes et diagnostic

Les sauvegardes restent locales à chaque PC et ne sont pas synchronisées en ligne. Cette distribution ne crée ni entrée d’installation Windows ni nouveau dossier de sauvegarde. Les anciennes installations ne sont pas désinstallées automatiquement.

Les traces d’une mise à jour autonome se trouvent dans `%LOCALAPPDATA%\ThroneOfAshes\portable-updates`, dans le sous-dossier du dernier essai : `update.log` et `result.json`. Les anciens journaux de lanceur restent disponibles pour les anciens raccourcis.

## Vérification de la distribution

[Validation Windows 0.14.26 réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40196167179) : rendu des donjons, gardiens, récompenses, version à l’accueil, remplacement demandé par le bouton du jeu, nouveau processus maintenu ouvert et six cas de récupération. Les trois fichiers publics sont retéléchargés et comparés aux fichiers validés ; le téléchargement principal est le moteur Godot avec le jeu embarqué, sans Setup.

Détails et validations dans [l’historique](CHANGELOG.md).

## Commandes solo

Dans le chat, onglet **Système** : `/help`, `/get <nom ou identifiant de l’unique>` et `/portal <boss>`. [Liste complète des commandes](COMMANDES-SOLO.md). Les donjons se réinitialisent à l’ouverture d’une nouvelle partie ; équipement, progression et portails restent conservés.
