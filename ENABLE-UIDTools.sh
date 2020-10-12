#!/bin/zsh

# This script should be delivered securely to clients to embed required values and service account credentials. 

# Must be run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

# Required Variables
UIDTOOLS_PLIST="tld.your.uidtools" #The domain for the plist in /var/root/Library/$UIDTOOLS_PLIST
DOMAIN="your.tld" #Your AD Domain
KERB_REALM="YOUR.TLD" #Your AD Kerberos Realm
SEARCH_BASE="dc=your,dc=tld" #Your LDAP Search Base	
LDAP_SERVER="" #Hardcoding a DC, will bypass closest dc lookup and will only attempt lookup against this DC
SVC_ACCOUNT_NAME="uidtools_ldap_query" #Your service account 
SVC_ACCOUNT_PASS="SuperSecretPassword"
TEST_USER="$SVC_ACCOUNT_NAME" #Test user or group to validate UIDTools is working
TEST_USER_ID="123456789" #Expected UID/GID from a conversion
    
# MAIN
defaults write $UIDTOOLS_PLIST DOMAIN "$DOMAIN"
defaults write $UIDTOOLS_PLIST KERB_REALM "$KERB_REALM"
defaults write $UIDTOOLS_PLIST LDAP_SERVER "$LDAP_SERVER"
defaults write $UIDTOOLS_PLIST SEARCH_BASE "$SEARCH_BASE"
defaults write $UIDTOOLS_PLIST SVC_ACCOUNT_NAME "$SVC_ACCOUNT_NAME"
defaults write $UIDTOOLS_PLIST SVC_ACCOUNT_PASS "$SVC_ACCOUNT_PASS"

# Add LDAP Service account and password to System keychain for /user/bin/kinit
if (security find-generic-password -l "$KERB_REALM ($SVC_ACCOUNT_NAME)" "/Library/Keychains/System.keychain"); then
	security delete-generic-password -l "$KERB_REALM ($SVC_ACCOUNT_NAME)" "/Library/Keychains/System.keychain"
fi
security add-generic-password -a "$SVC_ACCOUNT_NAME" -l "$KERB_REALM ($SVC_ACCOUNT_NAME)" -s "$KERB_REALM" -w "$SVC_ACCOUNT_PASS" -T "/usr/bin/kinit" -U "/Library/Keychains/System.keychain"

if [ -f "/Library/Application Support/YourNAME/UIDTools/UIDTool" ]; then
	if [[ $TEST_USER_ID = $("/Library/Application Support/YourNAME/UIDTools/UIDTool" "$TEST_USER") ]]; then
    	echo 0
        exit 0
    	else
        echo 1
        exit 1
    fi
    else
    echo "DOMAIN key in $UIDTOOLS_PLIST = "$(defaults read $UIDTOOLS_PLIST DOMAIN)
fi

exit 0