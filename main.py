import mysql.connector
import bcrypt
import re
from datetime import datetime

# --- CONFIGURATION ET CONNEXION ---

try:
    GESTION_TICKETS = mysql.connector.connect(
  host = 'localhost',
  user = 'root',
  password = 'Birane_2024!',
  database ='GESTION_TICKETS'
)
    print("Connexion réussie")
except mysql.connector.Error as err:
    print(f"Erreur de connexion : {err}")
 

def afficher_separateur(caractere="=", longueur=70):
    print(caractere * longueur)

# --- SÉCURITÉ & VALIDATION ---
def valider_email(email):
    pattern = r'^[a-zA-Z0-9._%+-]+@unchk\.edu\.sn$'
    return re.match(pattern, email.lower())

def hash_pwd(mot_de_passe: str, rounds: int = 12) -> str:
    salt = bcrypt.gensalt(rounds=rounds)
    hash_bytes = bcrypt.hashpw(mot_de_passe.encode('utf-8'), salt)
    return hash_bytes.decode('utf-8')

def verifier_pwd(mot_de_passe: str, hash_stocke: str) -> bool:
    return bcrypt.checkpw(mot_de_passe.encode('utf-8'), hash_stocke.encode('utf-8'))

# --- LOGIQUE DES TICKETS  ---
def choisir_urgence():
    print("\n--- SÉLECTION DU BESOIN ---")
    print("1. Niveau 1 (Matériel perdu)")
    print("2. Niveau 2 (Problèmes d'accès/Connectivité)")
    print("3. Niveau 3 (Pannes majeures/Réclamations)")
    
    choix_niv = input("Sélectionnez votre niveau d'urgence : ")
    
    # Dictionnaire de correspondance pour la base de données
    options = {
        "1": {"nom": "Niveau 1", "sous_choix": ["Perte de carte étudiant","Chargeur perdu", "Modem perdu"]},
        "2": {"nom": "Niveau 2", "sous_choix": ["Problème d'accès plateforme", "Modem/SIM non fonctionnel"]},
        "3": {"nom": "Niveau 3", "sous_choix": ["Ordinateur en panne", "Réclamation de notes", "Changement de filière", "Changement d'Eno", "Examen en ligne", "Manque d'assiduité des profs"]}
    }

    if choix_niv in options:
        print(f"\nPrécisez votre demande ({options[choix_niv]['nom']}) :")
        for i, item in enumerate(options[choix_niv]['sous_choix'], 1):
            print(f"{i}. {item}")
        
        try:
            sub_c= int(input("Votre choix : ")) 
            return f"{options[choix_niv]['nom']} | {options[choix_niv]['sous_choix'][sub_c -1]}"
        except (ValueError, IndexError):
            print(" Choix invalide, retour au début.")
            return choisir_urgence()
    else:
        print(" Niveau inconnu.")
        return choisir_urgence()
    
def creer_ticket(user_id):
    urgence_formatee = choisir_urgence()
    
    while True:
        titre = input("\nLibellé du ticket (min 4 car.) : ").strip()
        if len(titre) >= 4: break
        else:  
            print("Titre trop court !")

    while True:
        desc = input("Description détaillée : ").strip()
        if len(desc) >= 5: break
        print("Description trop courte !")

    try:
        cursor = GESTION_TICKETS.cursor()
        query = """INSERT INTO Tickets (titre, description, niveau_urgence, id_utilisateur, statut_demande, date_demande) 
                   VALUES (%s, %s, %s, %s, 'En attente', %s)"""
        cursor.execute(query, (titre, desc, urgence_formatee, user_id, datetime.now()))
        GESTION_TICKETS.commit()
        print(f"\n Ticket enregistré : {urgence_formatee}")
    except mysql.connector.Error as e:
        print(f"Erreur SQL : {e}")

# --- FONCTIONS ADMIN ---
def lister_tous_les_tickets(user_id):
    cursor = GESTION_TICKETS.cursor()
    
    # VERIFICATION DE SÉCURITÉ EN TEMPS RÉEL
    cursor.execute("SELECT role FROM Utilisateurs WHERE id_utilisateur = %s", (user_id,))
    role_actuel = cursor.fetchone()
    
    if not role_actuel or role_actuel[0] != 'Admin':
        print("\n[SÉCURITÉ] Accès refusé : Vous n'avez plus les droits administrateur.")
        return
    query = """SELECT t.id_ticket, t.titre, t.niveau_urgence, t.statut_demande, u.prenom, u.nom 
               FROM Tickets t JOIN Utilisateurs u ON t.id_utilisateur = u.id_utilisateur
               ORDER BY t.niveau_urgence DESC"""
    cursor.execute(query)
    tickets = cursor.fetchall()
    
    print("\n" + "="*120)
    print(f"{'ID':<4} | {'TITRE':<20} | {'URGENCE':<25} | {'STATUT':<12} | {'PRENOM':<25} | {'NOM':<25}")
    print("-" * 120)
    for t in tickets:
        print(f"{t[0]:<4} | {t[1][:20]:<20} | {t[2]:<25} | {t[3]:<12} | {t[4]} | {t[5]}")
    print("="*120)

