# Throne of Ashes — mises à jour Windows

Ce dépôt public contient les téléchargements du jeu. Le code de développement est conservé dans un dépôt privé.

La version **[0.14.17](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.17)** apporte des équipements mieux proportionnés, une garde de combat en donjon, une interface plus compacte, seize icônes de compétences, une épée divine animée et des cadavres avec épaisseur. Les vues diagonales d’Éléane au village sont corrigées. Détails dans [l’historique](CHANGELOG.md).

## Installation

Télécharger [**Throne-of-Ashes-Setup.exe**](https://github.com/evansuka/Throne-of-Ashes-updates/releases/latest/download/Throne-of-Ashes-Setup.exe), puis le lancer normalement. L’application s’installe pour votre compte dans `C:\Games\Throne of Ashes`, avec un raccourci personnel **Throne of Ashes** sur le Bureau et une entrée dans la liste des applications Windows. Le compte doit pouvoir écrire dans ce dossier.

Utiliser ensuite le raccourci Bureau pour jouer. Le démarreur vérifie les versions du lanceur et du jeu et récupère leurs mises à jour. Si une mise à jour échoue ou si la connexion est indisponible, une version déjà vérifiée reste utilisable.

## Sauvegardes et diagnostic

Les versions téléchargées et les journaux sont conservés dans `%LOCALAPPDATA%\ThroneOfAshes`. Les sauvegardes sont préservées lors des mises à jour et de la désinstallation ; elles restent propres à chaque PC et ne sont pas synchronisées en ligne.

Les journaux `installation.log`, `launcher.log` et `game.log` servent au diagnostic. Si Windows refuse l’accès à un exécutable, consulter également les alertes et la quarantaine de l’antivirus installé : un blocage du Setup par AVG a été identifié lors d’un essai PC.

## Vérification de la distribution

[Validation Windows 0.14.17 réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40101135405) : archives, intégrité, lanceur, démarrage du jeu, installation utilisateur et raccourcis contrôlés. Les cinq fichiers publics ont été retéléchargés et comparés par SHA-256. Le flux de mise à jour et le dernier installateur correspondent à la 0.14.17.
