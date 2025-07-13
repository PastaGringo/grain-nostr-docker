# 🌾 GRAIN Nostr Relay - Docker Edition

[![Docker Hub](https://img.shields.io/docker/pulls/pastagringo/grain-dockerized)](https://hub.docker.com/r/pastagringo/grain-dockerized)
[![Docker Image Size](https://img.shields.io/docker/image-size/pastagringo/grain-dockerized/latest)](https://hub.docker.com/r/pastagringo/grain-dockerized)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

*[English](#english) | [Français](#français)*

## 📋 Changelog

### Version 2.0.0 - Configuration par Variables d'Environnement

#### 🆕 Nouvelles Fonctionnalités
- **Configuration Complète par Variables d'Environnement**: Le fichier `relay_metadata.json` est maintenant généré automatiquement à partir des variables d'environnement Docker Compose
- **Script de Configuration Intégré**: Le script `configure-relay.sh` est maintenant intégré directement dans le Dockerfile, éliminant le besoin de fichiers externes
- **Documentation Complète**: Nouveau fichier `CONFIGURATION.md` avec guide détaillé des variables disponibles
- **Exemples Docker Compose**: Fichiers d'exemple pour configuration basique et avancée

#### 🔧 Améliorations
- **Cohérence des Versions**: Les champs `software` et `version` sont maintenant fixes pour éviter les incohérences
- **Validation Automatique**: Fonctions de validation pour les types booléens, tableaux et valeurs nulles
- **Logs Informatifs**: Affichage détaillé de la configuration au démarrage du relay
- **Sécurité Renforcée**: Seules les variables configurables par l'utilisateur sont exposées

#### 🗂️ Structure des Fichiers
- **Ajouté**: `CONFIGURATION.md` - Guide complet de configuration
- **Ajouté**: `docker-compose.example.yml` - Exemple de configuration avancée
- **Modifié**: `Dockerfile` - Script de configuration intégré
- **Modifié**: `README.md` - Documentation mise à jour avec exemples
- **Supprimé**: `configure-relay.sh` - Maintenant intégré dans le Dockerfile

#### 🔄 Migration depuis la Version Précédente
- Les anciens fichiers de configuration manuels restent compatibles
- Les nouvelles variables d'environnement permettent une configuration plus flexible
- Aucune action requise pour les déploiements existants

#### 📚 Variables Configurables
- **Informations de Base**: Nom, description, contact, clé publique
- **Géographie**: Pays, langues, tags descriptifs
- **Politiques**: URLs des politiques de confidentialité et conditions
- **Limitations Techniques**: Tailles max, nombre d'abonnements, limites
- **Contrôle d'Accès**: Authentification, paiement, restrictions d'écriture

---

---

## English

### Overview

A Dockerized version of the [GRAIN Nostr Relay](https://github.com/0ceanslim/grain) - a high-performance, configurable Nostr relay written in Go. This project provides an easy-to-deploy Docker setup with MongoDB integration and comprehensive configuration options.

### Features

- 🚀 **High Performance**: Built with Go for optimal speed and efficiency
- 🐳 **Docker Ready**: Complete containerization with Docker Compose
- 🗄️ **MongoDB Integration**: Persistent data storage with MongoDB
- 🔧 **Configurable**: Extensive whitelist/blacklist and rate limiting options
- 🛡️ **Security**: Built-in rate limiting and event filtering
- 📊 **Monitoring**: Health checks and logging capabilities
- 🌐 **NIP Support**: Supports NIPs 1, 7, 9, 11, 19, 42, 55, 65

### Quick Start

#### Prerequisites

- Docker and Docker Compose
- Git

#### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/grain-nostr.git
   cd grain-nostr
   ```

2. **Start the services**:
   ```bash
   docker-compose up -d
   ```

3. **Verify the installation**:
   ```bash
   curl http://localhost:8181
   ```

### Configuration

#### Whitelist Configuration (`whitelist.yml`)

```yaml
pubkey_whitelist:
  enabled: false
  pubkeys: []
  npubs: []
  cache_refresh_minutes: 60

kind_whitelist:
  enabled: false
  kinds: []

domain_whitelist:
  enabled: false
  domains: []
  cache_refresh_minutes: 60
```

#### Rate Limiting (`config.yml`)

The relay includes comprehensive rate limiting for:
- WebSocket messages
- Event publishing
- HTTP requests
- Event size limits by kind

### Management Scripts

#### Publish to Docker Hub
```bash
./publish-to-dockerhub.sh
```

### Configuration via Variables d'Environnement

Le relay peut maintenant être configuré entièrement via des variables d'environnement Docker Compose. Voir `docker-compose.example.yml` pour un exemple complet.

#### Variables Disponibles

**Informations de Base**:
- `RELAY_NAME`: Nom du relay (défaut: "🌾 GRAIN Relay")
- `RELAY_DESCRIPTION`: Description du relay
- `RELAY_BANNER`: URL de la bannière
- `RELAY_ICON`: URL de l'icône
- `RELAY_PUBKEY`: Clé publique du relay
- `RELAY_CONTACT`: Contact administrateur

**Paramètres Géographiques**:
- `RELAY_COUNTRIES`: Pays (séparés par virgules, ex: "FR,BE,CH")
- `RELAY_LANGUAGE_TAGS`: Langues supportées (ex: "fr,fr-FR,en")
- `RELAY_TAGS`: Tags du relay (ex: "francophone,communautaire")

**Limitations**:
- `RELAY_MAX_MESSAGE_LENGTH`: Taille max des messages (défaut: 524288)
- `RELAY_MAX_CONTENT_LENGTH`: Taille max du contenu (défaut: 8196)
- `RELAY_MAX_SUBSCRIPTIONS`: Nombre max d'abonnements (défaut: 10)
- `RELAY_AUTH_REQUIRED`: Authentification requise (true/false)
- `RELAY_PAYMENT_REQUIRED`: Paiement requis (true/false)

### TODO

- **Configuration YAML**: Étendre la configuration par variables d'environnement aux fichiers config.yml et whitelist.yml

### Docker Hub

The image is available on Docker Hub:
```bash
docker pull pastagringo/grain-dockerized:latest
```

### Supported NIPs

- **NIP-01**: Basic protocol flow description
- **NIP-07**: Window.nostr capability for web browsers
- **NIP-09**: Event deletion
- **NIP-11**: Relay information document
- **NIP-19**: bech32-encoded entities
- **NIP-42**: Authentication of clients to relays
- **NIP-55**: Android Signer Application
- **NIP-65**: Relay list metadata

### Troubleshooting

#### Common Issues

1. **"Kind 0 metadata not found"**:
   - Enable pubkey whitelist or disable restrictions
   - Ensure your pubkey is in the whitelist

2. **Connection refused**:
   - Check if containers are running: `docker-compose ps`
   - Verify port 8181 is available

3. **Performance issues**:
   - Adjust rate limits in `config.yml`
   - Monitor container resources

#### Logs

```bash
# View all logs
docker-compose logs -f

# View grain-relay logs only
docker-compose logs -f grain-relay

# View MongoDB logs
docker-compose logs -f grain-mongo
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Français

### 📋 Journal des Modifications

#### Version 2.0.0 - Configuration par Variables d'Environnement

##### 🆕 Nouvelles Fonctionnalités
- **Configuration Complète par Variables d'Environnement**: Le fichier `relay_metadata.json` est maintenant généré automatiquement à partir des variables d'environnement Docker Compose
- **Script de Configuration Intégré**: Le script `configure-relay.sh` est maintenant intégré directement dans le Dockerfile, éliminant le besoin de fichiers externes
- **Documentation Complète**: Nouveau fichier `CONFIGURATION.md` avec guide détaillé des variables disponibles
- **Exemples Docker Compose**: Fichiers d'exemple pour configuration basique et avancée

##### 🔧 Améliorations
- **Cohérence des Versions**: Les champs `software` et `version` sont maintenant fixes pour éviter les incohérences
- **Validation Automatique**: Fonctions de validation pour les types booléens, tableaux et valeurs nulles
- **Logs Informatifs**: Affichage détaillé de la configuration au démarrage du relay
- **Sécurité Renforcée**: Seules les variables configurables par l'utilisateur sont exposées

##### 🗂️ Structure des Fichiers
- **Ajouté**: `CONFIGURATION.md` - Guide complet de configuration
- **Ajouté**: `docker-compose.example.yml` - Exemple de configuration avancée
- **Modifié**: `Dockerfile` - Script de configuration intégré
- **Modifié**: `README.md` - Documentation mise à jour avec exemples
- **Supprimé**: `configure-relay.sh` - Maintenant intégré dans le Dockerfile

##### 🔄 Migration depuis la Version Précédente
- Les anciens fichiers de configuration manuels restent compatibles
- Les nouvelles variables d'environnement permettent une configuration plus flexible
- Aucune action requise pour les déploiements existants

##### 📚 Variables Configurables
- **Informations de Base**: Nom, description, contact, clé publique
- **Géographie**: Pays, langues, tags descriptifs
- **Politiques**: URLs des politiques de confidentialité et conditions
- **Limitations Techniques**: Tailles max, nombre d'abonnements, limites
- **Contrôle d'Accès**: Authentification, paiement, restrictions d'écriture

---

### Aperçu

Une version Dockerisée du [GRAIN Nostr Relay](https://github.com/0ceanslim/grain) - un relais Nostr haute performance et configurable écrit en Go. Ce projet fournit une configuration Docker facile à déployer avec intégration MongoDB et des options de configuration complètes.

### Fonctionnalités

- 🚀 **Haute Performance**: Construit avec Go pour une vitesse et efficacité optimales
- 🐳 **Prêt pour Docker**: Conteneurisation complète avec Docker Compose
- 🗄️ **Intégration MongoDB**: Stockage de données persistant avec MongoDB
- 🔧 **Configurable**: Options étendues de liste blanche/noire et limitation de débit
- 🛡️ **Sécurité**: Limitation de débit intégrée et filtrage d'événements
- 📊 **Surveillance**: Vérifications de santé et capacités de journalisation
- 🌐 **Support NIP**: Supporte les NIPs 1, 7, 9, 11, 19, 42, 55, 65

### Démarrage Rapide

#### Prérequis

- Docker et Docker Compose
- Git

#### Installation

1. **Cloner le dépôt**:
   ```bash
   git clone https://github.com/yourusername/grain-nostr.git
   cd grain-nostr
   ```

2. **Démarrer les services**:
   ```bash
   docker-compose up -d
   ```

3. **Vérifier l'installation**:
   ```bash
   curl http://localhost:8181
   ```

### Configuration

#### Configuration de la Liste Blanche (`whitelist.yml`)

```yaml
pubkey_whitelist:
  enabled: false
  pubkeys: []
  npubs: []
  cache_refresh_minutes: 60

kind_whitelist:
  enabled: false
  kinds: []

domain_whitelist:
  enabled: false
  domains: []
  cache_refresh_minutes: 60
```

#### Limitation de Débit (`config.yml`)

Le relais inclut une limitation de débit complète pour :
- Messages WebSocket
- Publication d'événements
- Requêtes HTTP
- Limites de taille d'événement par type

### Scripts de Gestion

#### Publication sur Docker Hub
```bash
./publish-to-dockerhub.sh
```

### Configuration via Variables d'Environnement

Le relay peut maintenant être configuré entièrement via des variables d'environnement Docker Compose. Voir `docker-compose.example.yml` pour un exemple complet.

#### Variables Disponibles

**Informations de Base**:
- `RELAY_NAME`: Nom du relay (défaut: "🌾 GRAIN Relay")
- `RELAY_DESCRIPTION`: Description du relay
- `RELAY_BANNER`: URL de la bannière
- `RELAY_ICON`: URL de l'icône
- `RELAY_PUBKEY`: Clé publique du relay
- `RELAY_CONTACT`: Contact administrateur

**Paramètres Géographiques**:
- `RELAY_COUNTRIES`: Pays (séparés par virgules, ex: "FR,BE,CH")
- `RELAY_LANGUAGE_TAGS`: Langues supportées (ex: "fr,fr-FR,en")
- `RELAY_TAGS`: Tags du relay (ex: "francophone,communautaire")

**Limitations**:
- `RELAY_MAX_MESSAGE_LENGTH`: Taille max des messages (défaut: 524288)
- `RELAY_MAX_CONTENT_LENGTH`: Taille max du contenu (défaut: 8196)
- `RELAY_MAX_SUBSCRIPTIONS`: Nombre max d'abonnements (défaut: 10)
- `RELAY_AUTH_REQUIRED`: Authentification requise (true/false)
- `RELAY_PAYMENT_REQUIRED`: Paiement requis (true/false)

### TODO

- **Configuration YAML**: Étendre la configuration par variables d'environnement aux fichiers config.yml et whitelist.yml

### Docker Hub

L'image est disponible sur Docker Hub :
```bash
docker pull pastagringo/grain-dockerized:latest
```

### NIPs Supportés

- **NIP-01**: Description du flux de protocole de base
- **NIP-07**: Capacité Window.nostr pour les navigateurs web
- **NIP-09**: Suppression d'événements
- **NIP-11**: Document d'information du relais
- **NIP-19**: Entités encodées en bech32
- **NIP-42**: Authentification des clients aux relais
- **NIP-55**: Application de signature Android
- **NIP-65**: Métadonnées de liste de relais

### Dépannage

#### Problèmes Courants

1. **"Kind 0 metadata not found"**:
   - Activer la liste blanche des pubkeys ou désactiver les restrictions
   - S'assurer que votre pubkey est dans la liste blanche

2. **Connexion refusée**:
   - Vérifier si les conteneurs fonctionnent : `docker-compose ps`
   - Vérifier que le port 8181 est disponible

3. **Problèmes de performance**:
   - Ajuster les limites de débit dans `config.yml`
   - Surveiller les ressources des conteneurs

#### Journaux

```bash
# Voir tous les journaux
docker-compose logs -f

# Voir uniquement les journaux du grain-relay
docker-compose logs -f grain-relay

# Voir les journaux MongoDB
docker-compose logs -f grain-mongo
```

### Contribution

1. Forker le dépôt
2. Créer une branche de fonctionnalité
3. Faire vos modifications
4. Tester minutieusement
5. Soumettre une pull request

### Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

## Support

For support and questions:
- Open an issue on GitHub
- Check the [GRAIN documentation](https://github.com/0ceanslim/grain)
- Join the Nostr community

Pour le support et les questions :
- Ouvrir une issue sur GitHub
- Consulter la [documentation GRAIN](https://github.com/0ceanslim/grain)
- Rejoindre la communauté Nostr