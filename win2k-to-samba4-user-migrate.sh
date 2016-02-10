# Get All AD Users into LDIF File
ldapsearch -xb 'dc=rnao,dc=org' -LLL -D "administrator@rnao.org" -W '(&(objectClass=user)(&(objectClass=computer)))' \
  dn objectClass cn givenName sAMAccountName userAccountControl userPrincipalName description -h 192.168.2.3 > users_win2k3.ldif

# Change DC Name
sed -i 's/DC=oldserver/DC=newserver,DC=linux/g' users_win2k8.ldif

# Change User principal domain 
sed -i  's/@oldserver/@newserver.linux/g' users_win2k8.ldif

# Edit ldif file and remove unwanted accounts administrator and other a/c which you don't want 

# Finally Add all users :) 
ldapadd -c -h localhost -D CN=Administrator,CN=Users,DC=newserver,DC=LINUX -f users_win2k8.ldif  -W

# Now set all accounts to default password 
for user in $( grep -oP '(?<=^sAMAccountName:\s).*(=?)' users_win2k8.ldif );
do
	echo "Setting Password for : $user"
	samba-tool user setpassword --newpassword='pass@123' $user 
done

#sahbul3U
