# Lab 2 - Slurm HPC - Réponses aux exercices

**Étudiant :** [Votre nom]
**Date :** 29 avril 2026

---

## Exercise 1 - First Job Submission

### Question 1
Le code d'état qui apparaît pendant que le job est en attente est **PD** (PENDING).
Cela signifie que le job a été soumis mais qu'il attend que des ressources (CPU, mémoire, nœud)
se libèrent avant de pouvoir s'exécuter.

### Question 2
Contenu exact du fichier de sortie :
```
Hello from the cluster!
Job ID : 42
Node : c1
```
*(Remplacez 42 par votre Job ID réel.)*

### Question 3
Changements observés avec `sinfo` :
- **Lorsque le job s'exécute** : l'état du nœud passe de `idle` à `alloc` (alloué).
- **Lorsque le job est terminé** : le nœud revient à l'état `idle`.
Les ressources sont alors libérées pour d'autres jobs.

### Question 4
Slurm écrit la sortie dans le fichier défini par la directive `#SBATCH --output=py_hello_%j.out`.
Le `%j` est remplacé automatiquement par l'ID du job. Cela permet :
- d'obtenir un nom de fichier unique pour chaque job,
- d'éviter l'écrasement de fichiers de sortie,
- de retrouver facilement la sortie correspondant à un job précis.

---

## Exercise 2 - Parameterized Jobs

### Question 1
Après les trois soumissions, il y a **3 fichiers de sortie** distincts :
- `square_[ID1].out`
- `square_[ID2].out`
- `square_[ID3].out`

Ils sont différenciés par le **Job ID** (`%j`) dans le nom du fichier, qui est unique pour chaque soumission.

### Question 2 - Tableau des résultats

| n  | Job ID | Ligne de sortie |
|----|--------|-----------------|
| 5  | 45     | 5² = 25         |
| 10 | 46     | 10² = 100       |
| 20 | 47     | 20² = 400       |

*(Remplacez 45, 46, 47 par vos vrais Job IDs.)*

### Question 3
**Inconvénient principal :** modifier le script manuellement pour chaque valeur est :
- **fastidieux** : pour 100 valeurs, il faudrait éditer et soumettre 100 fois,
- **source d'erreurs** : risque d'oublier une valeur ou d'introduire une faute de frappe,
- **peu évolutif** : impossible à gérer efficacement avec un grand nombre de paramètres.

**Solution pour 100 valeurs :**
- utiliser un **job array** (voir exercice 3),
- ou créer un script Bash qui automatise les soumissions avec une boucle,
- la meilleure pratique est d'utiliser `#SBATCH --array=1-100`.

---

## Exercise 3 - Job Arrays

### Tableau des résultats

| Index de tâche | Fichier de sortie | Ligne affichée      |
|----------------|-------------------|---------------------|
| 1              | sq_50_1.out       | Task 1: 1² = 1      |
| 3              | sq_50_3.out       | Task 3: 3² = 9      |
| 7              | sq_50_7.out       | Task 7: 7² = 49     |
| 10             | sq_50_10.out      | Task 10: 10² = 100  |

*(Remplacez 50 par votre Array Job ID réel.)*

### Question 1
**10 fichiers** ont été créés, ce qui correspond à `#SBATCH --array=1-10`.
Chaque tâche de l'array (1 à 10) génère son propre fichier de sortie via `%a` (task ID).

### Question 2
La **tâche 7** a produit `7² = 49`. Le script récupère son index grâce à la variable d'environnement `SLURM_ARRAY_TASK_ID`,
qui est automatiquement définie par Slurm pour chaque tâche de l'array avec son identifiant unique.

### Question 3
Pour exécuter `n ∈ {2, 4, 8, 16, 32}`, on peut utiliser :
```bash
#SBATCH --array=2,4,8,16,32
```
Après soumission, 5 fichiers de sortie doivent être créés, un pour chaque valeur de `n`.

### Question 4
Avec `scancel [JOBID]` :
- les tâches déjà en cours d'exécution (`RUNNING`) sont arrêtées,
- les tâches en attente (`PENDING`) sont annulées et ne démarrent pas,
- les fichiers de sortie des tâches interrompues peuvent contenir des résultats partiels.

---

## Conclusion

Ce lab m'a permis de comprendre :
- le rôle essentiel d'un ordonnanceur de jobs dans un cluster HPC,
- les commandes Slurm de base : `sbatch`, `squeue`, `scancel`, `sinfo`,
- la structure d'un script de soumission avec les directives `#SBATCH`,
- l'utilisation des job arrays pour paralléliser efficacement des calculs,
- la gestion des variables d'environnement Slurm pour personnaliser l'exécution.
