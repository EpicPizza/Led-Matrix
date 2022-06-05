# Led Matrix

![PXL_20220601_002419297 MP](https://user-images.githubusercontent.com/91709069/172033723-39124e46-e459-4db5-afc7-ee5bf498284b.jpg)
![PXL_20220601_002502647](https://user-images.githubusercontent.com/91709069/172033729-ba7d1bc3-2c86-4bcd-822d-3e7eca62b357.jpg)
<img width="879" alt="Screen Shot 2022-06-02 at 11 06 38 PM" src="https://user-images.githubusercontent.com/91709069/172033657-1317e806-696d-4fce-b7cc-450f76748f07.png">


This is a project I made using a 32 by 32 rgb matrix. I made a case for it, and also made an editor to make images for it. I used a micro sd card to store the images on it. I also coding the arduino when it turns on, to look through all the files and using some parameters and also the ***image*** at the beginning to filter the files. It then loads all the names, and you can choose one using the buttons. 

Example of image file (in a txt file):

***image***eeeeeeeeeeeeeeeeeeeeepeeeeeemmmmeeeeeeeeeeeeeeeeeeeeepeeeeeemmmmeeeeeeeeeeeeeeeeeeeeeppeemeemmmmeeeeeeeeeeeeaaeeeeeeepppemeemmmmeeeeeeeeeeeaaaeeeeeeepppemmemmmmeeeeeeeeeeaaaaaeeeeeeppppmmmmmmmeeeeeeeeeaaaaaaaeeeeeppppemmmmmmeeeeeeeeaaaaaaaaaeeeeppppemmmmmmeeeeeeeaaaaaaaaaaaeeepppppemmmmmeeeeeeaaaaaaaaaaaaaeepppppemmmmmeeeeeaaaaaaaaaaaaaaaeppppppmmmmmeeeeaaaaaaaaaaaaaaaaapppmppmmmmmeeeeeeeeeeeeeeeeeeeeepppmmpmmmmmeeeeeeeeeeeeeeeeeeeeepppmmmmmmmmeeeeeeeeeeeeeeeeeeeeepppmmmmmmmmeeeeeeeeeeeeeeeeeeeeeppppmmmmmmmeeeeeeeeeleeeeeeeeeeeppppmmmmmmmeeeeleeeeleeeeeeeeeeepppppmmmmmmeeeeleeeleeeeeeeeeeeepppppmmmmmmeeeeleeeleeeeleeeeeeeppppemmmmmmeeeeleeleeeeeleeeeeeepppeemmmmmmleeefffffeeeleeeeeeeeppeeemmmmmmleefffffffeeleeeeeeeepemeemmmmmmelfffffffffleeeeeeeeeeemeemmmmmmefffffffffffeeeeeeeeeeemmemmmmmmfffffffffffffeeeeeeeeeemmmmmmmmmfffffffffffffeellleeeeemmmmmmmmmffffffffffffflleeeeeeeeemmmmmmmmfffffffffffffeeeeeeeeeeemmmmmmmmfffffffffffffeeeeeeeeeeemmmmmmmmefffffffffffelleeeeeeeeemmmmmmmmeefffffffffeeeelleeeeeeeemmmmmmm

To store the image and make it easily readable by the arduino, each letter represents one pixel, different letters representing different colors. The editor is also able to load and save images. Using the editor, you can choose from 16 different colors. I added options for squares, triangles, circles, and lines. For squares, triangles, and lines, there are options for non fill and filled next to it. The fill button fills the whole screen with the chosen button. The four arrows under that moves the whole image in the chosen direction. There is also undo and redo buttons that can save up to 40 steps.

 <img width="351" alt="Screen Shot 2022-06-04 at 2 36 20 PM" src="https://user-images.githubusercontent.com/91709069/172033697-5ebf43e6-80f4-4f4a-b043-da30eb87d5ed.png">


I finished this back during winter break, but there are some things I could fix and add. The redo and undo functions are not that smart. It just saves the whole image again and again. I also wanted to add animations, since the matrix could do that, but I have to fix the undo and redo before it starts getting laggy.The arduino connected to the matrix has memory issues too using the sd card which I haven’t gotten the time to fix yet. I also wanted to add custom colors, but the colors on the matrix are already limited to 12 bits and I would have to change how the image is stored. Even though I already finished it, there are still a lot of things I could do with this.
