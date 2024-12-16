Touchscreen StepSequencer

Name: Riley Hogarty

Student Number: C20426892

Class Group: TU858

# Description of the project
A step sequencer deployed in a 3d world, where the player character controls the player via touchscreen joysticks and an interaction button. The step sequencer is operated by buttons/switches. 

# Instructions for use
Import the project to the godot game engine using the project.godot file. Once successfully imported, press F5 to run the main scene. Once the scene is loaded, press escape and use the mouse as you touchscreen interaction.

# How it works
The main scene of the project is music_project, this is where all the components are combined into the final product. The main components that it is pulling from are the player model, the sequencer model, the HUD and the world model. The player model is where the character model and how it interacts with the world was decided. Affixed to the top of this character model was a 3d camera for a first person view of the world. The character model and the world model are fitted with entities called collision shapes, which effectively rule how the user is allowed to navigate the world. The user is moved using the joysticks that are in each corner of the screen, with the bottom left determining movement direction and the bottom right determining camera rotation. The step sequencer layout in its most basic function contains 2 lines of buttons/switches. One determines the amount of steps in the sequence, and the other determines the instrument that is currently being played. This is achieved by using an array of arrays and a round robin methodology. Instead of having one audiostreamplayer managing the audio being played, here there is 50 employed. This is to circumnavigate the limitations of small numbers of audio players. With small numbers, you must wait until one sequence is done playing before it moves on to the next one, and even with more than one, they can face congestion issues. However with 50, a builup of traffic would be incredibly unlikely. There are also other small functions that manipulate the audiobus directly as well. When the user approaches one of these switches, a message will be displayed on screen prompting them to interact with it. By pressing the interact button on the entity, they as the namesake suggests, interact with it. All user activities are achieved using this method in the project, 

# List of classes/assets in the project

| Class/asset | Source |
|-----------|-----------|
| Music_Project.tscn | Self written |
| Sequencer.tcsn | Modified from [reference](https://github.com/skooter500/GE1-2024) |
| InteractiveButton.gd | From [reference](https://www.youtube.com/watch?v=R_4IfER7rK8) |
| FPController.gd | Modified from [reference](https://github.com/3ddelano/godot-button-3d) + (https://github.com/skooter500/GE1-2024) |
| hud.tcsn | Modified from [reference](https://kenney.nl/assets/onscreen-controls) |


# References
* [Item 1](https://www.youtube.com/watch?v=R_4IfER7rK8)
* [Item 2](https://github.com/3ddelano/godot-button-3d)
* [Item 3] (https://github.com/skooter500/GE1-2024)
* [Item 4](https://kenney.nl/assets/onscreen-controls)

# What I am most proud of in the assignment
The navigation system was a part i had predicted to be very difficult, so the fact that i was able to get it working properly was an achievement. I am also very proud of how hard I worked, despite the fact the final product wasn't what I had originally intended. 

# What I learned
I learned a lot about how step sequencers work, which was an instrument I was not even aware of before this project began. Throughout this project I became more familiar with working with godot, which I see as a useful experience going forward, due to the growing popularity of the game engine.


Where I Can Improve:

| What | Why |
|-----------|-----------|
|Planning| Whilst I believe my plan at the start was adequate, I think I was too quick to move on and try new solutions. For instance not sticking with a XR project meant I had to redo and remap the user controls |
|Timing | When undertaking another project like this in the future I would prefer to have less unexpected circumtanses, like family bereavement occur, as it can greatly affect the amount of time that can be devoted to a project|
|Experience | By using the experience I had with this Project, I believe I would be able to turn in a more efficient and effective effort in the future. |

