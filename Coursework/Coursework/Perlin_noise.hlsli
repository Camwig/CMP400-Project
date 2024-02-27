

//////Return a noise value between 0 and 1
//////Instead of -1 & 1
////const double noise01(double x, double y);
////const double noise01(double x, double y, double z);
////const double noise(double x, double y);

////const double noise(double x, double y, double z);

////inline double fade(double t)
////{
////    return t * t * t * (t * (t * 6 - 15) + 10);
////} //Here is our nice easing/interpolation function
       
//inline double lerp(
//double t, double a, double b)
//{
//    return a + t * (b - a);
//} //This is a standard linear interpolation, where the "t" value is generated from the fade() function above

////inline double fadeDerivative(double t)
////{
////    return 30 * t * t * (t * (t - 2) + 1);
////}

////inline double lerpDerivative(
////double dt, double a, double b)
////{
////    return b * dt;
////} //Hmmmm

//const double grad(int hash, double x, double y, double z)
//{
//    /*int opening_time = (day == SUNDAY) ? 12 : 9;*/
    
//    //Both above and below or equal
    
//    /*int opening_time;

//    if (day == SUNDAY)
//        opening_time = 12;
//    else
//        opening_time = 9;
//    */
    
//    int h = hash & 15;
//    double u = h < 8 ? x : y;
//    double v = h < 4 ? y : h == 12 || h == 14 ? x : z;
//    return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
//}
        
////const double grad(int hash, double x, double y);
/////*
////    Permutation table.
////    This is a list of numbers from 0 to 255 that has been shuffled into a "random" order.
////    In the Initialisation we copy the whole thing into a second array
////    to make it a bit nicer when wrapping.
////    We could probably improve this by just having the full array of 512 defined here.
////*/
////const int p[512] =
////{
////    151, 160, 137, 91, 90, 15,
////            131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23,
////            190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33,
////            88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166,
////            77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244,
////            102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196,
////            135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123,
////            5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42,
////            223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
////            129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228,
////            251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107,
////            49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254,
////            138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180, 151,
////            160, 137, 91, 90, 15,
////            131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23,
////            190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33,
////            88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166,
////            77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244,
////            102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196,
////            135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123,
////            5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42,
////            223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
////            129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228,
////            251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107,
////            49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254,
////            138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180,
////};


//static int grad3[36] =
//{
//    { 1, 1, 0 },
//    { -1, 1, 0 },
//    { 1, -1, 0 },
//    { -1, -1, 0 },
//    { 1, 0, 1 },
//    { -1, 0, 1 },
//    { 1, 0, -1 },
//    { -1, 0, -1 },
//    { 0, 1, 1 },
//    { 0, -1, 1 },
//    { 0, 1, -1 },
//    { 0, -1, -1 }
//};

//const int p[512] =
//{
//    151, 160, 137, 91, 90, 15,
//            131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23,
//            190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33,
//            88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166,
//            77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244,
//            102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196,
//            135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123,
//            5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42,
//            223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
//            129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228,
//            251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107,
//            49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254,
//            138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180, 151,
//            160, 137, 91, 90, 15,
//            131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23,
//            190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33,
//            88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166,
//            77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244,
//            102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196,
//            135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123,
//            5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42,
//            223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
//            129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228,
//            251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107,
//            49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254,
//            138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180,
//};

////const int Init()
////{
////    for (int i = 0; i < 256; i++)
////    {
////        p[256 + i] = p[i];
////    }
////    return 1;
////}


//// To remove the need for index wrapping, double the permutation table length
////static int perm[512];
////static int init_perm()
////{
////    for (int i = 0; i < 512; i++)
////    {
////        perm[i] = p[i & 255];
////    }
////    return -1;
////}



//// This method is a *lot* faster than using (int)Math.floor(x)
////static int fastfloor(double x)
////{
////    return x > 0 ? (int) x : (int) x - 1;
////}

//static double dot3(int g[12], double x, double y, double z)
//{
//    return g[0] * x + g[1] * y + g[2] * z;
//}

