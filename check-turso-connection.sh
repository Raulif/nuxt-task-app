#!/bin/bash

# Script to check Turso database connection using the Turso CLI

# Extract database URL and auth token from .env file
DB_URL=$(grep TURSO_DATABASE_URL .env | grep -v '#' | cut -d '=' -f2)
AUTH_TOKEN=$(grep TURSO_AUTH_TOKEN .env | cut -d '=' -f2)

echo "🔍 Checking connection to Turso database..."
echo "Database URL: $DB_URL"

# Check if Turso CLI is installed
if ! command -v turso &> /dev/null; then
    echo "❌ Turso CLI is not installed!"
    echo "Please install it first with:"
    echo "  curl -sSfL https://get.turso.tech/install.sh | bash"
    exit 1
fi

# Extract database name from URL
DB_NAME=$(echo $DB_URL | sed 's|libsql://\(.*\)\..*|\1|')

echo "Database name: $DB_NAME"
echo

# Check if we're already authenticated with Turso
TURSO_AUTH_STATUS=$(turso auth status 2>&1)
if [[ $TURSO_AUTH_STATUS == *"not logged in"* ]]; then
    echo "🔑 Not logged in to Turso. Attempting to authenticate with token..."
    # Create a temporary token file
    TEMP_TOKEN_FILE=$(mktemp)
    echo "$AUTH_TOKEN" > "$TEMP_TOKEN_FILE"
    
    # Authenticate with the token
    turso auth login --token-file "$TEMP_TOKEN_FILE"
    AUTH_RESULT=$?
    
    # Remove the temporary token file
    rm "$TEMP_TOKEN_FILE"
    
    if [ $AUTH_RESULT -ne 0 ]; then
        echo "❌ Authentication failed!"
        echo "Please check your TURSO_AUTH_TOKEN in the .env file."
        exit 1
    else
        echo "✅ Successfully authenticated with Turso!"
    fi
else
    echo "✅ Already authenticated with Turso"
fi

echo
echo "📋 Listing available databases:"
turso db list
echo

# Test the database connection by running a simple query
echo "🔄 Testing database connection with a simple query..."
QUERY_RESULT=$(turso db shell "$DB_NAME" "SELECT 'Connection successful!' as result;" 2>&1)

if [[ $QUERY_RESULT == *"Connection successful!"* ]]; then
    echo "✅ CONNECTION SUCCESSFUL!"
    
    # Check if the tasks table exists and has data
    echo
    echo "📊 Checking the 'tasks' table..."
    TABLE_CHECK=$(turso db shell "$DB_NAME" "SELECT count(*) as count FROM tasks;" 2>&1)
    
    if [[ $TABLE_CHECK == *"Error"* || $TABLE_CHECK == *"no such table"* ]]; then
        echo "⚠️  The 'tasks' table doesn't exist yet."
    else
        TASK_COUNT=$(echo "$TABLE_CHECK" | grep -oE '[0-9]+')
        echo "Found $TASK_COUNT task(s) in the database."
        
        if [ "$TASK_COUNT" -gt 0 ]; then
            echo
            echo "🔍 Fetching the first task:"
            turso db shell "$DB_NAME" "SELECT * FROM tasks LIMIT 1;"
        fi
    fi
    
    echo
    echo "✨ Your Turso database connection is working properly!"
else
    echo "❌ CONNECTION FAILED!"
    echo "Error details: $QUERY_RESULT"
    echo
    echo "💡 Possible issues:"
    echo "- Check if your database URL is correct"
    echo "- Verify that your auth token has the necessary permissions"
    echo "- Make sure the Turso service is available"
    echo "- Check your internet connection"
    
    exit 1
fi

exit 0

