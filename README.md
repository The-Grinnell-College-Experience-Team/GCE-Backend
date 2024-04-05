# The Grinnell College Experience

### Idea and Goals
We want to create a video game that uses 32x32 pixels textures to recreate Grinnell College in a virtualized setting. We wish to utilize this in a fashion to be able to run this game on mobile devices, including iOS and Android. We ended up swapping to the Godot Engine for this game, for convenience in compiling to iOS.

### Layout
As of right now, our repository layout consists mostly of the Godot Engine files and the `assets`, `scripts`, and `scenes` folders. We will likely add many things and the scrips will either be in GDScript or C#, most likely. We may potentially also add C++, but that is unlikely. However, if we switch to an established game engine, then this will change completely to match the git requirements of the project code for the respective game engine.

We currently plan on utilizing a 43x20 grid system displayed on the phone, consisting of 32x32 textures.

### Issue Tracker
We have our backlog at the following link: https://github.com/orgs/The-Grinnell-College-Experience-Team/projects/6 <br>
Thanks to GitHub Issues, here we will be able to communicate and track any issues that may arise.

Below is the brief description for each board in our issue tracker:

**Remaining Issues** <br>
This board contains the remaining issues for our project. More issues may be added.

**Sprint N To Do** <br>
This board contains the issues that are assigned to the current sprint. <br>
Issues are moved from the *Remaining Issues* board and you can check the assigned member(s) to each sprint. <br>
The first bubble in each issue means the estimated effort (hours) and the second bubble means the period (sprint dates).

**In Progress** <br>
The issues will be moved to this board if any team member starts assigned issue(s).

**Sprint N Done** <br>
These boards contain the issues done in each sprint.


### Spring Planning Reports
Each sprint planning report can be found in `sprintPlanning.txt` in this repository. <br>
The weekly sprint planning report is updated between Wednesday and Friday.

### Sprint Review Reports
Each sprint review report can be found in `sprintReview.txt` in this repository. <br>
The weekly sprint planning report is updated every Tuesday.


### Building and Testing and Running
To Build the project, open Godot 4.2.1 (.NET Version). Select the `import` tab, then open the folder that leads to this project. Next, select this project (labelled  `TheGrinnellCollegeExperience`), then choose the `edit` tab on the right side. Once the project loads, choose the hammer icon on the top right corner to build the project.

For Testing, we originally planned on using Unit testing, but we quickly realized that Unit testing isn't very feasible for the vast majority of our project. We plan on using Manual Testing and generally this is the common practice for testing most video games in the industry (see https://en.wikipedia.org/wiki/Game_testing). In our case, we do not have a QA team we can use to help us, so we will need to do testing ourselves. This will likely be difficult and time-consuming, but necessary for the type of project we have. We may end up with a few bugs, but our largest goal is to have no major or game-breaking glitches. Automation is heavily limited for this kind of project, but this is a necessary trade-off that we'll manually account for.

To Run the project, open Godot 4.2.1 (.NET Version). Once, you've built the project, select this project (labelled  `TheGrinnellCollegeExperience`), then choose the `run` tab on the right side. Alternatively, if you're already in the `edit` mode for Godot, click the play icon next to the hammer to run the project.
