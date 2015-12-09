//
//  Survey.h
//  FieldTripOpen
//
//  Created by Colin Gormley on 08/12/2015.
//  Copyright © 2015 Edina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Field.h"
#import "JSONModel.h"
#import "XLFormDescriptor.h"

@interface Survey : JSONModel

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSArray * geoms;
@property (nonatomic, copy) NSArray<Field> * fields;

@property (nonatomic, copy) NSString<Ignore> * fieldId;

@property (nonatomic, copy) XLFormDescriptor<Ignore> * form;

-(XLFormDescriptor *)form;

@end
