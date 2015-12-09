//
//  Survey.h
//  FieldTripOpen
//
//  Created by Colin Gormley on 08/12/2015.
//  Copyright © 2015 Edina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Field.h"
#import "XLFormDescriptor.h"

@interface Survey : NSObject
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSArray * geoms;
@property (nonatomic, copy) NSArray * fields;

@property (nonatomic, copy) NSString * fieldId;

//@property (nonatomic, copy) XLFormDescriptor * form;

-(XLFormDescriptor *)form;

@end
