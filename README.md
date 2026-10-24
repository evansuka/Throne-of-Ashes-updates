# Throne of Ashes — mises à jour Windows

Ce dépôt public contient les téléchargements du jeu. Le code de développement est conservé dans un dépôt privé.

La version **[0.14.13](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.13)** ajoute une installation Windows dans Program Files, un raccourci Bureau stable et la vérification automatique des nouvelles versions du lanceur. Les changements sont détaillés dans [l’historique](CHANGELOG.md).

## Installation

Télécharger [**Throne-of-Ashes-Setup.exe**](https://github.com/evansuka/Throne-of-Ashes-updates/releases/latest/download/Throne-of-Ashes-Setup.exe), le lancer et accepter la demande d’autorisation Windows pour installer l’application dans `Program Files/Throne of Ashes`. Utiliser ensuite le nouveau raccourci Bureau **Throne of Ashes**. L’application apparaît aussi dans la liste des applications Windows pour la désinstaller.

Le démarreur installé vérifie la version et l’intégrité du lanceur avant de démarrer celui-ci. Les nouvelles versions du lanceur et du jeu sont stockées dans `%LOCALAPPDATA%/ThroneOfAshes`, afin que les mises à jour ne demandent pas les droits administrateur à chaque fois. La désinstallation conserve les sauvegardes et ces données utilisateur. Les anciens fichiers et raccourcis vers Téléchargements ne sont pas modifiés.

En cas d’échec d’une mise à jour, le lanceur précédemment vérifié reste disponible. Cette installation ne désactive aucune protection Windows et ne garantit pas de résoudre un blocage propre au PC.

Les étapes et erreurs sont enregistrées dans `%LOCALAPPDATA%/ThroneOfAshes/launcher.log`. Le jeu lancé par le nouveau lanceur écrit dans `game.log` du même dossier. Pour une investigation dans le cloud, joindre une copie du journal pertinent à la session ; ces fichiers restent locaux et peuvent contenir le nom du compte Windows dans les chemins.

Utiliser le lanceur sur chacun de tes ordinateurs. Le jeu est installé dans le dossier local de l’utilisateur; les sauvegardes existantes ne sont pas remplacées. Les sauvegardes restent propres à chaque PC et ne sont pas synchronisées en ligne.

En cas de panne de connexion, le lanceur utilise une version déjà installée. Les fichiers téléchargés sont contrôlés avant activation et la version précédente est conservée.

## Incident en cours de diagnostic

Le journal PC de 0.14.8 confirme une erreur d’initialisation WASAPI `0x80070006`, puis le pilote Dummy : Godot ne pouvait pas émettre de son. Le jeu utilise alors un lecteur de secours Windows pour les musiques, voix et bruitages, sans redémarrer le jeu. La 0.14.10 détecte aussi l’arrêt du lecteur de secours et permet un nouvel essai dans Options. La sortie sonore physique reste à confirmer sur le PC concerné.

Les anciens extraits du lanceur reçus montrent plusieurs démarrages séparés en 0.14.2 ; il ne prouve pas une relance automatique au sein d’une tentative. Le nouveau lanceur attend la confirmation du même processus du jeu, se masque puis autorise son affichage. Il faut **remplacer manuellement l’ancien fichier du bureau** pour recevoir ce fonctionnement. Une éventuelle fermeture réelle du processus reste à diagnostiquer avec les journaux de cette nouvelle version. Les sauvegardes doivent être conservées.


Une boîte Windows refusant l’accès au fichier du bureau OneDrive a également été signalée ; sa cause locale n’est pas établie. Tester une copie fraîche du lanceur dans Téléchargements permet de poursuivre ce diagnostic. Les contrôles cloud et Windows automatisés ne garantissent pas la disparition de tout arrêt propre au PC du joueur. Certains coffres/portails, les animations ennemies et la lisibilité des cadavres nécessitent encore une finition artistique ; multijoueur natif et synchronisation des parties restent à porter.

[Validation Windows 0.14.13 réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40084645449) : installation/raccourcis, mise à jour et repli du lanceur, fenêtre, démarrage, intégrité, vrai jeu et secours audio embarqué. Les cinq fichiers publics ont été retéléchargés et contrôlés par SHA-256. Le consentement UAC et la désinstallation interactive restent à vérifier sur le PC.
