//
//  SurveyFactory.h
//  FieldTripOpen
//
//  Created by Ian Fieldhouse on 09/12/2015.
//  Copyright © 2015 Edina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Survey.h"

@interface SurveyFactory : NSObject

-(void) createSurveyFromUrl:(NSURL *) url withCompletion:(void (^)(Survey *survey))completion;

@end
