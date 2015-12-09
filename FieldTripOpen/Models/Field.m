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
            
            [self appendCheckBoxFormElementToForm:form];
            
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
    
    // Add to last section
    NSMutableArray *sections = [form formSections];
    XLFormSectionDescriptor *section = [sections lastObject];
    [section addFormRow:row];

}

-(void)appendRadioFormElementToForm:(XLFormDescriptor * )form{
    
    XLFormRowDescriptor* selectorRow = [XLFormRowDescriptor formRowDescriptorWithTag:self.label
                                                                          rowType:XLFormRowDescriptorTypeMultipleSelector
                                                                            title:self.label];
 
    selectorRow.selectorOptions = [self.properties valueForKey:@"options"];
    selectorRow.value = @[];
    
    // Add to last section
    NSMutableArray *sections = [form formSections];
    XLFormSectionDescriptor *section = [sections lastObject];
    [section addFormRow:selectorRow];
    
}

-(void)appendCheckBoxFormElementToForm:(XLFormDescriptor * )form{

    NSMutableArray *sections = [form formSections];
    XLFormSectionDescriptor *section = [sections lastObject];
    [section addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:@"" rowType:XLFormRowDescriptorTypeBooleanCheck title:self.label]];
}

@end