//static double mix(double a, double b, double t)
//{
//    return (1 - t) * a + t * b;
//}

//static double fade(double t)
//{
//    return t * t * t * (t * (t * 6 - 15) + 10);
//}

//    // Classic Perlin noise, 3D version
//static double noise(double x, double y, double z)
//{
    
//    // Find unit grid cell containing point
//    int X = floor(x);
//    int Y = floor(y);
//    int Z = floor(z);
    
//    // Get relative xyz coordinates of point within that cell
//    x = x - X;
//    y = y - Y;
//    z = z - Z;
    
//    // Wrap the integer cells at 255 (smaller integer period can be introduced here)
//    X = X & 255;
//    Y = Y & 255;
//    Z = Z & 255;
    
//    // Compute the fade curve value for each of x, y, z
//    double u = fade(x);
//    double v = fade(y);
//    double w = fade(z);
 
////---------------------------------------------------------------------
    
    
//    int A = p[X] + Y, AA = p[A] + Z, AB = p[A + 1] + Z,
//        B = p[X + 1] + Y, BA = p[B] + Z, BB = p[B + 1] + Z;
    
//    return lerp(w, lerp(v, lerp(u, grad(p[AA], x, y, z), // AND ADD
//                                     grad(p[BA], x - 1, y, z)), // BLENDED
//                             lerp(u, grad(p[AB], x, y - 1, z), // RESULTS
//                                     grad(p[BB], x - 1, y - 1, z))), // FROM  8
//                     lerp(v, lerp(u, grad(p[AA + 1], x, y, z - 1), // CORNERS
//                                     grad(p[BA + 1], x - 1, y, z - 1)), // OF CUBE
//                             lerp(u, grad(p[AB + 1], x, y - 1, z - 1),
//                                     grad(p[BB + 1], x - 1, y - 1, z - 1))));
    
    
//    //return lerp(w, lerp(v, lerp(u, grad(p[AA], x, y, z), grad(p[BA], x - 1, y, z)),lerp(u, grad(p[AB], x, y - 1, z), grad(p[BB], x - 1, y - 1, z))),lerp(v, lerp(u, grad(p[AA + 1], x, y, z - 1), grad(p[BA + 1], x - 1, y, z - 1)),lerp(u, grad(p[AB + 1], x, y - 1, z - 1), grad(p[BB + 1], x - 1, y - 1, z - 1))));
    
//    //double Result1 = lerp(w, lerp(u, grad(p[AA], x, y, z)));

//}

///*

//    // Classic Perlin noise, 3D version
//static double noise(double x, double y, double z)
//{
    
//    // Find unit grid cell containing point
//    int X = floor(x);
//    int Y = floor(y);
//    int Z = floor(z);
    
//    // Get relative xyz coordinates of point within that cell
//    x = x - X;
//    y = y - Y;
//    z = z - Z;
    
//    // Wrap the integer cells at 255 (smaller integer period can be introduced here)
//    X = X & 255;
//    Y = Y & 255;
//    Z = Z & 255;
    
//    // Calculate a set of eight hashed gradient indices
//    int gi000 = p[X + p[Y + p[Z]]] % 12;
//    int gi001 = p[X + p[Y + p[Z + 1]]] % 12;
//    int gi010 = p[X + p[Y + 1 + p[Z]]] % 12;
//    int gi011 = p[X + p[Y + 1 + p[Z + 1]]] % 12;
//    int gi100 = p[X + 1 + p[Y + p[Z]]] % 12;
//    int gi101 = p[X + 1 + p[Y + p[Z + 1]]] % 12;
//    int gi110 = p[X + 1 + p[Y + 1 + p[Z]]] % 12;
//    int gi111 = p[X + 1 + p[Y + 1 + p[Z + 1]]] % 12;
    
