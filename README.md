# skinny-mann
this is a crappy 2D platform game ...... or is it

change log  

0.4.0_Early_Access
-changed: JSON Arrays are no longer used internally for storing game objects and processing calculations  
-human seek: massively improved performance   
-added: 3D shadow  
-changed: when standing at a portal the text "Press E" now appears in your face  
-removed: how to play menu  
-added: narrated tutorial   
-changed: main menu now says Early Access  
-added: 3D shadow setting  
-added: tutorial narration mode setting  


0.3.1_ALFA  
-fixed: progress file would not be created if it did not exist


0.3.0_ALFA  
+added: 3D stages  
+added: level-5  
+added: level-6  
-fixed: seccond jump in level-2 was sometimes imposible  
=updated to processing 4.0b1  
=updated to java 11, open JDK 11 or higher will be required to run the game without java included  
+added: glitch effect  
-changed: startup screen is now 3D  
-changed: settings menue now has multple screens  
-removed: screen scrolling location setting  
+added: horozontal screen scrolling location setting  
+added: vertical screen scrolling location setting  
+added: music  
+added: music volume slider  
+added: sfx volume slider  
+added: level complete sound  

0.2.1_ALFA  
-fixed: sky poked through level terrain occasionally when moving  
-fixed: position not being changed when using interdimensional portal  

0.2.0_ALFA  
-changed: all movement and player physics calculations now run on independent processing thread  
+added: vertical camera movement  
+added: level 3  
+added: level 4  
+added: kill planes  
-changed: settings is now stored in a new location so they should not reset in the next update  
-changed: the settings menu now pops up the first time you open the game  
-changed: screen scrolling location setting is now a slider between 100-350  
+added: display fps option  
+added: display debug info option  
+added: debug info  
+added: options button in pause menu  

0.1.0_ALFA  
-changed: redone level structure  
-removed: all beta levels  
-changed: player moment speed is no longer linked to frame rate  
-changed: jump height is now much higher and speed is now independent of the frame rate all of this is subject to change  
-changed: player collisions are now calculated at multiple points around the edge of the player instead of 1 point at the bottom middle and 1 point at the top middle  
-added: COINS $$$$$$$$$ -no use yet  
-added: interdenominational portal  
-added: sub stages  
-added: update detection system (applied retroactively)  
-changed: pause button is now escape  
-added: additional functionality to the escape button  
-fixed: how to play now scales properly at different resolutions  
-added: characters to the main menu  
-added: ALFA under the title  
-removed: local multiplayer  
-changed: checkpoint pole now turn yellow when activated  
-added: level 1  
-added: level 2  

0.0.2_bata  
-added: level 5, bewhare the lava  
-note: this is the last update before ALFA  

0.0.1_bata  
-added: boxes that dont have collision  
-added: level 4, through the trees  
-changed: checkpoints have slightly larger rages  
-changed: spaces can now be used in multyplayer names  

0.0.0.5_bata the resolution update  
-added: verticle resolution setting  
-added: fullscreen mode (milage may varry)  
-changed: every time something neede to be drawn it now also neede to be scaled  

0.0.0.4_bata  
-added: level 3  
-added: how to play menue  
-changed: gravity now allows you to land on platform thet dont have a y value divisible by 5 level 3+  
-changed: slightly wider range for checkpoint activation level 3+  
-changed: imporoved backend networing for multyplayer   
-fixed: hosting player name nolonger displays as blue  
