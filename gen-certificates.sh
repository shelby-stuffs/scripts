# C: Country code (e.g., US) ST: State name L: City name O: Organization name OU: Organizational Unit name CN: Common name emailAddress: Your email address
#subject='/C=/ST=/L=/O=/OU=/CN=/emailAddress='
#subject='/C=DE/ST=Germany/L=Berlin/O=Max Mustermann/OU=Max Mustermann/CN=Max Mustermann/emailAddress=max@mustermann.de'
#########################################################################

subject='/C=RU/ST=Samara/L=Samara/O=Alexey Shelby/OU=Alexey Shelby/CN=Alexey Shelby/emailAddress=shelbyhell@proton.me'

mkdir ~/.android-certs

for x in releasekey platform shared media networkstack nfc testkey cyngn-priv-app bluetooth sdk_sandbox verifiedboot; do \
    ./development/tools/make_key ~/.android-certs/$x "$subject"; \
done
