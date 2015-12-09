//
//  Field.h
//  FieldTripOpen
//
//  Created by Colin Gormley on 08/12/2015.
//  Copyright © 2015 Edina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLForm.h"
#import "XLFormViewController.h"

@interface Field : NSObject

@property (nonatomic, copy) NSString * fieldId;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * label;
@property (nonatomic) bool  required;
@property (nonatomic, copy) NSString * persistent;

@property (nonatomic, copy) NSMutableDictionary * properties;
-(void)appendToForm:(XLFormDescriptor *) form;

@end
