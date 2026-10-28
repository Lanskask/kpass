# macOS Keychain wrapper mimicking 'pass'
kpass() {
	local account="$USER"

	# Insert
	if [[ "$1" == "set" ]]; then 
		if [[ -z "$2" ]]; then echo "Usage: kpass insert <id>"; return 1; fi

		printf "Enter password for %s: " "$2"
		read -rs secret
		echo 

		# -U flag updates the password if it already exists 
		security add-generic-password -a "$account" -s "$2" -w "$secret" -U
		echo "Saved to macOS Keychain: "

	# Copy to clipboard
	elif [[ "$1" == "copy" ]]; then 
		if [[ -z "$2" ]]; then echo "Usage: kpass -c <id>"; return 1; fi

		# Send directly to MacOS clipboard
		security find-generic-password -a "$account" -s "$2" -w | tr -d "\n" | pbcopy

	# Export to environment
    elif [[ "$1" == "export" ]]; then
        if [[ -z "$2" ]]; then 
            echo "Usage: kpass export <KEY_NAME>"
            return 1
        fi
        
        local key_name="$2"
        local secret
        
        # 2>/dev/null hides the macOS system error
        secret=$(security find-generic-password -a "$account" -s "$key_name" -w 2>/dev/null)
        
        if [[ $? -eq 0 && -n "$secret" ]]; then
            export "$key_name"="$secret"
            echo "Exported $key_name to current session."
        else
            echo "Error: '$key_name' not found in Keychain."
            echo "Did you forget to run 'kpass insert $key_name' first?"
            return 1
        fi

	# Retrieve
	elif [[ -n "$1" ]]; then 
		security find-generic-password -a "$account" -s "$1" -w
		echo 

	else 
        echo "Keychain Pass (kpass)"
        echo "---------------------"
        echo "Store:    kpass set KEY_NAME"
        echo "Retrieve: kpass KEY_NAME"
        echo "Copy:     kpass copy KEY_NAME"
        echo "Export:   kpass export KEY_NAME"
    fi
}