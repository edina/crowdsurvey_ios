//
//  Survey.m
//  FieldTripOpen
//
//  Created by Colin Gormley on 08/12/2015.
//  Copyright © 2015 Edina. All rights reserved.
//

#import "Survey.h"
#import "XLFormDescriptor.h"

@implementation Survey


- (instancetype)init
{
    self = [super init];
    if (self) {
        // set up form instance
        [self setUpXLForm];
    }
    return self;
}

-(void)setUpXLForm{
    self.form = [XLFormDescriptor formDescriptorWithTitle: self.title];
    
//    XLFormSectionDescriptor * section;
//    XLFormRowDescriptor * row;
}

-(XLFormDescriptor *)XLForm{
    // return the xlform for rendering
    return self.form;
}

@end
