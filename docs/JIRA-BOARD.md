# JIRA board – why tickets may not show

Scrum boards in Jira often **filter by Team**. The dating-app tickets were created with:

- **Project:** SCRUM (StarTeam) ✓  
- **Team:** *(not set)*  
- **Sprint:** *(not set)*  

If your board is configured to show only issues for a specific team, issues without a Team won’t appear.

## How to fix

**Option A – Assign a team to the issues (recommended)**  
1. In Jira, open your team’s page and copy the **Team ID** from the URL:  
   `https://radiantsystem.atlassian.net/jira/people/team/XXXXXXXX` → the UUID is `XXXXXXXX`.  
2. Share that Team ID (e.g. in this chat). The agent can then set `customfield_10001` (Team) on all SCRUM-5, SCRUM-6, … SCRUM-22 issues so they show on the board.

**Option B – Change the board filter**  
In **Board settings → General → Filter**, edit the JQL so the board is not restricted by Team (e.g. use only `project = SCRUM`). Then all SCRUM issues will appear regardless of Team.

**Sprint**  
If the board only shows the **current sprint** (not the backlog), issues must be in that sprint to appear. Our tickets had **Sprint** = *(not set)*.

- **Option 1 – From the board:** In **Backlog**, select the issues and use **Add to sprint** → choose the current sprint.
- **Option 2 – Via API:** Get the **sprint ID** (a number): open your board, open the current sprint or the board’s backlog, and check the URL for something like `sprintId=123` or `selectedSprintId=123`; or in Jira go to **Board** → **Backlog** → sprint name → the ID may appear in the URL or in the sprint settings. Share that number and the agent can set `customfield_10020` (Sprint) on all SCRUM issues so they appear in the current sprint.
