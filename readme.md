UNCHK Ticket System (SGT)

Présentation du Projet
Dans un centre de formation comme l'UNCHK, le flux de demandes (matériel, accès, pannes) est constant et souvent fragmenté (WhatsApp, emails, appels).

UNCHK Ticket System est une application console centralisée conçue pour structurer, sécuriser et tracer chaque demande d'assistance. Elle permet une séparation nette entre les Étudiants (création et suivi) et les Administrateurs (gestion globale et résolution).

🚀 Fonctionnalités Clés
🔒 Sécurité & Authentification
Hachage Bcrypt : Aucun mot de passe n'est stocké en clair. Utilisation de bcrypt avec un facteur de coût de 12 pour une sécurité optimale.

Validation stricte : Contrôle du format des emails (domaine @unchk.edu.sn requis) et des longueurs de champs.

Contrôle d'accès (RBAC) : Les fonctionnalités d'administration sont protégées par une vérification de rôle en temps réel.

📝 Gestion des Tickets
Système d'Urgence Intelligent : Catégorisation des demandes par niveaux (N1 : Matériel perdu, N2 : Accès, N3 : Pannes majeures).

Traçabilité Complète : Chaque ticket est lié à un ID utilisateur unique (Clé étrangère) et horodaté.

Historique Personnel : Les utilisateurs peuvent consulter l'évolution de leurs propres demandes.

🛠 Espace Administrateur
Vue d'ensemble : Listing complet de tous les tickets de la base de données.

Gestion du cycle de vie : Mise à jour du statut des tickets (En cours, Résolu, Rejeté).

🏗 Structure de la Base de Données
L'architecture repose sur trois tables principales pour garantir la confidentialité et la performance :

Utilisateurs : Informations profil (Nom, Prénom, Email, Rôle).

Comptes : Stockage sécurisé des secrets (Mots de passe hachés) et logs de connexion.

Tickets : Détails des demandes, niveaux d'urgence et liaisons utilisateurs.

[Image du schéma relationnel de base de données SQL pour un système de tickets]

🛠 Installation et Configuration
Prérequis
Python 3.8+

Serveur MySQL

Bibliothèques Python : mysql-connector-python, bcrypt

Installation
Cloner le dépôt :

Bash
git clone https://github.com/votre-repo/unchk-tickets.git
cd unchk-tickets
Installer les dépendances :

Bash
pip install mysql-connector-python bcrypt
Configurer la base de données :
Créez une base de données nommée GESTION_TICKETS et importez le schéma SQL fourni.

Lancer l'application :

Bash
python main.py
💻 Aperçu de l'Utilisation
Workflow Apprenant
Inscription -> Connexion

Créer un Ticket -> Sélection du niveau (1, 2 ou 3)

Voir mes Tickets pour suivre l'état "En attente".

Workflow Admin
Connexion (Compte avec rôle 'Admin')

Vue d'ensemble pour voir les priorités.

Gérer un statut pour traiter les demandes.

🛡 Garanties Techniques
Confidentialité : Isolation des données par user_id.

Intégrité : Utilisation de transactions SQL (commit) pour éviter les pertes de données.

Audit : Enregistrement automatique des dates de création et de connexion.

Développé dans le cadre du module Back-end - Sécurité & Traçabilité.