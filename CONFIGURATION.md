# Configuration GRAIN via Variables d'Environnement

Ce guide explique comment configurer votre relay GRAIN en utilisant les variables d'environnement Docker Compose.

## Vue d'ensemble

Le Dockerfile modifié génère automatiquement le fichier `relay_metadata.json` à partir des variables d'environnement définies dans votre `docker-compose.yml`. Cela permet une configuration flexible sans avoir à modifier manuellement les fichiers de configuration.

## Variables Disponibles

### Informations de Base du Relay

| Variable | Description | Défaut | Exemple |
|----------|-------------|--------|---------|
| `RELAY_NAME` | Nom affiché du relay | `🌾 GRAIN Relay` | `Mon Relay Nostr` |
| `RELAY_DESCRIPTION` | Description du relay | `Go Relay Architecture for Implementing Nostr` | `Un relay communautaire français` |
| `RELAY_BANNER` | URL de l'image de bannière | *(vide)* | `https://example.com/banner.jpg` |
| `RELAY_ICON` | URL de l'icône du relay | *(vide)* | `https://example.com/icon.png` |
| `RELAY_PUBKEY` | Clé publique du relay | *(vide)* | `fa984bd7dbb282f07e16e7ae87b26a2a7b9b90b7246a44771f0cf5ae58018f52` |
| `RELAY_CONTACT` | Contact administrateur | *(vide)* | `mailto:admin@monrelay.fr` |

### Informations Logiciel

Les informations logiciel (`software` et `version`) sont automatiquement définies aux valeurs du relay GRAIN et ne peuvent pas être surchargées via les variables d'environnement pour assurer la cohérence.

### Politiques et Liens

| Variable | Description | Défaut | Exemple |
|----------|-------------|--------|---------|
| `RELAY_PRIVACY_POLICY` | URL de la politique de confidentialité | *(vide)* | `https://monrelay.fr/privacy` |
| `RELAY_TERMS_OF_SERVICE` | URL des conditions d'utilisation | *(vide)* | `https://monrelay.fr/terms` |
| `RELAY_POSTING_POLICY` | URL de la politique de publication | *(vide)* | `https://monrelay.fr/posting-policy` |

### Paramètres Géographiques et Linguistiques

| Variable | Description | Format | Défaut | Exemple |
|----------|-------------|--------|--------|---------|
| `RELAY_COUNTRIES` | Codes pays supportés | Séparés par virgules | `US` | `FR,BE,CH` |
| `RELAY_LANGUAGE_TAGS` | Langues supportées | Séparés par virgules | `en,en-US` | `fr,fr-FR,en` |
| `RELAY_TAGS` | Tags descriptifs | Séparés par virgules | `open-access,community` | `francophone,communautaire` |

### Limitations Techniques

| Variable | Description | Type | Défaut | Recommandé |
|----------|-------------|------|--------|-----------|
| `RELAY_MAX_MESSAGE_LENGTH` | Taille max des messages (bytes) | Nombre | `524288` | `524288` |
| `RELAY_MAX_CONTENT_LENGTH` | Taille max du contenu (bytes) | Nombre | `8196` | `8196` |
| `RELAY_MAX_SUBSCRIPTIONS` | Nombre max d'abonnements par client | Nombre | `10` | `10-50` |
| `RELAY_MAX_LIMIT` | Limite max d'événements par requête | Nombre | `500` | `500-1000` |

### Paramètres d'Accès

| Variable | Description | Type | Défaut | Options |
|----------|-------------|------|--------|---------|
| `RELAY_AUTH_REQUIRED` | Authentification requise | Booléen | `false` | `true`/`false` |
| `RELAY_PAYMENT_REQUIRED` | Paiement requis | Booléen | `false` | `true`/`false` |
| `RELAY_RESTRICTED_WRITES` | Écriture restreinte | Booléen | `false` | `true`/`false` |

### Contraintes Temporelles

| Variable | Description | Type | Défaut | Notes |
|----------|-------------|------|--------|---------|
| `RELAY_CREATED_AT_LOWER_LIMIT` | Timestamp minimum accepté | Timestamp Unix | `1577836800` | 2020-01-01 |
| `RELAY_CREATED_AT_UPPER_LIMIT` | Timestamp maximum accepté | Timestamp Unix ou `null` | `null` | Aucune limite |

## Exemple de Configuration

### Configuration Basique

