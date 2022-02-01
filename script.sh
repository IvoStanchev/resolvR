#RESOLV_START
#DO NOT DELETE THE ABOVE STRING, STUFF WILL BREAK AFTER UPDATE
alias resolv='function resolv(){

    NAME="$(whoami)";
    DIR="/Users/$NAME/resolv";
    PYDIFF="/Users/$NAME/resolv/pydiff/pydiff.py";
    PYDIR="/Users/$NAME/resolv/pydiff";
    REPORTS="/Users/$NAME/resolv/reports";

    white="$(tput setaf 231)";
    red="$(tput setaf 1)";
    orange="$(tput setaf 208)";
    dark_blue="$(tput setaf 040)";
    dark_green="$(tput setaf 027)";
    reset="$(tput sgr0)";

    version="5"
    versionCheck=$(curl -s -L https://bit.ly/35V6mt9 | sed -n "1p");
    if [[ "$versionCheck" -gt "$version" ]]; then
        start=$(curl -s -L https://bit.ly/35V6mt9 | sed -n "2p");
        end=$(curl -s -L https://bit.ly/35V6mt9 | sed -n "3p");
        echo "A new version is available!";
        echo "Installing....";
        cp ~/.bash_profile ~/.bash_profile_resolv_update && sed -i "" "/$start/,/$end/{d;};" ~/.bash_profile_resolv_update && curl -s -L https://bit.ly/3ipdpiN >> ~/.bash_profile_resolv_update && mv ~/.bash_profile_resolv_update ~/.bash_profile && source ~/.bash_profile && source ~/.bashrc
        echo -e "Installation successfull, the new version is $versionCheck.";
        echo -e "Please reload your .bash_profile and run the script again.";
		curl -L ivostanchev.com/download/resolv_changelog.txt
        return 0;
    fi;

    if [[ "$1" == "--v" ]] || [[ "$4" == "--v" ]] || [[ "$5" == "--v" ]]; then
        echo -e "RESOLV Version: $versionCheck"
        return 0;
    fi;

    if echo $3 | grep "/"; then
        domain="$(echo $3 | awk -F"/" "{print \$1}")";
    else
        domain=$3;
    fi;

    if [[ "$3" == *"http://"* ]] || [[ "$3" == *"https://"* ]] || [[ "$3" == *"https"* ]] || [[ "$3" == *"http"* ]]; then
        echo -e "\nPlease remove the protocol from the URL.";
        return 0;
        fi;

    if [[ "$1" == "--h" ]] || [[ "$4" == "--h" ]] || [[ "$5" == "--h" ]]; then
        echo "Usage: resolv \$avalonIp \$cPanelIp \$domain_name"
        echo ""
        echo "Additional parameters."
        echo "--nodiff: Skip code difference."
        echo "--preview: Load the downloaded HTML files in a browser."
        echo "--h: Show this menu."
        echo "--v: Show current version."
        return 0;
    fi;

    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then

        if [[ "$1" != "--h" ]] || [[ "$1" != "--v" ]]; then
            echo "Missing or incorrect parameters!"
            echo "Usage: resolv \$avalonIp \$cPanelIp \$domain_name"
            echo "resolv --h: Show Help"
            return 0;
        fi;
    fi;


    function main(){
        echo -e $orange"\n******************** cPanel ********************";
        curl  --insecure -s -H "Cache-Control: no-cache" -LXGET http://$3 --resolve $domain:443:$1 --resolve $domain:80:$1 --resolve www.$domain:443:$1 --resolve www.$domain:80:$1 -w "Used IP: $1\ncPanel http://$3\n"$white"Download size: %{size_download}"$orange"\nStatus code: %{http_code}\nNumber of redirects: %{num_redirects}" -o $REPORTS/"$domain"_cpanel_insecure_"$(date +%F)".html;
        curl  --insecure -s -H "Cache-Control: no-cache" -LXGET https://$3 --resolve $domain:443:$1 --resolve $domain:80:$1 --resolve www.$domain:443:$1 --resolve www.$domain:80:$1 -w "\n\nUsed IP: $1\nSecure cPanel https://$3\n"$white"Download size: %{size_download}"$orange"\nStatus code: %{http_code}\nNumber of redirects: %{num_redirects}\nSSL Verification:\n$(curl -v --silent -XGET -L --ssl https://$3 2>&1 --resolve $domain:443:$1 --resolve $domain:80:$1 --resolve www.$domain:443:$1 --resolve www.$domain:80:$1 | grep -E "(unable|Server certificate|resolve|SSL certificate problem)" -A6)" -o $REPORTS/"$domain"_cpanel_secure_"$(date +%F)".html;
        echo -e $dark_blue"\n\n******************** Avalon ********************";
        curl  --insecure -H "Cache-Control: no-cache" -s -LXGET http://$3 --resolve $domain:443:$2 --resolve $domain:80:$2 --resolve www.$domain:443:$2 --resolve www.$domain:80:$2 -w "Used IP: $2\nAvalon http://$3\n"$white"Download size: %{size_download}"$dark_blue"\nStatus code: %{http_code}\nNumber of redirects: %{num_redirects}" -o $REPORTS/"$domain"_avalon_insecure_"$(date +%F)".html;
        curl  --insecure -s -H "Cache-Control: no-cache" -LXGET https://$3 --resolve $domain:443:$2 --resolve $domain:80:$2 --resolve www.$domain:443:$2 --resolve www.$domain:80:$2 -w "\n\nUsed IP: $2\nSecure Avalon https://$3\n"$white"Download size: %{size_download}"$dark_blue"\nStatus code: %{http_code}\nNumber of redirects: %{num_redirects}\nSSL Verification:\n$(curl -v --silent -XGET -L --ssl https://$3 2>&1 --resolve $domain:443:$2 --resolve $domain:80:$2 --resolve www.$domain:443:$2 --resolve www.$domain:80:$2 | grep -E "(unable|Server certificate|resolve|SSL certificate problem)" -A6)" -o $REPORTS/"$domain"_avalon_secure_"$(date +%F)".html;

        if [[ "$4" == "--preview" ]] || [[ "$5" == "--preview" ]]; then
            python -m webbrowser -t "file://$REPORTS/"$domain"_cpanel_insecure_"$(date +%F)".html" >> /dev/null 2>1 ;
            python -m webbrowser -t "file://$REPORTS/"$domain"_cpanel_secure_"$(date +%F)".html"  >> /dev/null 2>1;
            python -m webbrowser -t "file://$REPORTS/"$domain"_avalon_insecure_"$(date +%F)".html"  >> /dev/null 2>1;
            python -m webbrowser -t "file://$REPORTS/"$domain"_avalon_secure_"$(date +%F)".html"  >> /dev/null 2>1;
        fi;

        echo -e $dark_green"\n\n******************** Features information ********************";
        echo -e "\nAdd the RESOLV script string to https://migrations.sgvps.net"$reset;
        echo -e "\n- Download and install TamperMonkey addon for your browser";
        echo -e "\n- Access this URL and install the script "$dark_green"https://ivostanchev.com/download/resolv_host_mod.user.js."$reset;
        echo -e "\n- Each entry is added when you click on the domain name in the migrations menu below the original host file.\n";
        echo -e $dark_green"You can use two aditional aliases to add/remove cPanel or Avalon host strings to your /etc/host.\n"$reset;
        echo -e "Usage:";
        echo -e "avalon: Add/Remove the Avalon host to your hosts file.";
        echo -e "cpanel: Add/Remove the cPanel host to your hosts file.\n";
        echo -e $dark_green"******************** Host file ********************.\n";
        echo -e "HOST FILE:";

        AVALON="$2 $domain www.$domain";
        CPANEL="$1 $domain www.$domain";

        echo -e "CPANEL: \n$CPANEL";
        echo -e "AVALON: \n$AVALON"$reset;

        if [[ "$4" != "--nodiff" ]] && [[ "$5" != "--nodiff" ]]; then
            screen -dmS python_http python "$PYDIFF" -p "$REPORTS/"$domain"_cpanel_insecure_"$(date +%F)".html" "$REPORTS/"$domain"_avalon_insecure_"$(date +%F)".html";
            screen -dmS python_https python "$PYDIFF" -p "$REPORTS/"$domain"_cpanel_secure_"$(date +%F)".html" "$REPORTS/"$domain"_avalon_secure_"$(date +%F)".html";
        fi;
    };

    if [ -e "$DIR" ] && [ -e "$PYDIR" ] && [ -e "$REPORTS" ]; then
        echo "";
        echo "";
        echo -e $dark_green"*****************************************************" ;
        echo -e "                    RESOLV";
        echo -e "*****************************************************" ;
        echo "";
        echo -e $red"IMPORTANT!"$reset;
        echo -e $dark_green"1. The loaded HTML file may not load all scripts of the original website.";
        echo -e "2. CURL will bypass any SSL warnings. The script checks the SSL validity separately.";
        echo -e "3. HTML files are saved in $REPORTS.";
        echo -e "4. Host file aliases will fetch their values based on the last domain ran by the script"$reset;
        main {$1,$2,$3,$4,$5};
    else
        echo -e $red"The required directories do not exist.\n"$reset;
        echo -e $orange"Creating directory $DIR...\n"$reset;
        mkdir "$DIR";
        echo -e $orange"Creating directory $PYDIR...\n"$reset;
        mkdir "$PYDIR";
        echo -e $orange"Creating directory $REPORTS...\n"$reset;
        mkdir "$REPORTS";
        echo -e $dark_blue"All directories created successfully.\n"$reset;
        echo -e $orange"Downloading Python magic"$reset;
        sleep 2;
        screen -dmS python_download git clone --recursive https://github.com/yebrahim/pydiff.git /Users/$NAME/resolv/pydiff;
        main {$1,$2,$3,$4,$5};
    fi;
};resolv';
alias avalon='function avalonHost(){

    white="$(tput setaf 231)";
    red="$(tput setaf 196)";
    orange="$(tput setaf 208)";
    dark_blue="$(tput setaf 040)";
    dark_green="$(tput setaf 027)";
    reset="$(tput sgr0)";

    if grep -q "$AVALON" "/etc/hosts"; then
        echo -e $red"\n$AVALON removed from /etc/hosts. \n";
        dscacheutil -flushcache
        echo -e  "Mac DNS cache flushed."$reset;
        printf "%s\n" ",s/$AVALON//g" w q | ed /etc/hosts  > /dev/null;
    else
        if grep -q "$CPANEL" "/etc/hosts"; then
            echo -e $red"cPanel entry found for the same website, removing! \n";
            printf "%s\n" ",s/$CPANEL//g" w q | ed /etc/hosts  > /dev/null;

        fi;
        echo "$AVALON" >> /etc/hosts;
        echo -e "";
        echo -e $dark_blue"$AVALON has been added to /etc/hosts. \n";
        dscacheutil -flushcache
        echo -e "Mac DNS cache flushed."$reset;
    fi;
};avalonHost';
alias cpanel='function cpanelHost(){

    white="$(tput setaf 231)";
    red="$(tput setaf 196)";
    orange="$(tput setaf 208)";
    dark_blue="$(tput setaf 040)";
    dark_green="$(tput setaf 027)";
    reset="$(tput sgr0)";

    if grep -q "$CPANEL" "/etc/hosts"; then
        echo -e $red"\n$CPANEL removed from /etc/hosts. \n";
        printf "%s\n" ",s/$CPANEL//g" w q | ed /etc/hosts  > /dev/null;
        dscacheutil -flushcache
        echo -e  "Mac DNS cache flushed."$reset;
    else
        if grep -q "$AVALON" "/etc/hosts"; then
            echo -e $red"Avalon entry found for the same website, removing! \n";
            printf "%s\n" ",s/$AVALON//g" w q | ed /etc/hosts  > /dev/null;
        fi;
        echo "$CPANEL" >> /etc/hosts;
        echo -e "";
        echo -e $orange"$CPANEL has been added to /etc/hosts. \n";
        dscacheutil -flushcache
        echo -e  "Mac DNS cache flushed."$reset;
    fi;
};cpanelHost';
#DO NOT DELETE THE BELLOW STRING, STUFF WILL BREAK AFTER UPDATE
#RESOLV_END
