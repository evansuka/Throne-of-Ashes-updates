# Throne of Ashes — mises à jour Windows

Ce dépôt public contient les téléchargements du jeu. Le code de développement est conservé dans un dépôt privé.

La version **[0.14.3](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.3)** ajoute l’appel de Blue depuis le chat : il vient, s’assoit, jappe deux fois puis suit le personnage pendant deux minutes. Le chat dispose d’un bouton en bas à gauche et d’un fond semi-transparent. Les modifications de chaque livraison sont énumérées dans sa description GitHub et dans [l'historique](CHANGELOG.md). Les notes sont aussi incluses dans les ZIP.

## Installation

Ouvrir la [dernière version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/latest) et télécharger **Throne-of-Ashes.exe**. Le lanceur installe le jeu puis vérifie automatiquement les nouvelles versions à chaque démarrage. Le ZIP Windows complet contient aussi les fichiers pour une première installation hors ligne.

Si une ancienne fenêtre reste à « Vérification et installation… », fermez-la puis téléchargez [le nouveau **Throne-of-Ashes.exe**](https://github.com/evansuka/Throne-of-Ashes-updates/releases/download/v0.14.3/Throne-of-Ashes.exe) et remplacez l’ancien fichier. La mise à jour du jeu ne remplace pas automatiquement le lanceur du bureau. Ne pas supprimer les sauvegardes.

Les étapes et erreurs sont enregistrées dans `%LOCALAPPDATA%/ThroneOfAshes/launcher.log`. Le jeu lancé par le nouveau lanceur écrit dans `game.log` du même dossier. Pour une investigation dans le cloud, joindre une copie du journal pertinent à la session ; ces fichiers restent locaux et peuvent contenir le nom du compte Windows dans les chemins.

Utiliser le lanceur sur chacun de tes ordinateurs. Le jeu est installé dans le dossier local de l’utilisateur; les sauvegardes existantes ne sont pas remplacées. Les sauvegardes restent propres à chaque PC et ne sont pas synchronisées en ligne.

En cas de panne de connexion, le lanceur utilise une version déjà installée. Les fichiers téléchargés sont contrôlés avant activation et la version précédente est conservée.

## Incident en cours de diagnostic

Une fermeture après environ 30 secondes de partie a été signalée sur un PC. La version 0.14.3 ajoute Blue et les améliorations du chat ; elle ne prétend pas corriger cet arrêt. Conserver les journaux après une fermeture et indiquer la version testée. Ne pas supprimer les sauvegardes pour essayer de corriger ce problème.
