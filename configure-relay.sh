#!/bin/sh

# Script to configure relay_metadata.json from environment variables
# and start the GRAIN relay

# Display ASCII art for GRAIN
echo ""
echo "   ██████╗ ██████╗  █████╗ ██╗███╗   ██╗"
echo "  ██╔════╝ ██╔══██╗██╔══██╗██║████╗  ██║"
echo "  ██║  ███╗██████╔╝███████║██║██╔██╗ ██║"
echo "  ██║   ██║██╔══██╗██╔══██║██║██║╚██╗██║"
echo "  ╚██████╔╝██║  ██║██║  ██║██║██║ ╚████║"
echo "   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝"
echo ""
echo "🌾 Go Relay Architecture for Implementing Nostr"
echo ""
echo "🌾 Configuring GRAIN relay metadata..."

# Function to convert string to array format for JSON
array_to_json() {
    local input="$1"
    if [ -z "$input" ]; then
        echo "[]"
        return
    fi
    
    # Split by comma and format as JSON array
    echo "$input" | sed 's/,/","/g' | sed 's/^/["/' | sed 's/$/"]/'
}

# Function to convert boolean string to JSON boolean
bool_to_json() {
    local input="$1"
    case "$input" in
        "true"|"True"|"TRUE"|"1") echo "true" ;;
        "false"|"False"|"FALSE"|"0") echo "false" ;;
        *) echo "false" ;;
    esac
}

# Function to handle null values
handle_null() {
    local input="$1"
    if [ "$input" = "null" ] || [ -z "$input" ]; then
        echo "null"
    else
        echo "$input"
    fi
}

# Generate relay_metadata.json from environment variables
cat > /app/relay_metadata.json << EOFMETA
{
  "name": "${RELAY_NAME}",
  "description": "${RELAY_DESCRIPTION}",
  "banner": "${RELAY_BANNER}",
  "icon": "${RELAY_ICON}",
  "pubkey": "${RELAY_PUBKEY}",
  "contact": "${RELAY_CONTACT}",
  "supported_nips": [1, 7, 9, 11, 19, 42, 55, 65],
  "software": "https://github.com/0ceanslim/grain",
  "version": "0.4.0",
  "privacy_policy": "${RELAY_PRIVACY_POLICY}",
  "terms_of_service": "${RELAY_TERMS_OF_SERVICE}",
  "limitation": {
    "max_message_length": ${RELAY_MAX_MESSAGE_LENGTH},
    "max_content_length": ${RELAY_MAX_CONTENT_LENGTH},
    "max_subscriptions": ${RELAY_MAX_SUBSCRIPTIONS},
    "max_limit": ${RELAY_MAX_LIMIT},
    "auth_required": $(bool_to_json "$RELAY_AUTH_REQUIRED"),
    "payment_required": $(bool_to_json "$RELAY_PAYMENT_REQUIRED"),
    "restricted_writes": $(bool_to_json "$RELAY_RESTRICTED_WRITES"),
    "created_at_lower_limit": ${RELAY_CREATED_AT_LOWER_LIMIT},
    "created_at_upper_limit": $(handle_null "$RELAY_CREATED_AT_UPPER_LIMIT")
  },
  "relay_countries": $(array_to_json "$RELAY_COUNTRIES"),
  "language_tags": $(array_to_json "$RELAY_LANGUAGE_TAGS"),
  "tags": $(array_to_json "$RELAY_TAGS"),
  "posting_policy": "${RELAY_POSTING_POLICY}"
}
EOFMETA

echo "✅ relay_metadata.json configured successfully"
echo "📋 Relay configuration:"
echo "   Name: ${RELAY_NAME}"
echo "   Description: ${RELAY_DESCRIPTION}"
echo "   Contact: ${RELAY_CONTACT}"
echo "   Countries: ${RELAY_COUNTRIES}"
echo "   Languages: ${RELAY_LANGUAGE_TAGS}"
echo "   Tags: ${RELAY_TAGS}"
echo ""
echo "🚀 Starting GRAIN relay..."
exec ./grain