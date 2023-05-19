# compress-folder

Windows script to compress a folder and copy the resulting 7zip file to a backup location.

Version: 1.0.0

Dependencies:

- [7Zip](http://www.7-zip.org/)

## Syntax

```shell
compress-folder[.cmd] [--dev] [--pause]
```

> --dev: use dynamic list of inclusions and exclusions for developers
  
## Inclusions/Exclussions

Please check [compress-folder.cmd](./compress-folder.cmd) for list of inclusions and exclusions.

## Disclaimer (Honest one)

I know! This is not the best solution, specially if you think of the wonderful capabilities of various scripting languages and platforms such as PowerShell Core.

Allow me to tell you that: yes! I have redesigned and over-engineered this project so many times in the last 25 years just to find that some people only cares about quick and dirty solutions.

I am not necesarily proud but the fact that some people (read: me) have mentioned to me (in private) that over the years this script was a source of mental tranquility is enough to keep it in GitHub as a statement of "I am still a humble script programmer".

One of these days I will execute the below TODO list:

### TODO

- Create a new language to address the specific needs of programmers who need to backup their files (narrowed expectations). If there is an existing one for this purpose, no worries! just add a *YA* (Yet Another) in front of the name
- Use DDD so we can create a fantastic ubiquitous language for the aforementioned need.
- Create extensive *TDD* so we can test all scenarios, including those nasty corner cases that cause a file to dissapear from your `projects` folder and that for some magical reason were not stashed, committed or pushed to Git and which for another mythical reason are needed on a monday morning.
- Implement it as at least 67 *microservices* running in perfect orchestrated containers in all the three major cloud kubernetes providers.
- Add extensions for everything for free: including but not limited to Facebook, Twitter, Jira, Microsoft Office 365. *OAuth 2* enabled off course.
- Last but not least ... make sure it provides an *API* and *CLI* for CP/M, *MS/PC DOS*, Windows, MAC, Linux, Unix, OS/2, AS/400, Palm OS, and `{{regular expression here}}`

### In Summary

Please bear with me and embrace mediocrity (at least for today) ;-)
