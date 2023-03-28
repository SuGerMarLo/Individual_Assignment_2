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
