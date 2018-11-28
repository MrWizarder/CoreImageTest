//
//  CubeMap.h
//  ComplexFilter
//
//  Created by Wang Liu on 2018/11/28.
//  Copyright © 2018 Wang Liu. All rights reserved.
//

#ifndef CubeMap_h
#define CubeMap_h

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

struct CubeMap {
    int length;
    float dimension;
    float *data;
};

struct CubeMap createCubeMap(float minHueAngle, float maxHueAngle);

#endif /* CubeMap_h */
