//
//  TextField.m
//  FieldTripOpen
//
//  Created by Colin Gormley on 08/12/2015.
//  Copyright © 2015 Edina. All rights reserved.
//

#import "TextField.h"

@implementation TextField


- (NSMutableDictionary *)properties
{
    if (!self.properties){
        self.properties = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           self.prefix, @"prefix", self.placeHolder, @"placeholder", self.maxChars, @"max-chars", nil];
    }
    return self.properties;
}

@end
