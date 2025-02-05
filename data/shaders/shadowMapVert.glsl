uniform mat4 transform;
uniform mat4 modelview;
uniform mat3 normalMatrix;
uniform mat4 shadowTransform0;
uniform mat4 shadowTransform1;
uniform mat4 shadowTransform2;
uniform mat4 shadowTransform3;
uniform vec3 lightDirection;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;
varying vec4 shadowCoord0;
varying vec4 shadowCoord1;
varying vec4 shadowCoord2;
varying vec4 shadowCoord3;
varying float lightIntensity;

void main() {
   vertColor = color;
   vec4 vertPosition = modelview * vertex; // Get vertex position in model view space
   vec3 vertNormal = normalize(normalMatrix * normal); // Get normal direction in model view space
   shadowCoord0 = shadowTransform0 * (vertPosition + vec4(vertNormal, 0.0)); // Normal bias removes the shadow acne
   shadowCoord1 = shadowTransform1 * (vertPosition + vec4(vertNormal, 0.0)); // Normal bias removes the shadow acne
   shadowCoord2 = shadowTransform2 * (vertPosition + vec4(vertNormal, 0.0)); // Normal bias removes the shadow acne
   shadowCoord3 = shadowTransform3 * (vertPosition + vec4(vertNormal, 0.0)); // Normal bias removes the shadow acne
   lightIntensity = 0.5 + dot(-lightDirection, vertNormal) * 0.5;
   gl_Position = transform * vertex;
   
}