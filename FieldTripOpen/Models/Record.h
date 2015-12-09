//
//  Record.h
//  FieldTripOpen
//
//  Created by Colin Gormley on 09/12/2015.
//  Copyright © 2015 Edina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSDictionary * geometry;
@property (nonatomic, copy) NSDictionary * properties;
@end
