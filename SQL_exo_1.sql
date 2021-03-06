SELECT nom, prenom
FROM abonne
WHERE ville = 'MONTPELLIER'
ORDER BY nom



SELECT distinct prenom -- distinct permet de ne pas avoir de doublons
FROM abonne
WHERE prenom like 'L%' -- Où les prénoms commencent par L
ORDER BY prenom


SELECT Concat(UPPER(nom),' ', prenom) -- Je sélectionne et concatene le nom avec le prenom, j'ajoute un espace entre mes deux données à l'aide de ' '
FROM abonne -- dans la table abonne
WHERE UPPER(ville) = 'MONTPELLIER' -- ceux qui ont pour ville MONTPELLIER
ORDER BY nom, prenom -- Je les ordonne d'abord par nom puis prenom


SELECT nom, prenom
FROM abonne 
WHERE date_fin_abo >= current_date -- je prends tous les abonnés qui ont une fin d'abonnement postérieure ou égale à la date d'aujourd'hui
ORDER BY nom, prenom 


SELECT nom, prenom, age(date_naissance) -- tu sélectionnes les abonnés et affiche leur age à l'aide de la donnée date_naissance
FROM abonne 
WHERE age(date_naissance) < interval '20 years' -- spécifiquement où l'âge est inférieur à 20 ans
ORDER BY nom, prenom -- je les range en débutant par le nom


SELECT count(id) -- compte le nombre d'identifiants
FROM abonne 


SELECT count(id) -- compter les identifiants
FROM abonne 
WHERE age(date_naissance) BETWEEN '30 years' AND '40 years' -- dont l'âge est compris entre 30 et 40 ans


SELECT count(id) as nb, ville -- compter les id et selectionner les villes, nommer les id en nb
FROM abonne 
GROUP BY ville -- les regrouper par ville
ORDER BY nb DESC -- les afficher par ordre du plus gros au plus petit, nb affiché en premier


SELECT count(id) as nb, ville -- compter les id et selectionner les villes, nommer les id en nb
FROM abonne 
GROUP BY ville  -- les regrouper par ville
having count(id) >= 20 -- ceux qui ont un id supérieur ou égal à 20
ORDER BY nb DESC -- les afficher par ordre du plus gros au plus petit, nb affiché en premier


SELECT nom, prenom, case date_fin_abo < current_date -- on sélectionne les nom, prenoms, puis on crée une condition pour ceux qui ont une date de fin inférieure à la date d'aujourd'hui
WHEN true THEN 'expiré' ELSE 'abonné jusqu''au ' || to_char(date_fin_abo, 'dd mm yyyy') END -- si c'est le cas alors on affiche expiré sinon abonné jusqu'au puis on converti le résultat en format char pour personnaliser son format d'affichage, ici en format FR
FROM abonne 
WHERE nom like 'A%' -- On ne sélectionne que ceux dont le nom commence par A 
ORDER BY nom -- On les range par nom en ordre croissant ASC


SELECT count(id), nom, to_char(max(date_naissance), 'dd mm yyyy') as youngest, to_char(min(date_naissance), 'dd mm yyyy') as oldest
FROM abonne 
GROUP BY nom
ORDER BY nom


SELECT count(*), trunc(date_part( 'year', age(date_naissance))/10) || '0-' || trunc(date_part( 'year', age(date_naissance))/10) || '9' as tranche -- je les selectionne et conserve uniquement l'année pour définir leur âge, 
FROM abonne  -- trunc permet de couper l'âge et de garder le premier chiffre seulement, on divise par dix, on concatene afin d'afficher deux fois et modifier le résultat en ajoutant un 0 et un 9
-- on applique l'alias tranche et on groupe les REZ par cet alias
GROUP BY tranche


SELECT livre.titre, auteur.nom -- on veut les titres des livres et les noms des auteurs
FROM livre JOIN auteur -- on joint ces 2 tables 
ON livre.id_auteur = auteur.id -- à l'aide de l'id étranger auteur dans la table livre et de l'id dans la table auteur



SELECT livre.titre, auteur.nom as auteur, editeur.nom as edition-- on veut les titres des livres, les noms des auteurs et le nom des éditions
FROM livre -- from la table principale
JOIN auteur -- on joint ces 3 tables l'une après l'autre
ON livre.id_auteur = auteur.id -- à l'aide de l'id étranger auteur dans la table livre et de l'id dans la table auteur
JOIN editeur 
ON livre.id_editeur = editeur.id -- à l'aide de l'id étranger editeur dans la table livre et de l'id dans editeur dans la table editeur


SELECT count(*), editeur.nom as edition-- on veut les titres des livres et le nom des éditions. ici count(livre.titre) devient count(*) afin de compter le nbre de livres par édition
FROM livre -- from la table principale
JOIN editeur ON livre.id_editeur = editeur.id -- à l'aide de l'id étranger editeur dans la table livre et de l'id dans editeur dans la table editeur
GROUP BY edition


SELECT abonne.nom, abonne.prenom, livre.titre as titre_livre -- je veux afficher et récupérer le nom, prénom de l'abonné qui emprunte et le titre du livre
FROM emprunt -- a partir de la table intermédiaire
JOIN abonne -- je lis les tables différentes
ON abonne.id = id_abonne -- via leurs identifiants
JOIN livre
ON livre.id = id_livre
WHERE date_retour IS null -- je veux spécifiquement afficher ceux dont la date retour est null (pas rendu)



SELECT abonne.nom, abonne.prenom, livre.titre as titre_livre -- je veux afficher et récupérer le nom, prénom de l'abonné qui emprunte et le titre du livre
FROM emprunt -- a partir de la table intermédiaire
JOIN abonne -- je lis les tables différentes
ON abonne.id = id_abonne -- via leurs identifiants
JOIN livre
ON livre.id = id_livre
WHERE date_retour IS null AND age(date_emprunt) > '2 months' -- je veux spécifiquement afficher ceux dont la date retour est null (pas rendu)



SELECT abonne.nom, abonne.prenom, count(livre.titre) as nb_emprunt-- je veux afficher et récupérer le nom, prénom de l'abonné qui emprunte et compter le nbre de livre empruntés
FROM emprunt -- a partir de la table intermédiaire
JOIN abonne -- je lis les tables différentes
ON abonne.id = id_abonne -- via leurs identifiants
JOIN livre
ON livre.id = id_livre
GROUP BY abonne.id -- Je groupe les livres par abonné
ORDER BY nb_emprunt DESC -- J'affiche un résultat du + gros au + petit
LIMIT 10 -- je m'arrête aux 10 premiers


SELECT abonne.nom, abonne.prenom, count(emprunt.id_livre) as nb_emprunt
FROM emprunt
JOIN abonne
ON abonne.id = id_abonne
WHERE date_retour IS null
GROUP BY abonne.id having count(emprunt.id_livre) > 1
ORDER BY nb_emprunt DESC


SELECT categorie, count(emprunt.id_livre) as nb_emprunt
FROM emprunt
JOIN livre
ON livre.id = id_livre
GROUP BY categorie 
ORDER BY nb_emprunt DESC


SELECT nom, prenom, date_naissance as anniversaire
FROM abonne
WHERE date_part('month', date_naissance) = date_part('month', current_date + interval '1 day')
AND date_part('day', date_naissance) = date_part('day', current_date + interval '1 day')



