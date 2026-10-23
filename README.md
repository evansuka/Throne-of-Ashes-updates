# Throne of Ashes — mises à jour Windows

Ce dépôt public contient les téléchargements du jeu. Le code de développement est conservé dans un dépôt privé.

La version **[0.14.8](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.8)** améliore la taille et la démarche des ennemis des premiers étages, l’orientation des PNJ, l’audio, le chat en bas à gauche, le sac à dos séparé et les menus Échap/Quêtes. Les nouveaux héros commencent sans sac ; les objets existants sont conservés. Les modifications de chaque livraison sont énumérées dans sa description GitHub, dans [l’historique](CHANGELOG.md) et dans les ZIP.

## Installation

Ouvrir la [dernière version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/latest) et télécharger **Throne-of-Ashes.exe**. Le lanceur installe le jeu puis vérifie automatiquement les nouvelles versions à chaque démarrage. Le ZIP Windows complet contient aussi les fichiers pour une première installation hors ligne.

Le journal PC reçu confirme encore un lanceur 0.14.2. Fermez les fenêtres du lanceur puis téléchargez [le nouveau **Throne-of-Ashes.exe**](https://github.com/evansuka/Throne-of-Ashes-updates/releases/download/v0.14.8/Throne-of-Ashes.exe) et remplacez l’ancien fichier. La mise à jour du jeu ne remplace pas automatiquement le lanceur du bureau. Ne pas supprimer les sauvegardes.

Les étapes et erreurs sont enregistrées dans `%LOCALAPPDATA%/ThroneOfAshes/launcher.log`. Le jeu lancé par le nouveau lanceur écrit dans `game.log` du même dossier. Pour une investigation dans le cloud, joindre une copie du journal pertinent à la session ; ces fichiers restent locaux et peuvent contenir le nom du compte Windows dans les chemins.

Utiliser le lanceur sur chacun de tes ordinateurs. Le jeu est installé dans le dossier local de l’utilisateur; les sauvegardes existantes ne sont pas remplacées. Les sauvegardes restent propres à chaque PC et ne sont pas synchronisées en ligne.

En cas de panne de connexion, le lanceur utilise une version déjà installée. Les fichiers téléchargés sont contrôlés avant activation et la version précédente est conservée.

## Incident en cours de diagnostic

Une fermeture après environ 30 secondes de partie, puis une fermeture/réouverture après mise à jour, ont été signalées sur un PC. Les journaux fournis montrent un seul démarrage de Godot et plusieurs entrées en campagne, sans erreur fatale visible : la cause exacte n’est pas établie. La 0.14.8 empêche de relancer une partie déjà active et enrichit les diagnostics du jeu et du lanceur. Les améliorations audio incluent une musique de donjon, la reprise des pistes et des commandes de test/réinitialisation ; la sortie sonore réelle du PC reste à confirmer. Conserver les journaux après une fermeture et indiquer la version testée. Les sauvegardes ne doivent pas être supprimées pour ce diagnostic.
