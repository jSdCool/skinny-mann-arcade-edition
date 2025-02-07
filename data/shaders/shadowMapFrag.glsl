// Used a bigger poisson disk kernel than in the tutorial to get smoother results
const vec2 poissonDisk[9] = vec2[] (
   vec2(0.95581, -0.18159), vec2(0.50147, -0.35807), vec2(0.69607, 0.35559),
   vec2(-0.0036825, -0.59150), vec2(0.15930, 0.089750), vec2(-0.65031, 0.058189),
   vec2(0.11915, 0.78449), vec2(-0.34296, 0.51575), vec2(-0.60380, -0.41527)
);

// Unpack the 16bit depth float from the first two 8bit channels of the rgba vector
float unpackDepth(vec4 color) {
   return color.r + color.g / 255.0;
}

//apperently samplers can only be uniforms and processing cant set an array of sampers so we have to do this the hard way
uniform sampler2D shadowMap0;
uniform sampler2D shadowMap1;
uniform sampler2D shadowMap2;
uniform sampler2D shadowMap3;
uniform bool outputSampledValue;

varying vec4 vertColor;
varying vec4 shadowCoord0;
varying vec4 shadowCoord1;
varying vec4 shadowCoord2;
varying vec4 shadowCoord3;
varying float lightIntensity;

void main(void) {

   // Project shadow coords, needed for a perspective light matrix (spotlight)
   vec3 shadowCoordProj[4];
   shadowCoordProj[0] = shadowCoord0.xyz / shadowCoord0.w;
   shadowCoordProj[1] = shadowCoord1.xyz / shadowCoord1.w;
   shadowCoordProj[2] = shadowCoord2.xyz / shadowCoord2.w;
   shadowCoordProj[3] = shadowCoord3.xyz / shadowCoord3.w;

	
   // Only render shadow if fragment is facing the light
   if(lightIntensity > 0.5) {
       float visibility = 9.0;
	   //for each one of the edge points, increase the brightness if not in shaddow
	   //start the brightness at 50%
	   
	   //find the correct texture to sample
	   //in theory the point should be valid in only 1 location at a time 
	   int textureSection = 0;
	   
	   textureSection += int(min(1,int(!(shadowCoordProj[1].x >= 1 || shadowCoordProj[1].y >= 1 || shadowCoordProj[1].x < 0 || shadowCoordProj[1].y < 0)))) * 1;
	   textureSection += int(min(1,int(!(shadowCoordProj[2].x >= 1 || shadowCoordProj[2].y >= 1 || shadowCoordProj[2].x < 0 || shadowCoordProj[2].y < 0)))) * 2;
	   textureSection += int(min(1,int(!(shadowCoordProj[3].x >= 1 || shadowCoordProj[3].y >= 1 || shadowCoordProj[3].x < 0 || shadowCoordProj[3].y < 0)))) * 3;
	   //just in case it hit more then 1 point we will limit the max value
	   
       
	   //if more preformace is nessarry then comment this out
	   if(outputSampledValue){
	     vec4 res = texture2D(shadowMap0, shadowCoordProj[textureSection].xy) * int(textureSection == 0);
		 res += texture2D(shadowMap1, shadowCoordProj[textureSection].xy) * int(textureSection == 1);
		 res += texture2D(shadowMap2, shadowCoordProj[textureSection].xy) * int(textureSection == 2);
		 res += texture2D(shadowMap3, shadowCoordProj[textureSection].xy) * int(textureSection == 3);
		 gl_FragColor = res;
		 return;
	   }
	   
	   textureSection = int(min(3,textureSection));
	   
	   int n = 0;
	   //check if the mapped UV cord is outside of the texture without using branching 
	   n += int(min(1,int(shadowCoordProj[textureSection].x >= 1)+int(shadowCoordProj[textureSection].y >= 1)+int(shadowCoordProj[textureSection].x <= 0)+int(shadowCoordProj[textureSection].y <= 0)))*9;
	   //if n is 9 then make visibility imediatly max as we are skipping the for loop
	   visibility += n;
	   //this makes anything outside of the area renderd in the depth buffer automotiacly not in shadow
	   
	   // I used step() instead of branching, should be much faster this way
       for(; n < 9; ++n){
           visibility += step(shadowCoordProj[0].z, unpackDepth(texture2D(shadowMap0, shadowCoordProj[0].xy + poissonDisk[n] / 512.0))) * int(textureSection == 0)//edge dithering
		   + step(shadowCoordProj[1].z, unpackDepth(texture2D(shadowMap1, shadowCoordProj[1].xy + poissonDisk[n] / 512.0))) * int(textureSection == 1)
		   + step(shadowCoordProj[2].z, unpackDepth(texture2D(shadowMap2, shadowCoordProj[2].xy + poissonDisk[n] / 512.0))) * int(textureSection == 2)
		   + step(shadowCoordProj[3].z, unpackDepth(texture2D(shadowMap3, shadowCoordProj[3].xy + poissonDisk[n] / 512.0))) * int(textureSection == 3);
	   }
       gl_FragColor = vec4(vertColor.rgb * min(visibility * 0.05556, lightIntensity), vertColor.a);
   } else
       gl_FragColor = vec4(vertColor.rgb * lightIntensity, vertColor.a);

}