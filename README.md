# Cosmic-Rays-Generator
This program was created by PhD. Sergio Bonaque-Gonzalez, Optical Engineer.

sbonaque@wooptix.com    

www.linkedin.com/in/sergiobonaque

I am open to include any request or any contribution.


Files with pre-generated cosmic rays were obtained from a public repository, however I am unable to find it again and I therefore I can´t cite it. If you know the repository name, please let me know so I can include it here.

This program calculates the humber of cosmic rays hitting in a CCD and return the intensity image with random cosmic rays incorporates. The probability is calculated as a function of average number of cosmic rays per cm^2 and second, pixel size and exposition time. Density of cosmic rays is considered fixed in a quantity of 0.6/cm^2/15 seconds according to Kirk Gilmore. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SYNTAX: The function is called with the form:

result=cosmicRays_Bonaque(im,TamanoSensor,exposuretime,numero,pintar)

where 
INPUTS ARE:
  - im = Input image
  - TamanoSensor = Sensor size
  - exposuretime = exposure time
  - numero = This option places a minimum APROXIMATED fixed number of cosmic rays hitting the image. The more realistic situation for a serie of images is a minimum of 0. So, it is likely that there are no cosmic rays in most of the images.
  - pintar = Set to 1 if you want to draw results.
  
OUTPUT:
  - result: The input image with the cosmic rays incorporated. Probably, there will be no cosmic rays in your image if you use the real probability.
 
  
![My image1](/imgs/example1.jpg)   
![My image2](/imgs/example2.jpg)  
