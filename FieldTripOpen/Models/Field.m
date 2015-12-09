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


-(void)appendToForm:(XLFormDescriptor *) form{
    Type myType = (Type)[[[self TypeEnumFromString] objectForKey:self.type]intValue];

    switch(myType){
        case TEXT:
            
            [self appendTextFormElementToForm:form];
            
            break;
        case RADIO:
            
            [self appendRadioFormElementToForm:form];
            
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

-(void)appendTextFormElementToForm:(XLFormDescriptor * )form{
    
    XLFormRowDescriptor * row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Title" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:self.label forKey:@"textField.placeholder"];
    row.required = YES;
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSection];
    [section addFormRow:row];
    [form addFormSection:section];
}

-(void)appendRadioFormElementToForm:(XLFormDescriptor * )form{
    
    XLFormRowDescriptor* hobbyRow = [XLFormRowDescriptor formRowDescriptorWithTag:self.label
                                                                          rowType:XLFormRowDescriptorTypeMultipleSelector
                                                                            title:self.label];
    hobbyRow.selectorOptions = @[@"Sport", @"Music", @"Films"];
    hobbyRow.value = @[];
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSection];
    [section addFormRow:hobbyRow];
    
   
    [form addFormSection:section];
}

@end
