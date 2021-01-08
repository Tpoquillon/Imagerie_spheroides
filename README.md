# Imagerie sphéroïdes
## Projet 6 - Segmentation de sphéroïdes tumoraux multicellulaires
Baptiste Alberti - Tanguy Pace - Titouan Poquillon - Pierrick Ullius





## Organisation des documents

### Dossier Code

Ce dossier contient l'ensemble des fichier de code Matlab et des logiciels Ilastik qui ont permis de réaliser les différentes étapes de notre projet de segmentation.
Une étape de débruitage était indispensable avant la segmentation et comme chaque méthode de segmentation devait faire appelle aux mêmes images débruitées, nous avons créé un script de débruitage externe à la segmentation.

**kmean.m** : script pour la segmentation par kmean des 5 images débruitées de la database 1. Le script propose des images supplémentaires afin d'afficher les différents clusters et centroïdes en plus de l'image binaire utilisée pour l'évaluation de la méthode.



### Dossier Database 1

Ce dossier contient les images, les masques et les segmentions relative à la première base de donnée d'images bi-dimensionnelles. Il est composé de 7 sous-dossier:

- **images** : les 5 images d'origine des sphéroïdes, chacune correspondant à une coupe,
- **Denoised_images** : les images après avoir été débruitées,
- **region_growing**: les images segmentées par la méthode region growing,
- **Kmean_segmentation** : les images segmentées par la méthode des Kmeans,
- **Watershed_segmentation** : les images segmentées par la méthode Watershed,
- **Ilastik** : les images segmentées par le logiciel Ilastik,
- **msk** : la vérité terrain labélisé par des experts.

### Dossier Database 2 

Ce dossier contient l'images et le masque d'un sphéroïde complet. 

- **Raw.tif**: L'image 3d original
- **Seg_map.tif**: la verrité terrain obtenu par deep learning

### Dossier Evaluation

Ce dossier contient au format .csv, les tables d'évaluation des différentes méthodes de segmentations utilisées: 

- **Region_growing_segmentation_evaluation.csv**: évaluation des segmentation par rapport a la vérité terrain  de la méthode region growing,
- **Kmean_segmentation_evaluation.csv** : évaluation des segmentation par rapport a la vérité terrain  de la méthode des Kmeans,
- **Watershed_segmentation_evaluation.csv** : évaluation des segmentation par rapport a la vérité terrain  de la méthode Watershed,
- **Ilastik_segmentation_evaluation.csv** : évaluation des segmentation par rapport a la vérité terrain  du logiciel Ilastik.

