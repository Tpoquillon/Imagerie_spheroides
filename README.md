# Imagerie sphéroïdes





## Organisation des documents

### Dossier Code

Ce dossier contient l'ensemble des fichier de code Matlab et des logiciels Ilastik qui ont permis de réaliser les différentes étapes de notre projet de segmentation



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

