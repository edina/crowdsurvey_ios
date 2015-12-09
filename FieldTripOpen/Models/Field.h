//
//  Field.h
//  FieldTripOpen
//
//  Created by Colin Gormley on 08/12/2015.
//  Copyright © 2015 Edina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "XLForm.h"
#import "XLFormViewController.h"

@protocol Field
@end

@interface Field : JSONModel

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * label;
@property (nonatomic) BOOL required;
@property (nonatomic) BOOL persistent;

@property (nonatomic, copy) NSMutableDictionary * properties;
-(void)appendToForm:(XLFormDescriptor *) form;

@end
