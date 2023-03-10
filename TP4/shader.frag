#version 330 core

// Variable de sortie (sera utilisé comme couleur)
out vec4 color;
uniform vec4 couleur;

//Un Fragment Shader minimaliste
void main (void)
{
//Couleur du fragment
float x=gl_FragCoord.x/800.0 - 0.5;
float y=gl_FragCoord.y/800.0 - 0.5;
if(x*x + y*y > 0.25*0.25)
color = couleur;
else
color = vec4(1.0,0.0,0.0,1.0);
}
