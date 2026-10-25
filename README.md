# Throne of Ashes — mises à jour Windows

Ce dépôt public contient les téléchargements du jeu. Le code de développement est conservé dans un dépôt privé.

La version **[0.14.20](https://github.com/evansuka/Throne-of-Ashes-updates/releases/tag/v0.14.20)** fiabilise la réparation, les versions de secours et la restauration manuelle après un échec de démarrage. Détails dans [l’historique](CHANGELOG.md).

## Installation

Télécharger [**Throne-of-Ashes-Setup.exe**](https://github.com/evansuka/Throne-of-Ashes-updates/releases/latest/download/Throne-of-Ashes-Setup.exe), puis le lancer normalement. L’application s’installe pour votre compte dans `C:\Games\Throne of Ashes`, avec un raccourci personnel **Throne of Ashes** sur le Bureau et une entrée dans la liste des applications Windows. Le compte doit pouvoir écrire dans ce dossier.

**Si le démarreur installé affiche encore 0.14.16, lancer une fois le nouveau Setup pour le remplacer.** Les sauvegardes sont conservées.

Utiliser ensuite le raccourci Bureau pour jouer. Le démarreur vérifie les versions du lanceur et du jeu et récupère leurs mises à jour. Si une mise à jour échoue ou si la connexion est indisponible, une version déjà vérifiée reste utilisable.

## Sauvegardes et diagnostic

Les versions téléchargées et les journaux sont conservés dans `%LOCALAPPDATA%\ThroneOfAshes`. Les sauvegardes sont préservées lors des mises à jour et de la désinstallation ; elles restent propres à chaque PC et ne sont pas synchronisées en ligne.

Les journaux `installation.log`, `launcher.log` et `game.log` servent au diagnostic. Si Windows refuse l’accès à un exécutable, consulter également les alertes et la quarantaine de l’antivirus installé : un blocage du Setup par AVG a été identifié lors d’un essai PC.

## Vérification de la distribution

[Validation Windows 0.14.20 réussie](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40167551366) : archives, intégrité, installation, raccourcis et treize scénarios de récupération contrôlés. Le vrai jeu reste minimisé pendant dix-huit secondes après son signal prêt, puis le même processus devient visible et reste actif. Les cinq fichiers publics ont été retéléchargés et comparés par SHA-256 ; le flux et le dernier Setup correspondent à la 0.14.20. Une fenêtre du moteur peut apparaître pendant son initialisation graphique, avant le chargement du jeu.

[Installation neuve complète validée](https://github.com/evansuka/Throne-of-Ashes-updates/actions/runs/40113587797) : Setup public, installation dans C:\Games\Throne of Ashes, raccourci réel, un seul PID de jeu et jeu toujours ouvert trente secondes après la fermeture du Setup, du démarreur et du lanceur.
