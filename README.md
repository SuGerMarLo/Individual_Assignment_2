# Individual_Assignment_2
 
## Forward vs. Deferred Rendering


Forward rendering consists of rendering an object x amount of times, where x is the number of lights that hit it. For example, if we needed to calculate the color, depth and normal lighting of a few objects, forward rendering will apply color to the object and render it, depth and re-render it, and finally the normals and re-render it again. This process is linear and consumes more gpu power than for the deferred rendering.

Deferred rendering uses parallel processes by calculating all of the different lights on separate buffers by using multiple passes, then combining them during the final render. Let’s go back to the color, depth and normal lighting example. In this case, the color would be on one pass. Then, on the same shader, a second pass for the depth and a third one for the normals would be created. The object would then only need to be rendered once, saving a significant amount of gpu power.


![FR](https://user-images.githubusercontent.com/116387786/228300638-83feaad4-c475-4930-9c37-fae755548200.png)

The objects would go through the vertex and geometry shaders, then go through the fragment shader, where the lighting will also be implemented on the object. However, for each of these 3 processes, the object will need to re-render due to having new lighting applied to it.

![DR](https://user-images.githubusercontent.com/116387786/228300634-d9077cd3-ba64-4973-ba19-21b4adfe8aa5.png)

Same as for Forward rendering, the objects will go through the vertex and geometry shaders, but then will pass through a fragment shader that doesn’t apply lighting to it. Instead, it will go through another step that applies all the passes to the objects as one collective light source (for lack of a better term). It will then only render once as opposed to (light number) amount of time.

Flowchart:

![Flow](https://user-images.githubusercontent.com/116387786/228305080-897c7f74-066e-4c79-bd26-978b6a6de686.png)


## Toon Square Wave Shader

The below background image was taken from: https://www.pinterest.com/spencer2246/pixel-art-topdown/

![471d570cfe8646ce81b99ddd1baec08a](https://user-images.githubusercontent.com/116387786/228314311-aeadf945-2ff5-481a-9aa1-b74253511cb7.jpg)


![Toon_Wave](https://user-images.githubusercontent.com/116387786/228310395-8e0a3c79-f3bc-4e9a-9dec-7aaaf7374d9d.png)

The wave code is the same as the one in the lecture, however I changed a calculation to make the waves more square.
Under the `			float waveHeight = sin(t + v.vertex.x * _Freq) * _Amp + sin(t * 2 + v.vertex.x * _Freq * 2) * _Amp;` line I added the following code:

![Wave Code](https://user-images.githubusercontent.com/116387786/228311803-6bffe29d-e097-4660-baf5-9a11e7483da8.png)

This forces the wave to stick to either a value of 1, 0 or -1 depending on the current sin value, essentially clamping it to one of those 3 values.

For the toon shding component I added the essential components from the lecture's toon shader into the wave shader like the _RampTex, defined the _RampTex, LightingToonRamp method, and I multiplied the wave's current albedo with the wave's _Tint for the toon shader to have a color as well.

![Toon](https://user-images.githubusercontent.com/116387786/228313044-0f336e41-376c-4854-98b7-c5a722f9a7c2.png)

^^^ LightingToonRamp method


I then added the background on a plane above and a moving cube (with WASD) to act as a ship by using the old input system and clamping it to stop it from going on land.

![Moving Ship](https://user-images.githubusercontent.com/116387786/228319872-c305e173-97ef-45b4-83bf-56622b26bd71.png)


## Code Explanation 1

[Blur.pdf](https://github.com/SuGerMarLo/Individual_Assignment_2/files/11105245/Blur.pdf)


## Bump Map and Outline Shader (Second Shader Task)

I added a bump map shader onto the background plane to give the scene a bit more depth. The code was the same as the one from the lecture, however, I decided to add a color variable to allow it to change to a "night" theme.

![Bump Map](https://user-images.githubusercontent.com/116387786/228673239-72d0cfa6-47a0-4add-9684-8a261803a500.png)

![Bump Map Code](https://user-images.githubusercontent.com/116387786/228674730-4a031f28-3ad1-4826-a365-7ef4b202763a.png)

I added the color property as well as defined the variable, then simply multiplied the albedo value by it.

I didn't change much simply because I had no real idea what to change aside from this.

The second thing I added was an outline shader. Again, the shader was from the lecture, however I changed to major things in this one to compensate for the minor change in the other shader.

![Outline](https://user-images.githubusercontent.com/116387786/228674759-9c3ac957-3cef-49e4-a996-98cd0daa83fa.png)

![Outline Code](https://user-images.githubusercontent.com/116387786/228673782-be75e235-5ed0-4a9e-86cb-6c25f45635c0.png)

1. (The first line) I made it so that the position/offset of the outline would change based off of its color. If the outline is white, it will be to the right, if it's black, it will be to the left; the rest of the colors all have different positions, not limited to only one hue. The numbers in the code are only meant to centralize it since without those it would only move in the positives.
2. (The second line) I made it so that the color would change based on the object's position. To the left would be black, the right would be white and the middle would be whatever color you chose at the time.

## Code Explanation 2

[Shadow.pdf](https://github.com/SuGerMarLo/Individual_Assignment_2/files/11106019/Shadow.pdf)

## Chosen Shader Explanation

I chose the vertex extrusion shader, which I'm surprised I haven't explained yet.

![Extrusion](https://user-images.githubusercontent.com/116387786/228681591-5146be23-019e-4ef2-ada1-56d02bfefae5.png)

The code is actualy surprisingly simple.

You start off with the basic things like your _MainTex in the properties as well as setting your albedo color in the surface shader (you find these in most shaders).

Next, you create an extrusion amount property called "_Amount" and define it too.

Finally, you create a vertex shader function and, to each of the object's vertices (v.vertex.xyz), add it's normal value (v.normal) multiplied by whatever extrusion amount desires (_Amount).

![Extrusion Diagram](https://user-images.githubusercontent.com/116387786/228684099-eb8acd51-c838-4fff-99b1-601fca8b5935.png)

While this may a funny example, the concept still applies. Some things in games (like a ball or a balloon) expand; this shader can make iit easier to replicate that effect.

Another example of this could be for sheep. Since animals like sheep require shearing, we can use the vertex extrusion shader to show when a sheep is slowly gaining more and more wool.
