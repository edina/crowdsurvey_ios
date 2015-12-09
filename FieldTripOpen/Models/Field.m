//
//  Field.m
//  FieldTripOpen
//
//  Created by Colin Gormley on 08/12/2015.
//  Copyright © 2015 Edina. All rights reserved.
//

#import "Field.h"

@implementation Field

typedef enum{
    TEXT,
    RADIO,
    SELECT,
    DTREE,
    WARNING,
    RANGE,
    CHECKBOX,
} Type;


- (NSDictionary *)TypeEnumFromString{
    NSDictionary *typesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:TEXT], @"text",
                               [NSNumber numberWithInteger:RADIO], @"radio",
                               [NSNumber numberWithInteger:SELECT], @"select",
                               [NSNumber numberWithInteger:DTREE], @"dtree",
                               [NSNumber numberWithInteger:WARNING], @"warning",
                               [NSNumber numberWithInteger:RANGE], @"range",
                               [NSNumber numberWithInteger:CHECKBOX], @"checkbox",
                               nil
                               ];
    return typesDict;
}



- (NSString *)type
{
    
    Type myType = (Type)[[[self TypeEnumFromString] objectForKey:_type]intValue];
    
    switch(myType){
        case TEXT:
            NSLog(@"TEXT");
            break;
        case RADIO:
            NSLog(@"RADIO ");
            break;
        case SELECT:
            NSLog(@"SELECT ");
            break;
        case DTREE:
            NSLog(@"DTREE ");
            break;
        case WARNING:
            NSLog(@"WARNING ");
            break;
        case CHECKBOX:
            NSLog(@"CHECKBOX ");
            break;
        default:
            NSLog(@"default selected");
            break;
    }

    
    return _type;
}

@end
