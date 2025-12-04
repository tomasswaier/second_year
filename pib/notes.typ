#set heading(numbering: "1.")

#show link: set text(fill: blue, weight: 700)
#show link: underline

= Notes for presentation

The Common Weakness Enumeration is a category system for hardware and software weaknesses and vulnerabilities. It is currently maintained by Mitre but you may find other maintainers as well. This enumeration provides a common way of describing weaknesses. This kind of list allows for better understanding and collaboration between developers. 

As my project will be mainly focusing on open source vulnerability scanning software for web applications I will be focusing on these 3 CWEs (I will also mention them in a minute

- CWE-89: Improper Neutralization of Special Elements used in an SQL Command
- CWE-552: Files or Directories Accessible to External Parties
- CWE-1104: Use of Unmaintained Third Party Components

Project will later contain introduction to open source web vulnerability scanners and how they operate. This section should give reader a better understanding on their functionality and technical details.


Next, the relevance of open source tools in web security will be explained as I belive this to be key part in my project. Arguably, Open source has never been more relevant and with IT moving so fast the security has never been a bigger topic. Not only does open source help starting developers but also professionals and according to a report by Red Hat, 95% of IT leaders agree that open-source solutions are strategically important to their organization’'s overall enterprise infrastructure software strategy.
-- for later https://www.redhat.com/en/enterprise-open-source-report/2022


Focus Areas of my project will be on CWEs mentioned before. SQL injection, hidden file detection and outdated component detection. These 3 were chosen for their relevancy in common web apps.  

Importance of controlled testing evnironment is a part which I belive to be important to mention. Tests not executed under controlled environment may lead to unexpected behavior and wrong test results. This section will have a concise description of my environment and testing applications. 

Requirements for choosing tools include popularity and toolset. To test CWEs selected for this project the tools need to have the appropriate functionality. As there are many applications which tackle these problems I decided to choose by popularity. To make experiments more relevant I chose an additional app which specializes in only in finding hidden files that is dirsearch.


Reasons for choosing this tool will be in section describing the comparison between general purpose (or also called blackbox) tools and specialized tools will be explained. As this project will contains part covering differences between these two types of application a comparison will be present for better understanding of project and tests.  

Tests will take place i environment described in one of the previous sections and they will be done in 2 waves. First tests are conducted with default settings. Second wave of tests will be done with optimal configuration. Emphasis will be put on the tests with optimal configuration as those results will have highest relevance.

Testing will be conducted on these 3 targets:
  Custom vulnerable web application
  laravel application
  (Damn Vulnerable Web Application)