//    // The gradients of each corner are now:
//    //g000 = grad3[gi000];
//    //g001 = grad3[gi001];
//    //g010 = grad3[gi010];
//    //g011 = grad3[gi011];
//    //g100 = grad3[gi100];
//    //g101 = grad3[gi101];
//    //g110 = grad3[gi110];
//    //g111 = grad3[gi111];
    
//    // Calculate noise contributions from each of the eight corners
//    double n000 = dot3(grad3[gi000], x, y, z);
//    double n100 = dot3(grad3[gi100], x - 1, y, z);
//    double n010 = dot3(grad3[gi010], x, y - 1, z);
//    double n110 = dot3(grad3[gi110], x - 1, y - 1, z);
//    double n001 = dot3(grad3[gi001], x, y, z - 1);
//    double n101 = dot3(grad3[gi101], x - 1, y, z - 1);
//    double n011 = dot3(grad3[gi011], x, y - 1, z - 1);
//    double n111 = dot3(grad3[gi111], x - 1, y - 1, z - 1);
    
//    // Compute the fade curve value for each of x, y, z
//    double u = fade(x);
//    double v = fade(y);
//    double w = fade(z);
    
//    // Interpolate along x the contributions from each of the corners
//    double nx00 = mix(n000, n100, u);
//    double nx01 = mix(n001, n101, u);
//    double nx10 = mix(n010, n110, u);
//    double nx11 = mix(n011, n111, u);
    
//    // Interpolate the four results along y
//    double nxy0 = mix(nx00, nx10, v);
//    double nxy1 = mix(nx01, nx11, v);
    
//    // Interpolate the two last results along z
//    double nxyz = mix(nxy0, nxy1, w);
//    return (nxyz * 10);

//}

//*/






////
//// GLSL textureless classic 2D noise "cnoise",
//// with an RSL-style periodic variant "pnoise".
//// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
//// Version: 2011-08-22
////
//// Many thanks to Ian McEwan of Ashima Arts for the
//// ideas for permutation and gradient selection.
////
//// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
//// Distributed under the MIT license. See LICENSE file.
//// https://github.com/stegu/webgl-noise
////

//float4 mod(float4 x,float4 y)
//{
//    // x - y * floor(x/y)
//    return (x - y) * floor(x / y);
//}

//static float2 mix(float2 a, float2 b, float2 t)
//{
//    return (1 - t) * a + t * b;
//}

//float4 mod289(float4 x)
//{
//    return x - floor(x * (1.0 / 289.0)) * 289.0;
//}

//float4 permute(float4 x)
//{
//    return mod289(((x * 34.0) + 10.0) * x);
//}

//float4 taylorInvSqrt(float4 r)
//{
//    return 1.79284291400159 - 0.85373472095314 * r;
//}

//float2 fade(float2 t)
//{
//    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
//}

//// Classic Perlin noise
//float cnoise(float2 P)
//{
//    float4 Pi = floor(P.xyxy) + float4(0.0, 0.0, 1.0, 1.0);
//    float4 Pf = frac(P.xyxy) - float4(0.0, 0.0, 1.0, 1.0);
//    Pi = mod289(Pi); // To avoid truncation effects in permutation
//    float4 ix = Pi.xzxz;
//    float4 iy = Pi.yyww;
//    float4 fx = Pf.xzxz;
//    float4 fy = Pf.yyww;

//    float4 i = permute(permute(ix) + iy);

//    float4 gx = frac(i * (1.0 / 41.0)) * 2.0 - 1.0;
//    float4 gy = abs(gx) - 0.5;
//    float4 tx = floor(gx + 0.5);
//    gx = gx - tx;

//    float2 g00 = float2(gx.x, gy.x);
//    float2 g10 = float2(gx.y, gy.y);
//    float2 g01 = float2(gx.z, gy.z);
//    float2 g11 = float2(gx.w, gy.w);

//    float4 norm = taylorInvSqrt(float4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
//    g00 *= norm.x;
//    g01 *= norm.y;
//    g10 *= norm.z;
//    g11 *= norm.w;

