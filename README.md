# Maya-PBR-BRDF-VP2
A WIP Implementation of a Physically Plausible (PBR/PBS) HLSL Shader for the Maya Viewport 2.0

What's new?
- opacity (In maya you there are several alpha sorting methods with VP2, I think weighted average works best and depth peeling doesn't seem to work right most of the time)
- vertex baked AO
- I recently re-organize the properties
- Exposure for IBL diffuse / specular (uses pre-convolved .dds lighting cubes.  (To Do: implement HDR source images for cubes. The intent is that this shader use all source art - your pipeline will, combine masks, swizzle channels, compress and crunch data into an optimized version if you are using this to create game art.)
- in test I used IBL's generated with: https://github.com/derkreature/IBLBaker
- and the shader ball is from: https://github.com/derkreature/ShaderBall

![alt tag](https://github.com/HogJonnyMaxPlay/Maya-PBR-BRDF-VP2/blob/master/images/moreBetterFeatures.png)

I have to give thanks ... there is a ton of useful information out on the web, all you have to do is start googling topics like PBR; you will find a myriad of papers, forum posts, tutorials, personal projects and the likes.  I did not create or invent anything new here (I used a variety of methods and made whatever tweaks and changes made my implementation work.)

Some help stands out more then others:

https://github.com/derkreature

https://github.com/derkreature/IBLBaker

https://github.com/derkreature/ShaderBall

http://www.filmicworlds.com/author/john-hable/

http://filmicgames.com/

http://www.alexandre-pestana.com/disney-principled-brdf-implementation/

http://ruh.li/GraphicsCookTorrance.html

https://disney-animation.s3.amazonaws.com/library/s2012_pbs_disney_brdf_notes_v2.pdf

https://github.com/wdas/brdf/blob/master/src/brdfs/disney.brdf

http://www.rorydriscoll.com/2013/11/22/physically-based-shading/

And of course, thanks to eveyone who contributed to those guys project and inspirations...
