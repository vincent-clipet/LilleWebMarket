Rapport projet web
==================

---

Auteurs:
-------

---

Vincent CLIPET (https://github.com/vincent-clipet)
Martin PIFFAULT (https://github.com/mpiffault)

Adresse du projet : https://github.com/vincent-clipet/LilleWebMarket


Installation
------------

---

 - Déployer le fichier .war via l'interface d'administration de tomcat
 - Modifier le fichier webapps/LilleWebmarket/META-INF/context.xml pour configurer la connexion à la base de données
 - Créer les tables dans le SGBD grâce au fichier utils/create_table.sql  
   (Par défaut, 5 utilisateurs sont créés, dont 1 marketmaker. La base est pré-remplie avec des données d'exemple)

 
 
Implémentation
--------------

---

### MCD

    Le MCD est composé de 4 tables (+ 1 non-indispensable; + 1 non-représentée), représentant les entités nécessaires à la réalisation du cahier des charges :
	* La table **markets** représente un couple de marchés. Elle contient les intitulé du marché et de son opposé, et sa date de fin (la colonne *winner* est présente mais pas réellement utilisée)
	* La table **users** représente les utilisateurs de l'application. Elle contient le login, le mot de passe et l'argent d'un joueur.
	* La table **stocks** représente 2 choses : soit une action achetée par un utilisateur, soit une proposition d'achat si il existe une entrée correspondante dans la table *sells*. Un 'stock' contient une quantité et un 'sens' (positif ou négatif) selon le marché.
	* La table **sells** est une 'extension' de la table *stocks*. Elle contient la date de création d'une proposition d'achat, et un prix.
	* (Non-indispensable) La table 'logs' contient les enregistements de chaque achat effectué sur un marché. Elle ne participe pas réellement fonctionnement 'vital' de l'application, mais permet d'afficher les graphiques de prix.
	* (Non-représentée) La table 'users_roles' contient les différents rôles de chaque utilisateur. Elle n'est pas représentée ici car elle est utilisée par le realm d'authentification, et pas directement par l'application.

    Nous nous somme rendu compte que la particularité des offres d'achat par rapport aux actions possédées par un utilisateur est qu'elles possèdent un prix et une date d'offre. Dans le cas d'une offre ("sell" dans notre modèle), la référence à un utilisateur représente "l'offrant", tandis que pour une action ("stock" dans notre modèle) la référence représente le "propriétaire".
	Ainsi nous somme arrivés à la solution d'une table 'stocks' qui référence un marché et un propriétaire, une indication du "sens" du marché sur lequel se trouve l'action, et une quantité. Cela suffit à représenter les actions possédées par un utilisateur. Pour les offres, nous devons ajouter à ces informations une notion de prix et de date d'offre. Pour cela, nous avons mis en place la table 'sells' qui référence une action à laquelle elle ajoute ces informations. Ainsi, une action référencée dans 'sells' devient une offre. Dès qu'une des ces offres trouve preneur, l'entrée dans sells est supprimée, et l'action miroir portant les informations du preneur est crée dans la table *stocks*.
	
	
### Pattern MVC

	L'application suit un modèle MVC, où les vues sont les JSP, les contrôleurs sont les servlets, et les autres classes sont les modèles ou servent à manipuler ceux-ci. (cf. *DAO* ci-dessous)
	

### Pattern DAO et architecture 5 couches

	L'application utilise un pseudo-*pattern DAO* pour accéder aux données dans le SGBD; ainsi qu'une pseudo-*architecture 5 couches* permettant de la diviser en sous-blocs réutilisables.
	Le pseudo-*pattern DAO* ne respecte pas exactement les règles d'une couche DAO, mais en reprend les principes. En effet, les classes DAO ne contiennent pas toutes les 4 méthodes *map / create / update / delete* nécessaire à la réalisation d'un vrai pattern DAO; mais ces classes sont les seules à interagir avec la base de données.
	
	Le modèle en 5 couches (Utilisateur - Business Objects - Data Objects - Data Access Objects - SGBD) est quasiment respecté, si ce n'est que les couches BO et DO se confondent.
	
	La classe **DAOFactoryInitializer** est un listener qui permet d'instancier une **DAOFactory** au lancement de l'application. C'est cette dernière qui gère la liaison avec le pool de connexion, et qui 'distribue' les objets permettant d'accéder à la couche DAO.
	La classe **DAOUtil** contient des méthodes statiques utilitaires, comme la fermeture des ResultSet ou la création des PreparedStatement.
	L'interface **IDAOObject** contient la méthode 'map' permettant de mapper un ResultSet avec les Data Objects. Elle devrait également contenir les méthodes 'create', 'update' et 'delete' (cf. *Si nous avions eu plus de temps*)
	Les interfaces **MarketDAO**, **UserDAO** et **StockDAO** définissent les signatures des méthodes des classes **MarketDAOImpl**, **UserDAOImpl** et **StockDAOImpl**, qui forment la couche DAO.
	Les classes **User**, **Stock**, **Market** et **Sell** sont des beans, et forment la pseudo-couche BO-DO
	Les servlets héritent toutes de **CustomHttpServlet**, qui s'occupe d'initialiser les objets DAO, de stocker les infos de l'utilisateur courant dans la session, de déclencher les redirections, et d'échapper les caractères spéciaux.
	Les servlets traitent les paramètres qu'elles reçoivent, et redirigent le traitement en conséquence, vers une JSP ou parfois vers une autre servlet.

	
### Servlets & JSP

	La servlet **Index** sert à afficher la page d'accueil. Elle récupère une liste des marchés actuellement ouverts, triés par date de fin. Elle redirige ensuite la requête vers la JSP *index*.
	La servlet **MarketServlet** gère entièrement l'affichage d'un marché et des offres correspondantes. Elle redirige ensuite la requête vers la JSP *market*.
	La servlet **BuyServlet** sert à gérer les propositions d'achat, de la récupération des champs du formulaire jusqu'à l'échange de titres si l'offre d'achat correspond à une/plusieurs offre(s) de vente. Elle redirige ensuite la requête vers la servlet *Market*.
	La servlet **MarketCreate** sert à créer un nouveau marché. Elle n'est accessible que par les marketmakers. Elle redirige vers la JSP *market_create* en cas d'erreur dans le formulaire, et vers la servlet *Market* du marché nouvellement créé (si la création a bien eu lieu).
	La servlet **Disconnect** sert à déconnecter l'utilisateur actuel du realm d'authentification. Elle redirige ensuite la requête vers la JSP *index*.
	
	Adresses des pages accessibles :
	**- LilleWebMarket/index**
	**- LilleWebMarket/market**
	**- LilleWebMarket/market_create**
	
	

Problèmes rencontrés et leur résolution
---------------------------------------

---

### Modélisation de la base de données

    Il nous a fallu trouver un modèle permettant à la fois de conserver les informations nécessaires, sans redondance, et permettant de faire les mises à jour d'une manière simple et claire. Il nous fallait également conserver un historique des évènement (les ventes) du modèle. Le point sensible a été de trouver comment différencier les offres d'achat (ou de vente) des action à proprement parler.
	

### Pattern DAO et MVC

	Nous avons eu quelques tatonnements avant de comprendre comment utiliser les beans avec le pattern DAO. Au début nous avons commencé par directement importer les objets DAO dans les vues, mais nous nous sommes rapidement rendu compte que cela enlevait tout l'intérêt des beans et ne respectait pas le principe de séparation entre vue et modèle que doit avoir un MVC.
 
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
	
 -  Amélioration de la couche DAO

	Implémenter des méthodes 'create', 'delete' et 'update' dans toutes les classes de la pseudo-'couche DAO', pour que celle-ci soit un peu mieux utilisée.
	
 - Fermeture 'propre' des marchés

	Ne plus supprimer les marchés, actions, ventes et logs en cascade à la fin d'un marché.
	
 - Encryptage des mots de passe
 
 - Possibilité de promouvoir un utilisateur en marketmaker
