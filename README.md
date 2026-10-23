# Throne of Ashes — mises à jour Windows

Ce dépôt public contient les téléchargements du jeu. Le code de développement est conservé dans un dépôt privé.

La version **[0.14.10](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.10)** corrige le raccord des jambes en marche, les proportions et noms ALT du butin, plusieurs erreurs de fenêtres et de sauvegarde, les comparaisons d’équipement et le cycle du secours audio. Le lanceur gère mieux les anciennes versions hors ligne et les erreurs de transmission. Un audit étendu accompagne ces corrections : 29 suites natives, onze suites web, captures avant/après et validation Windows. Les changements de chaque version sont énumérés dans sa description GitHub, dans [l’historique](CHANGELOG.md) et dans les ZIP.

## Installation

Ouvrir la [dernière version](https://github.com/evansuka/Throne-of-Ashes-updates/releases/latest) et télécharger **Throne-of-Ashes.exe**. Le lanceur installe le jeu puis vérifie automatiquement les nouvelles versions à chaque démarrage. Le ZIP Windows complet contient aussi les fichiers pour une première installation hors ligne.

Les derniers extraits PC reçus identifient encore un ancien lanceur 0.14.2. Fermez les fenêtres du lanceur puis téléchargez [le nouveau **Throne-of-Ashes.exe**](https://github.com/evansuka/Throne-of-Ashes-updates/releases/download/v0.14.10/Throne-of-Ashes.exe) et remplacez l’ancien fichier. La mise à jour du jeu ne remplace pas automatiquement le lanceur du bureau. Ne pas supprimer les sauvegardes.

Les étapes et erreurs sont enregistrées dans `%LOCALAPPDATA%/ThroneOfAshes/launcher.log`. Le jeu lancé par le nouveau lanceur écrit dans `game.log` du même dossier. Pour une investigation dans le cloud, joindre une copie du journal pertinent à la session ; ces fichiers restent locaux et peuvent contenir le nom du compte Windows dans les chemins.

Utiliser le lanceur sur chacun de tes ordinateurs. Le jeu est installé dans le dossier local de l’utilisateur; les sauvegardes existantes ne sont pas remplacées. Les sauvegardes restent propres à chaque PC et ne sont pas synchronisées en ligne.

En cas de panne de connexion, le lanceur utilise une version déjà installée. Les fichiers téléchargés sont contrôlés avant activation et la version précédente est conservée.

## Incident en cours de diagnostic

Le journal PC de 0.14.8 confirme une erreur d’initialisation WASAPI `0x80070006`, puis le pilote Dummy : Godot ne pouvait pas émettre de son. Le jeu utilise alors un lecteur de secours Windows pour les musiques, voix et bruitages, sans redémarrer le jeu. La 0.14.10 détecte aussi l’arrêt du lecteur de secours et permet un nouvel essai dans Options. La sortie sonore physique reste à confirmer sur le PC concerné.

Les anciens extraits du lanceur reçus montrent plusieurs démarrages séparés en 0.14.2 ; il ne prouve pas une relance automatique au sein d’une tentative. Le nouveau lanceur attend la confirmation du même processus du jeu, se masque puis autorise son affichage. Il faut **remplacer manuellement l’ancien fichier du bureau** pour recevoir ce fonctionnement. Une éventuelle fermeture réelle du processus reste à diagnostiquer avec les journaux de cette nouvelle version. Les sauvegardes doivent être conservées.


Une boîte Windows refusant l’accès au fichier du bureau OneDrive a également été signalée ; sa cause locale n’est pas établie. Tester une copie fraîche du lanceur dans Téléchargements permet de poursuivre ce diagnostic. Les contrôles cloud et Windows automatisés ne garantissent pas la disparition de tout arrêt propre au PC du joueur. Certains coffres/portails, les animations ennemies et la lisibilité des cadavres nécessitent encore une finition artistique ; multijoueur natif et synchronisation des parties restent à porter.

[Validation Windows 0.14.10 réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/39990833668) : 45 contrôles de fenêtre, 20 de démarrage, installation/intégrité, exécutable natif et lecteur audio embarqué. Les quatre fichiers publics ont aussi été retéléchargés et comparés par SHA-256 après publication.
