
# Software Composition Analysis 

## Objective

This section aims to explain the software composition to perform the task and solve the 11th point of the [problem statement](https://intern-appsecco.netlify.app/problem-statement/) under Task 1.

## SCA

Software Composition Analysis (SCA) is a term for a set of tools that provides users visibility into their open source inventory. Despite its misleading name suggesting access to all aspects of the source code (proprietary, third party commercial, and open source), software composition analysis in effect acts as a open source management tool only.

SCA tools were born out of a cross-industry rise in open source usage which made it increasingly hard for companies to track open source components manually using spreadsheets, emails, and ticketing systems. As open source usage grew to encompass the majority of software creation, it became a necessity to automate the open source management process.

SCA tools come in different forms, offering a range of capabilities from those focused on licensing compliance only to others encompassing both security and license management.

## Importance

1. To automatically Track Open Source Components.
2. Continuous Monitoring for Vulnerability Detection
3. Automated and Prioritized Vulnerabilities Remediation
4. License Risk Management

## Software Composition Analysis Tools

Software Composition Analysis Tools scan open-source code software to inventory all open-source components. Then they enable companies to eliminate vulnerabilities and compatibility issues with open-source licenses like GPL(General Public License is a free, copyleft license used primarily for software and copyleft is the practice of granting the right to freely distribute and modify intellectual property with the requirement that the same rights be preserved in derivative works created from that property. The GNU GPL allows users to change and share all versions of a program.)

This becomes increasingly important as modern enterprise applications can comprise 80% to 90% open-source components. Given this ubiquity, the risk of security and IP risks of open-source components can be very significant, and tools to help mitigate these risks become critically important.

## SCA through OWASP Dependency Check

[Dependency-Check](https://owasp.org/www-project-dependency-check/) is a Software Composition Analysis (SCA) tool that attempts to detect publicly disclosed vulnerabilities contained within a project’s dependencies. It does this by determining if there is a Common Platform Enumeration (CPE) identifier for a given dependency. If found, it will generate a report linking to the associated CVE entries.

I performed the OWASP Dependency Check under the section [Static Analysis of SuiteCRM](https://intern-appsecco.netlify.app/sast-tools/#owasp-dependency-check) and the [report](https://github.com/Priyam5/internship-appsecco/blob/master/Reports/dependency-check-report.xml) got generated.
