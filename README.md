# Imagerie sphéroïdes
## Projet 6 - Segmentation de sphéroïdes tumoraux multicellulaires
Baptiste Alberti - Tanguy Pace - Titouan Poquillon - Pierrick Ullius





## Organisation des documents

### Dossier Code

Ce dossier contient l'ensemble des fichier de code Matlab et des logiciels Ilastik qui ont permis de réaliser les différentes étapes de notre projet de segmentation.
Une étape de débruitage était indispensable avant la segmentation et comme chaque méthode de segmentation devait faire appelle aux mêmes images débruitées, nous avons créé un script de débruitage externe à la segmentation.

**denoising.m** : Script permettant d'effectuer le pré-traitement (débruitage et binarisation) des 5 images 2D de la database 1. Entraîne l'affichage d'images intermédiaires relatives aux différentes transformations, et les images finales sont sauvergardées dans le dossier Database1/Denoised_images/.

**denoising_3d.m** : script équivalent à *denoising.m* pour une image 3d

**kmean.m** : script pour la segmentation par kmean des 5 images débruitées de la database 1. Le script propose des images supplémentaires afin d'afficher les différents clusters et centroïdes en plus de l'image binaire utilisée pour l'évaluation de la méthode.

**watershed_seg.m** : script pour la segmentation par la méthode watershed des 5 images débruitées de la database 1. Entraîne l'affichage d'images intermédiaires pour illustrer  les différentes étapes de la méthode.

**region_growing.m** : script matlab pour la segmentation utilisant la méthode region growing. Le script génère une segmentation à partir des images contenues dans Database1 et places les images segmentées dans le dossier Database1/region_growing.

**Evaluation_worksheet.m** : script Matlab pour évaluer les performance de chaque méthode de segmentation par rapport à la vérité terrain

**Ilastik_cell_detection.ilp **: fichier Ilastik de segmentation des coupes 2d de sphéroïdes

**Ilastik_3d_cell_detection.ilp **: Fichier Ilastik de segmentation 3d complète des sphéroïdes

**Count_Cell_3d.m** : script Matlab pour conter le nombre de cellule présente dans une image 3d



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

Ce dossier contient l'images, le masque et les images de segmentation d'un sphéroïde complet. 

- **Raw.tif**: L'image 3d original
- **Seg_map.tif**: la verrité terrain obtenu par deep learning
- **Denoised.tif**: l'image 3d débruitée
- **Ilastik Segmentation.tiff**: la segmentation 3d Ilastik
- **Label.h5**: les lables manuelement dessiné pour entrainer Ilastik


### Dossier Evaluation

Ce dossier contient au format .csv, les tables d'évaluation des différentes méthodes de segmentations utilisées: 

- **Region_growing_segmentation_evaluation.csv**: évaluation des segmentation par rapport a la vérité terrain  de la méthode region growing,
- **Kmean_segmentation_evaluation.csv** : évaluation des segmentation par rapport a la vérité terrain  de la méthode des Kmeans,
- **Watershed_segmentation_evaluation.csv** : évaluation des segmentation par rapport a la vérité terrain  de la méthode Watershed,
- **Ilastik_segmentation_evaluation.csv** : évaluation des segmentation par rapport a la vérité terrain  du logiciel Ilastik.

