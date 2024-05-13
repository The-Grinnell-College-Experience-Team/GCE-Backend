# The Grinnell College Experience

### 1. Idea and Goals
**The Grinnell College Experience** is a top-down 2D Role-Playing Game (RPG) mobile game in the setting of Grinnell College. This project started from the idea of remembering our college life (like a time capsule) and spreading Grinnell's joy & spirit to other external/prospective students.

**The Grinnell College Experience** uses 32x32 pixels textures to recreate Grinnell College in a virtualized setting. Users can customize their character, explore, Grinnell, and fight epic battles on the campus. We wish to utilize this in a fashion to be able to run this game on mobile devices, including iOS and Android. We ended up swapping to the Godot Engine for this game, for convenience in compiling to iOS.

### 2. Layout
Our repository layout consists mostly of the Godot Engine files and the `addons`, `assets`, `dialogue`, `scenes`, and `scripts` folders. We currently plan on utilizing a 43x20 grid system displayed on the phone, consisting of 32x32 textures.

**addons** <br>
This folder contains external plugin resources.

**assets** <br>
This folder contains all pixel art resources. Most pixel art was designed at [Pixilart](https://www.pixilart.com/).

**dialogue** <br>
This folder contains the dialogue contents for each NPC object.

**scenes** <br>
This folder contains all the scenes of the game. The game starts from the `menu.tscn`, and the main scene is `player_example.tscn`.

**scripts** <br>
This folder contains all scripts for each scene. You can check each script is attached to the relevant scenes (nodes).

### 3. Issue Tracker
You can check our entire issues from `Issues` tab. Click [here](https://github.com/The-Grinnell-College-Experience-Team/GCE-Backend/issues) to go to the page directly. <br>
We organized the same backlogs in `Project` tab. Click [here](https://github.com/orgs/The-Grinnell-College-Experience-Team/projects/6) to go to the page directly. <br>
Thanks to GitHub Issues, here we will be able to communicate and track any issues that may arise.

Below is the brief description for each board in our issue tracker in `Project` tab:

**Sprint To Do** <br>
This board contains the issues that are assigned to the current sprint. <br>
Issues are moved from the *To Do* board and you can check the assigned sprint and member(s). <br>
The first bubble in each issue means the estimated effort (hours) and the second bubble means the period (sprint dates).

**In Progress** <br>
The issues will be moved to this board if any team member starts assigned issue(s).

**Done** <br>
These boards contain the issues done so far.

**To Do** <br>
This board contains the remaining issues for our project. More issues may be added.

### 4. Sprint Reports
**4-1. Spring Planning Reports** <br>
Each sprint planning report can be found in `sprintPlanning.txt` in this repository. <br>
The weekly sprint planning report is updated between Wednesday and Friday.

**4-2. Sprint Review Reports** <br>
Each sprint review report can be found in `sprintReview.txt` in this repository. <br>
The weekly sprint planning report is updated every Tuesday.

### 5. Operational Features (Use Cases)
So far, you can experience 6 operational features.

* Intuitive control system for users
* Move around the pixelated Grinnell campus map
* Interact with multiple NPCs
* Play the battles with NPCs
* Save and load the game data
* Play the game on Android devices

In detail, our team discussed 4 use cases below during the class.

**5-1. Salif's use case** <br> 
Salif's use case (seeing Grinnell in a pixelated style) is somewhat operational, as the first demo recreates 8th Avenue with pixel art, but more of the map will be created soon. 

**5-2. Nick's use case** <br>
Nick's use case (wanting to battle against hypothetical people in college) is also mostly operational since there is a simple battle system implemented, but it will be further fleshed out and developed with more features (status effects, items, skills, etc.). 

**5-3. Jerry's use case** <br>
Jerry's use case (interacting with funny hypothetical people and objects throughout the map) is also almost fully operational. We have NPC interactions ready to go, but we'll need to add more Grinnell-themed easter eggs and characters throughout the map as development continues. 

**5-4. Lucie's use case** <br>
Lucie's use case (wanting an intuitive control system for movement) is operational. The player can move up, down, left, and right using the common, default inputs (the classic arrow keys with this demo). The walk-cycle is animated, providing a sense of flow within the character's movement.   

### 6. Building the System
To Build the project, you need to install Godot 4.2.1 (.NET Version). Follow the [link](https://godotengine.org/download/windows/) to download the game engine.

After the installation, open Godot 4.2.1 (.NET Version). Select the `import` tab, then open the folder that leads to this project. Next, select this project (labeled  `TheGrinnellCollegeExperience`), then choose the `edit` tab on the right side. Once the project loads, choose the hammer icon on the top right corner to build the project.

### 7. Testing the System
For Testing, we originally planned on using Unit testing, but we quickly realized that Unit testing isn't very feasible for the vast majority of our project. We plan on using Manual Testing and generally, this is the common practice for testing most video games in the industry (see [here](https://en.wikipedia.org/wiki/Game_testing)). In our case, we do not have a QA team we can use to help us, so we will need to do the testing ourselves. This will likely be difficult and time-consuming, but necessary for the type of project we have. We may end up with a few bugs, but our largest goal is to have no major or game-breaking glitches. Automation is heavily limited for this kind of project, but this is a necessary trade-off that we'll manually account for.

### 8. Running the System
To Run the project, open Godot 4.2.1 (.NET Version). Once, you've built the project, select this project (labeled  `TheGrinnellCollegeExperience`), then choose the `run` tab on the right side. Alternatively, if you're already in the `edit` mode for Godot, click the play icon next to the hammer to run the project.
