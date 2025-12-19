# WealthPath - Assistant de Coaching Financier Vocal

**WealthPath** est une application mobile multiplateforme développée avec **Flutter** qui offre un service de coaching financier personnalisé alimenté par l'intelligence artificielle. L'application permet aux utilisateurs d'interagir avec un coach IA via une interface vocale ou textuelle dans quatre langues différentes : Français, Anglais, Espagnol et Arabe Darija.

## Fonctionnalités Principales

Coach IA 24/7 : Interaction naturelle via texte ou voix pour recevoir des conseils financiers personnalisés.

Interface Vocale Avancée : Intégration de la reconnaissance vocale (Speech-to-Text) et de la synthèse vocale (Text-to-Speech).

Support Multilingue : Disponible en Français, Anglais, Espagnol et Arabe Darija.

Onboarding Personnalisé : Configuration du profil en 4 étapes incluant la situation financière, la tolérance au risque et les objectifs spécifiques (fonds d'urgence, retraite, achat immobilier, etc.).

Design Moderne : Interface utilisateur soignée suivant les principes du Material Design, avec support des modes clair et sombre.

## Stack Technique

Frontend : Flutter 3.x & Dart.

Architecture : Pattern MVVM (Model-View-ViewModel) pour une séparation claire des responsabilités.

Gestion d'état : Provider.

Sécurité : Authentification via JWT tokens et stockage chiffré des données sensibles avec Flutter Secure Storage.

Communication : API REST via le package Dio et streaming des réponses de l'IA via WebSockets.

## Structure du Projet

L'application est organisée de manière modulaire:

lib/models/ : Modèles de données (utilisateurs, messages, etc.).

lib/providers/ : Logique métier et gestion de l'état global.

lib/services/ : Services de communication API et services vocaux.

lib/screens/ : Écrans de l'interface utilisateur (Auth, Chat, Profil).

## Équipe (E2526G1_3)

Boubkari Kaoutar 

Elkentaoui Hammam 

Rmili Yahya 

Salhi Abdelmounaim 
