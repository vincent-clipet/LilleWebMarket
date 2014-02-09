Rapport projet web
==================

---

Auteurs:
-------

---

Vincent CLIPET

Martin PIFFAULT

Installation
------------

---

 - Déployer le fichier war via l'interface d'administration de tomcat.
 - Modifier le fichier webapps/LilleWebmarket/META-INF/context.xml pour configurer la connexion à la base de donnée.
 - Créer les tables dans la bdd grâce au fichier utils/create_table.sql.

Implémentation
--------------

---

Problèmes rencontrés et leur résolution
---------------------------------------

---

### Modélisation de la base de données

    Il a fallu trouver un modèle qui nous permette à la fois de conserver les informations nécessaires, sans redondance, et permettant de faire les mises à jour d'une manière simple et claire. Il nous fallait également conserver un historique des évènement (les ventes) du modèle. Le point sensible a été de trouver comment différencier les offres d'achat (ou de vente) des action à proprement parler.
	
	Nous nous somme rendu compte que la particularité des offres d'achat par rapport aux actions possédées par un utilisateur est qu'elles possèdent un prix et une date d'offre. Dans le cas d'une offre ("sell" dans notre modèle), la référence à un utilisateur représente "l'offrant", tandis que pour une action ("stock" dans notre modèle) la référence représente le "propriétaire".
	
	Ainsi nous somme arrivés à la solution d'une table 'stocks' qui référence un marché et un propriétaire, une indication du "sens" du marché sur lequel se trouve l'action, et une quantité. Cela suffit à représenter les actions possédées par un utilisateur. Pour les offres, nous devons ajouter à ces informations une notion de prix et de date d'offre. Pour cela, nous avons mis en place la table 'sells' qui référence une action à laquelle elle ajoute ces informations. Ainsi, une action référencée dans 'sells' devient une offre. Dès qu'une des ces offres trouve preneur, l'entrée dans sells est supprimée, et l'action miroir portant les informations du preneur est crée dans la table 'stocks'.

### Pattern DAO et MVC:

	Nous avons eu quelques tatonnement avant de saisir comment utiliser les beans avec le pattern DAO. Au début nous avons commencé par directement importer les objets DAO dans les vues, mais nous nous sommes rapidement rendu compte que cela enlevait tout l'intérêt des beans et ne respectait pas le principe de séparation entre vue et modèle que doit avoir un MVC.
 
    Cela nous a dirigé vers la mise en place d'un vrai modèle MVC : les requêtes se font toujours vers une servlet, qui s'occupe de récupérer les beans existants ou d'en créer de nouveaux et de les hydrater avec les objets récupérés dans la couche DAO. La servlet redirige ensuite vers une vue (jsp) dans laquelle les informations ne sont accédées que via les beans. Ainsi nous avons réussi à conserver une bonne étanchéité entre les vues, les contrôleurs et le modèle.

Limites du modèle
------------------

    Notre modèle ne permet pas de différencier une offre de vente d'une offre d'achat.
	
	Dans le premier cas, tant que l'action n'a pas été vendue, elle appartient à son propriétaire et peut lui faire gagner de l'argent si le marché se termine avant la vente.
	
	Dans le second cas, si le marché se termine et n'a pas trouvé preneur, cela ne peut rien faire gagner à l'offrant.
	
	La solution serait une table differente de 'sells', mais portant les mêmes informations prix et date et répertoriant les actions mises en vente par leur propriétaire.
	
Si nous avions eu plus de temps
-------------------------------

---

 - Gestion de la liste et de la vente des actions: 
 
    Rajout d'une page de profil complète listant les actions possédées par marchés avec le prix d'achat. Dans la page d'affichage d'un marché, rajout d'un encart contextuel permettant de revendre les actions possédées.

 - Ajout des mails:
 
     Envoi d'un e-mail au market maker lors du dépassement de l'échéance d'un marché, pour lui rappeler de définir l'information qui s'est vérifiée. Envoi d'e-mails aux utilisateurs possédants des actions sur un marché cloturé pour les tenir informés du résultat.
 
 - Amélioration du css et ajout de javascript frontend
 
    Amélioration de l'interface, que ce soit en terme de design ou d'ergonomie.

    Par exemple mise à jour en temps réel (ajax) du graphique et du tableau des offres de vente et d'achat.
