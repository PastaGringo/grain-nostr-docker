#!/bin/bash

# Script simplifié pour publier Grain sur Docker Hub
# Basé sur l'approche directe du script push-hello-world.sh

set -e

# Configuration par défaut
DEFAULT_USERNAME="pastagringo"
DEFAULT_REPOSITORY="grain-dockerized"
DEFAULT_TAG="latest"

# Configuration utilisateur (modifiable)
DOCKER_USERNAME="${1:-$DEFAULT_USERNAME}"
REPO_NAME="${2:-$DEFAULT_REPOSITORY}"
TAG="${3:-$DEFAULT_TAG}"
FULL_IMAGE="$DOCKER_USERNAME/$REPO_NAME:$TAG"

echo "🚀 Publication de Grain sur Docker Hub"
echo "📦 Image: $FULL_IMAGE"
echo "📁 Dockerfile: Dockerfile"
echo ""

# Vérifier que Dockerfile existe
if [ ! -f "Dockerfile" ]; then
    echo "❌ Dockerfile non trouvé dans le répertoire courant"
    exit 1
fi

echo "🔨 Construction de l'image Docker..."
docker build -f Dockerfile -t "$FULL_IMAGE" . || { echo "❌ Construction échouée"; exit 1; }

echo "🏷️ Tagging de l'image..."
if [ "$TAG" != "latest" ]; then
    docker tag "$FULL_IMAGE" "$DOCKER_USERNAME/$REPO_NAME:latest"
fi

echo "🔐 Connexion à Docker Hub..."
docker login || { echo "❌ Connexion échouée"; exit 1; }

echo "📤 Push vers Docker Hub..."
docker push "$FULL_IMAGE" || { echo "❌ Push échoué"; exit 1; }

if [ "$TAG" != "latest" ]; then
    echo "📤 Push du tag latest..."
    docker push "$DOCKER_USERNAME/$REPO_NAME:latest" || { echo "❌ Push latest échoué"; exit 1; }
fi

echo "✅ Image disponible sur : https://hub.docker.com/r/$DOCKER_USERNAME/$REPO_NAME"
echo "🚀 Utilisation: docker run -p 8181:8181 -e GRAIN_ENV=production $FULL_IMAGE"