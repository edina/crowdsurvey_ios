//
//  Field.m
//  FieldTripOpen
//
//  Created by Colin Gormley on 08/12/2015.
//  Copyright © 2015 Edina. All rights reserved.
//

#import "Field.h"
#import "XLForm.h"
#import "XLFormViewController.h"

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


-(void)appendFormElement{
    Type myType = (Type)[[[self TypeEnumFromString] objectForKey:self.type]intValue];

    switch(myType){
        case TEXT:
            
            [self appendTextFormElement];
            
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
}

-(void)appendTextFormElement{
    XLFormRowDescriptor * row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Title" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Title" forKey:@"textField.placeholder"];
    row.required = YES;
}

@end