//    float n00 = dot(g00, float2(fx.x, fy.x));
//    float n10 = dot(g10, float2(fx.y, fy.y));
//    float n01 = dot(g01, float2(fx.z, fy.z));
//    float n11 = dot(g11, float2(fx.w, fy.w));

//    float2 fade_xy = fade(Pf.xy);
//    float2 n_x = mix(float2(n00, n01), float2(n10, n11), fade_xy.x);
//    float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
//    return 2.3 * n_xy;
//}

//// Classic Perlin noise, periodic variant
//float pnoise(float2 P, float2 rep)
//{
//    float4 Pi = floor(P.xyxy) + float4(0.0, 0.0, 1.0, 1.0);
//    float4 Pf = frac(P.xyxy) - float4(0.0, 0.0, 1.0, 1.0);
//    Pi = mod(Pi, rep.xyxy); // To create noise with explicit period
//    Pi = mod289(Pi); // To avoid truncation effects in permutation
//    float4 ix = Pi.xzxz;
//    float4 iy = Pi.yyww;
//    float4 fx = Pf.xzxz;
//    float4 fy = Pf.yyww;

//    float4 i = permute(permute(ix) + iy);

//    float4 gx = frac(i * (1.0 / 41.0)) * 2.0 - 1.0;
//    float4 gy = abs(gx) - 0.5;
//    float4 tx = floor(gx + 0.5);
//    gx = gx - tx;

//    float2 g00 = float2(gx.x, gy.x);
//    float2 g10 = float2(gx.y, gy.y);
//    float2 g01 = float2(gx.z, gy.z);
//    float2 g11 = float2(gx.w, gy.w);

//    float4 norm = taylorInvSqrt(float4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
//    g00 *= norm.x;
//    g01 *= norm.y;
//    g10 *= norm.z;
//    g11 *= norm.w;

//    float n00 = dot(g00, float2(fx.x, fy.x));
//    float n10 = dot(g10, float2(fx.y, fy.y));
//    float n01 = dot(g01, float2(fx.z, fy.z));
//    float n11 = dot(g11, float2(fx.w, fy.w));

//    float2 fade_xy = fade(Pf.xy);
//    float2 n_x = mix(float2(n00, n01), float2(n10, n11), fade_xy.x);
//    float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
//    return 2.3 * n_xy;
//}

//// demo code:
//float color(float2 xy)
//{
//    return cnoise(15 * xy);
//}





//
// GLSL textureless classic 3D noise "cnoise",
// with an RSL-style periodic variant "pnoise".
// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
// Version: 2011-10-11
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/stegu/webgl-noise
//

float4 mod(float4 x, float4 y)
{
    // x - y * floor(x/y)
    return (x - y) * floor(x / y);
}

float3 mod(float3 x, float3 y)
{
    // x - y * floor(x/y)
    return (x - y) * floor(x / y);
}

float mix2(float3 a, float3 b, float3 t)
{
    return (1 - t) * a + t * b;
}

float2 mix(float2 a, float2 b, float2 t)
{
    return (1 - t) * a + t * b;
}

float4 mix(float4 a, float4 b, float4 t)
{
    return (1 - t) * a + t * b;
}

