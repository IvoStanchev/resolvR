+++++++++++++++++++++++++ Description +++++++++++++++++++++++++

Main: Resolves one domain from two different IP’s without the need of a host file and helps discover differences in the DOM tree.
Secondary:
- The script gathers the collected information and adds two aditional aliases which hold the host file entry for Avalon and cPanel. You can just type avalon or cpanel and the host file will be populated with the string. SEE USAGE
- JavaScript integration with migration.sgvps.com (Migrations interface) which will add the alias command for each domain for ease of use: SEE INSTALLATION AND DELETION SECTION.
- The script provides general website loading information such аs detailed SSL status, IP, Status Code, Redirection count and download size.
IMPORTANT:
1. The script uses curl to download the static content and the loaded HTML file may not include all scripts of the original website.
2. CURL will bypass any SSL warnings, however, the script checks the SSL validity separately.
3. HTML files are saved in /Users/$user/resolv/reports.
4. Host file aliases will fetch their values based on the last domain ran by the script

+++++++++++++++++++++++++ Usage +++++++++++++++++++++++++

Main alias:
	resolv $cPanel_IP $Avalon_IP $Domain_name [options]
	 	--nodiff: Skip code difference.
		--preview: Load the downloaded HTML files in a browser.
	 	--v: Show version
 		--h: Show help
Secondary alias (This is available after the main script finishes):
	avalon
	 - adds/removes the avalon host to your host file.
	cpanel
	 - adds/removes the cpanel host to your host file.
IMPORTANT: Host file aliases will fetch their values based on the last domain ran by the script
IMPORTANT: Host file aliases will flush the DNS cache on your mac.

+++++++++++++++++++++++++ Features +++++++++++++++++++++++++

Main:
- Fetches a domain from two different hosts using Curl and saves 4 HTML files with different versions of the website.
- Loads 4 browser tabs with 4 versions of the domain, 2 secure/insecure cPanel, 2 secure/insecure Avalon.
- Loads 2 additional windows which compare the DOM tree of the two secured and two non-secured versions of the domain using Python.
Information:
- Sends a Cache-Control header with each request to fetch the correct uncached content from the server.
- Shows number of redirections for both cPanel and Avalon.
- Shows Download size for both cPanel and Avalon.
- Shows HTTP Status code for both cPanel and Avalon.
- Shows the used IP for each version of the site for both cPanel and Avalon.
- Separately checks for the SSL validity and displays proper detailed information for both cPanel and Avalon.
Aliases:
When the script is installed and ran, it comes with two additional aliases which allow the user to switch between avalon and cpanel host files. See the Usage section.

+++++++++++++++++++++++++ Installation and deletion +++++++++++++++++++++++++

CHECK IF YOU HAVE ANOTHER ALIAS NAMED resolv AND RENAME ONE OR THE OTHER.
A backup will be created and three aliases will be appended to your ./bash_profile.
Install
bash <(curl -s -L https://bit.ly/2Y18D1P | sed -n "1p")
Uninstall:
bash <(curl -s -L https://bit.ly/2Y18D1P | sed -n "2p")
TamperMonkey integration.
- Download and install TamperMonkey addon for your browser: https://www.tampermonkey.net/
- Access this URL and install the script https://ivostanchev.com/download/resolv_host_mod.user.js.
- Reload migration page, load a migration and click on one of the available domains where the normal host files is displayed. You should see the new entry there. 
