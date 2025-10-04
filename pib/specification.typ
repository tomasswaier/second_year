#set page(paper: "a4")
#set heading(numbering: "1.")

#show link: set text(fill: blue, weight: 700)
#show link: underline

= Specification

In this project I will be comparing different open source tools for scanning servers and finding vulnerabilities in web applications. Applications which will be Dirsearch,w3af,nikto,CloudSploit,Wapiti,Vega and Grabber. 
These applications are each very different, some are blackbox of tools and different functionalities such as nitko, capable of detecting sql injections, subdomain guesing, file detection, credential guessing and much more. Others on the other hand were built and optimized for specific task such as Dirsearch. Program made only for blindly trying to find hidden files from predefined dictionary.

== tests to compare tools:
=== sql injection. 