float3 mod289(float3 x)
{
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

float4 mod289(float4 x)
{
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

float4 permute(float4 x)
{
    return mod289(((x * 34.0) + 10.0) * x);
}

float4 taylorInvSqrt(float4 r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}

float3 fade(float3 t)
{
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

// Classic Perlin noise
float cnoise(float3 P)
{
    float3 Pi0 = floor(P); // Integer part for indexing
    float3 Pi1 = Pi0 + float3(1.0, 1.0, 1.0); // Integer part + 1
    Pi0 = mod289(Pi0);
    Pi1 = mod289(Pi1);
    float3 Pf0 = frac(P); // Fractional part for interpolation
    float3 Pf1 = Pf0 - float3(1.0, 1.0, 1.0); // Fractional part - 1.0
    float4 ix = float4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
    float4 iy = float4(Pi0.yy, Pi1.yy);
    float4 iz0 = Pi0.zzzz;
    float4 iz1 = Pi1.zzzz;

    float4 ixy = permute(permute(ix) + iy);
    float4 ixy0 = permute(ixy + iz0);
    float4 ixy1 = permute(ixy + iz1);

    float4 gx0 = ixy0 * (1.0 / 7.0);
    float4 gy0 = frac(floor(gx0) * (1.0 / 7.0)) - 0.5;
    gx0 = frac(gx0);
    float4 gz0 = float4(0.5, 0.5, 0.5, 0.5) - abs(gx0) - abs(gy0);
    float4 sz0 = step(gz0, float4(0.0, 0.0, 0.0, 0.0));
    gx0 -= sz0 * (step(0.0, gx0) - 0.5);
    gy0 -= sz0 * (step(0.0, gy0) - 0.5);

    float4 gx1 = ixy1 * (1.0 / 7.0);
    float4 gy1 = frac(floor(gx1) * (1.0 / 7.0)) - 0.5;
    gx1 = frac(gx1);
    float4 gz1 = float4(0.5, 0.5, 0.5, 0.5) - abs(gx1) - abs(gy1);
    float4 sz1 = step(gz1, float4(0.0, 0.0, 0.0, 0.0));
    gx1 -= sz1 * (step(0.0, gx1) - 0.5);
    gy1 -= sz1 * (step(0.0, gy1) - 0.5);

    float3 g000 = float3(gx0.x, gy0.x, gz0.x);
    float3 g100 = float3(gx0.y, gy0.y, gz0.y);
    float3 g010 = float3(gx0.z, gy0.z, gz0.z);
    float3 g110 = float3(gx0.w, gy0.w, gz0.w);
    float3 g001 = float3(gx1.x, gy1.x, gz1.x);
    float3 g101 = float3(gx1.y, gy1.y, gz1.y);
    float3 g011 = float3(gx1.z, gy1.z, gz1.z);
    float3 g111 = float3(gx1.w, gy1.w, gz1.w);

    float4 norm0 = taylorInvSqrt(float4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
    g000 *= norm0.x;
    g010 *= norm0.y;
    g100 *= norm0.z;
    g110 *= norm0.w;
    float4 norm1 = taylorInvSqrt(float4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
    g001 *= norm1.x;
    g011 *= norm1.y;
    g101 *= norm1.z;
    g111 *= norm1.w;

    float n000 = dot(g000, Pf0);
    float n100 = dot(g100, float3(Pf1.x, Pf0.yz));
    float n010 = dot(g010, float3(Pf0.x, Pf1.y, Pf0.z));
    float n110 = dot(g110, float3(Pf1.xy, Pf0.z));
    float n001 = dot(g001, float3(Pf0.xy, Pf1.z));
    float n101 = dot(g101, float3(Pf1.x, Pf0.y, Pf1.z));
    float n011 = dot(g011, float3(Pf0.x, Pf1.yz));
    float n111 = dot(g111, Pf1);

    float3 fade_xyz = fade(Pf0);
    float4 n_z = mix(float4(n000, n100, n010, n110), float4(n001, n101, n011, n111), fade_xyz.z);
    float2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
    float n_xyz = mix2(n_yz.x, n_yz.y, fade_xyz.x);
    return 2.2 * n_xyz;
}

//// Classic Perlin noise, periodic variant
//float pnoise(float3 P, float3 rep)
//{
//    float3 Pi0 = mod(floor(P), rep); // Integer part, modulo period
//    float3 Pi1 = mod(Pi0 + float3(1.0), rep); // Integer part + 1, mod period
//    Pi0 = mod289(Pi0);
//    Pi1 = mod289(Pi1);
//    float3 Pf0 = frac(P); // Fractional part for interpolation
//    float3 Pf1 = Pf0 - float3(1.0); // Fractional part - 1.0
//    float4 ix = float4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
//    float4 iy = float4(Pi0.yy, Pi1.yy);
//    float4 iz0 = Pi0.zzzz;
//    float4 iz1 = Pi1.zzzz;

//    float4 ixy = permute(permute(ix) + iy);
//    float4 ixy0 = permute(ixy + iz0);
//    float4 ixy1 = permute(ixy + iz1);

//    float4 gx0 = ixy0 * (1.0 / 7.0);
//    float4 gy0 = frac(floor(gx0) * (1.0 / 7.0)) - 0.5;
//    gx0 = frac(gx0);
//    float4 gz0 = float4(0.5) - abs(gx0) - abs(gy0);
//    float4 sz0 = step(gz0, float4(0.0));
//    gx0 -= sz0 * (step(0.0, gx0) - 0.5);
//    gy0 -= sz0 * (step(0.0, gy0) - 0.5);

//    float4 gx1 = ixy1 * (1.0 / 7.0);
//    float4 gy1 = frac(floor(gx1) * (1.0 / 7.0)) - 0.5;
//    gx1 = frac(gx1);
//    float4 gz1 = float4(0.5) - abs(gx1) - abs(gy1);
//    float4 sz1 = step(gz1, float4(0.0));
//    gx1 -= sz1 * (step(0.0, gx1) - 0.5);
//    gy1 -= sz1 * (step(0.0, gy1) - 0.5);

//    float3 g000 = float3(gx0.x, gy0.x, gz0.x);
//    float3 g100 = float3(gx0.y, gy0.y, gz0.y);
//    float3 g010 = float3(gx0.z, gy0.z, gz0.z);
//    float3 g110 = float3(gx0.w, gy0.w, gz0.w);
//    float3 g001 = float3(gx1.x, gy1.x, gz1.x);
//    float3 g101 = float3(gx1.y, gy1.y, gz1.y);
//    float3 g011 = float3(gx1.z, gy1.z, gz1.z);
//    float3 g111 = float3(gx1.w, gy1.w, gz1.w);

//    float4 norm0 = taylorInvSqrt(float4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
//    g000 *= norm0.x;
//    g010 *= norm0.y;
//    g100 *= norm0.z;
//    g110 *= norm0.w;
//    float4 norm1 = taylorInvSqrt(float4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
//    g001 *= norm1.x;
//    g011 *= norm1.y;
//    g101 *= norm1.z;
//    g111 *= norm1.w;

//    float n000 = dot(g000, Pf0);
//    float n100 = dot(g100, float3(Pf1.x, Pf0.yz));
//    float n010 = dot(g010, float3(Pf0.x, Pf1.y, Pf0.z));
//    float n110 = dot(g110, float3(Pf1.xy, Pf0.z));
//    float n001 = dot(g001, float3(Pf0.xy, Pf1.z));
//    float n101 = dot(g101, float3(Pf1.x, Pf0.y, Pf1.z));
//    float n011 = dot(g011, float3(Pf0.x, Pf1.yz));
//    float n111 = dot(g111, Pf1);

//    float3 fade_xyz = fade(Pf0);
//    float4 n_z = mix(float4(n000, n100, n010, n110), float4(n001, n101, n011, n111), fade_xyz.z);
//    float2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
//    float n_xyz = mix(n_yz.x, n_yz.y, fade_xyz.x);
//    return 2.2 * n_xyz;
//}

// demo code:
float color(float3 xyz)
{
    return cnoise(10.5 * xyz);
}
//void mainImage(out vec4 fragColor, in vec2 fragCoord)
//{
//    vec2 p = (fragCoord.xy / iResolution.y) * 2.0 - 1.0;

//    float z_squared = 1.0 - length(p.xy);
//    if (z_squared < 0.0)
//    {
//        fragColor = vec4(0, 0, 0, 1);
//        return;
//    }
//    vec3 xyz = vec3(p, -sqrt(z_squared));

//    float n = color(xyz * 4.0);

//    fragColor.xyz = mix(0.0, 0.5 + 0.5 * n, smoothstep(0.0, 0.003, z_squared)) * vec3(1, 1, 1);

//}