```yaml
version: '3.8'

services:
  grain-relay:
    build: .
    ports:
      - "8181:8181"
    environment:
      RELAY_NAME: "Mon Relay GRAIN"
      RELAY_DESCRIPTION: "Un relay Nostr communautaire"
      RELAY_CONTACT: "mailto:admin@example.com"
      RELAY_PUBKEY: "votre_cle_publique_ici"
```

### Configuration Avancée

```yaml
version: '3.8'

services:
  grain-relay:
    build: .
    ports:
      - "8181:8181"
    environment:
      # Informations de base
      RELAY_NAME: "🇫🇷 Relay Francophone"
      RELAY_DESCRIPTION: "Relay Nostr pour la communauté francophone"
      RELAY_BANNER: "https://monsite.fr/banner.jpg"
      RELAY_ICON: "https://monsite.fr/icon.png"
      RELAY_PUBKEY: "fa984bd7dbb282f07e16e7ae87b26a2a7b9b90b7246a44771f0cf5ae58018f52"
      RELAY_CONTACT: "mailto:admin@monrelay.fr"
      
      # Politiques
      RELAY_PRIVACY_POLICY: "https://monrelay.fr/privacy"
      RELAY_TERMS_OF_SERVICE: "https://monrelay.fr/terms"
      RELAY_POSTING_POLICY: "https://monrelay.fr/posting-policy"
      
      # Géographie et langue
      RELAY_COUNTRIES: "FR,BE,CH,CA"
      RELAY_LANGUAGE_TAGS: "fr,fr-FR,fr-BE,fr-CH,fr-CA"
      RELAY_TAGS: "francophone,communautaire,libre,decentralise"
      
      # Limitations personnalisées
      RELAY_MAX_SUBSCRIPTIONS: "20"
      RELAY_MAX_LIMIT: "1000"
      RELAY_AUTH_REQUIRED: "false"
      RELAY_PAYMENT_REQUIRED: "false"
```

## Validation et Test

### Vérifier la Configuration

Après le démarrage du conteneur, vous pouvez vérifier que la configuration a été appliquée :

```bash
# Voir le fichier généré
docker exec grain-relay cat /app/relay_metadata.json

# Tester l'endpoint NIP-11
curl -H "Accept: application/nostr+json" http://localhost:8181
```

### Logs de Configuration

Le script de configuration affiche des informations utiles au démarrage :

```bash
docker-compose logs grain-relay
```

Vous devriez voir :
```
🌾 Configuring GRAIN relay metadata...
✅ relay_metadata.json configured successfully
📋 Relay configuration:
   Name: Mon Relay GRAIN
   Description: Un relay Nostr communautaire
   Contact: mailto:admin@example.com
   Countries: FR,BE,CH
   Languages: fr,fr-FR,en
   Tags: francophone,communautaire
🚀 Starting GRAIN relay...
```

## Bonnes Pratiques

### Sécurité

1. **Clé Publique**: Assurez-vous d'utiliser votre vraie clé publique pour `RELAY_PUBKEY`
2. **Contact**: Utilisez une adresse email valide pour `RELAY_CONTACT`
3. **Politiques**: Définissez des politiques claires si votre relay est public

### Performance

1. **Limitations**: Ajustez les limites selon vos ressources serveur
2. **Abonnements**: Limitez `RELAY_MAX_SUBSCRIPTIONS` pour éviter la surcharge
3. **Taille des messages**: Gardez `RELAY_MAX_MESSAGE_LENGTH` raisonnable

### Communauté

1. **Description**: Soyez clair sur l'objectif de votre relay
2. **Tags**: Utilisez des tags pertinents pour la découverte
3. **Langues**: Spécifiez les langues supportées

## Dépannage

### Problèmes Courants

**Le fichier relay_metadata.json n'est pas généré**:
- Vérifiez que le script `configure-relay.sh` est exécutable
- Consultez les logs du conteneur

**Configuration non prise en compte**:
- Redémarrez le conteneur après modification des variables
- Vérifiez la syntaxe de votre docker-compose.yml

**Erreurs de format JSON**:
- Évitez les guillemets dans les valeurs des variables
- Utilisez des échappements appropriés si nécessaire

### Support

Pour plus d'aide :
- Consultez les logs : `docker-compose logs grain-relay`
- Vérifiez la documentation GRAIN officielle
- Ouvrez une issue sur le repository GitHub