def gerer_statut_admin(user_id):
    cursor = GESTION_TICKETS.cursor()
    cursor.execute("SELECT role FROM Utilisateurs WHERE id_utilisateur = %s", (user_id,))
    res = cursor.fetchone()
    
    if res and res[0] == 'Admin':
        lister_tous_les_tickets(user_id)
        id_ticket = input("\nID du ticket à traiter : ")
        print("1. En cours | 2. Résolu | 3. Rejeté")
        statut = input("Nouveau statut : ").capitalize()
        situation = {"1": "En cours", "2": "Résolu", "3": "Rejeté"}
        
        if statut in situation:
            cursor = GESTION_TICKETS.cursor()
            cursor.execute("UPDATE Tickets SET statut_demande = %s WHERE id_ticket = %s", (situation[statut], id_ticket))
            GESTION_TICKETS.commit()
            print(" Statut mis à jour avec succès!")
    else:
        print("\n ALERTE : Action non autorisée. Votre rôle ne permet pas la modification.")

# --- AUTHENTIFICATION ---
def inscrire_utilisateur():
    cursor = GESTION_TICKETS.cursor()
    print("\n" + "─"*30 + "\n   INSCRIPTION\n" + "─"*30)
    while True:
      prenom = input("Prénom : ").strip().capitalize()
      if prenom.isalpha()  and len(prenom) >=3:
          break
      else:
          print("Prénom invalide, veuillez réessayer!")

    while True:
      nom = input("Nom : ").strip().upper()
      if nom.isalpha () and  len(nom) >=2:
          break
      else:
          print("Nom invalide, veuillez réessayer!")
    
    while True:
        email = input("Email (@unchk.edu.sn) : ").lower()
        if valider_email(email): break
        print("Format invalide !")
    while True:
      mdp = input("Mot de passe (8+ car.) : ")
      if len(mdp) >= 8: 
        mdp_hash = hash_pwd(mdp)
        break
      else:
          print("Mot de passe trop court !")
      
    try:
        cursor.execute("INSERT INTO Utilisateurs (prenom, nom, email) VALUES (%s, %s, %s)", 
                    (prenom, nom, email))
        id_u = cursor.lastrowid
        cursor.execute("INSERT INTO Comptes (mot_de_passe, id_utilisateur, date_creation) VALUES (%s, %s, %s)",
                    (mdp_hash, id_u, datetime.now()))
        GESTION_TICKETS.commit()
        print(" Compte créé avec succès!")
    except mysql.connector.Error as e:
        print(f"Erreur : {e}")

def se_connecter():
    cursor = GESTION_TICKETS.cursor()
    email = input("\nEmail : ").strip().lower()
    mdp = input("Mot de passe : ")
    derniere_connexion = datetime.now()

    query = """SELECT u.id_utilisateur, u.role, c.mot_de_passe, u.prenom 
               FROM Utilisateurs u JOIN Comptes c ON u.id_utilisateur = c.id_utilisateur 
               WHERE u.email = %s  """
    cursor.execute(query, (email,))
    user = cursor.fetchone()
    
    if user and verifier_pwd(mdp, user[2]):
        user_id = user[0]
        user_role = user[1]
        user_prenom = user[3]
        print(f"\nBienvenue {user[3]} ({user[1]}) !")
        try:
            query_update = "UPDATE Comptes SET date_connexion = %s WHERE id_utilisateur = %s"
            cursor.execute(query_update, (derniere_connexion, user_id))
            GESTION_TICKETS.commit()
        except Exception as e:
            print(f"Erreur traçabilité : {e}")
        if user[1] == 'Admin':
            menu_principal(user_id)
          
        else:
            menu_personnel(user_id)
    
    else:
        print("Identifiants incorrects.")
def deconnexion(user_id):
    try:
        cursor = GESTION_TICKETS.cursor()
        derniere_deconnexion = datetime.now()
        query_update = "UPDATE Comptes SET date_deconnexion = %s WHERE id_utilisateur = %s"
        cursor.execute(query_update, (derniere_deconnexion, user_id))
        GESTION_TICKETS.commit()
        main()
        print("\nDéconnexion réussie. À bientôt !")
    except Exception as e:
        print(f"Erreur lors de la déconnexion : {e}")   
# --- MENUS ---
def menu_personnel(user_id):
    while True:
        print("\n1. Créer un Ticket\n2. Voir mes Tickets\n0. Déconnexion")
        c = input("Choix : ")
        if c == '1': creer_ticket(user_id)
        elif c == '2': 
            cursor = GESTION_TICKETS.cursor()
            cursor.execute("SELECT id_ticket, titre, niveau_urgence, statut_demande FROM Tickets WHERE id_utilisateur = %s", (user_id,))
            for t in cursor.fetchall(): 
                print(t)
        elif c == '0': deconnexion(user_id)

def menu_principal(user_id):
    while True:
        print("\n1. Vue d'ensemble (Tous les tickets)\n2. Gérer un statut\n0. Déconnexion")
        c = input("Choix : ")
        if c == '1': lister_tous_les_tickets(user_id)
        elif c == '2': gerer_statut_admin(user_id)
        elif c == '0': deconnexion(user_id)
        else:
            print("Choix invalide !")

def main():
    while True:
        print("\n=== SYSTEME DE TICKETS UNCHK ===")
        print("1. Connexion\n2. Inscription\n0. Quitter")
        choix = input("Action : ")
        if choix == '1': se_connecter()
        elif choix == '2': inscrire_utilisateur()
        elif choix == '0': break

if __name__ == "__main__":
    main()
    GESTION_TICKETS.close()