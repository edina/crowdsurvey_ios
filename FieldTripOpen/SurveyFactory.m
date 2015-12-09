//
//  SurveyFactory.m
//  FieldTripOpen
//
//  Created by Ian Fieldhouse on 09/12/2015.
//  Copyright © 2015 Edina. All rights reserved.
//

#import "SurveyFactory.h"
#import "CBObjects.h"
#import <CouchbaseLite/CouchbaseLite.h>
#import "RKDynamicMapping.h"
#import "RKMIMETypeSerialization.h"
#import "RKObjectMapping.h"
#import "RKObjectMappingOperationDataSource.h"
#import "RKObjectRequestOperation.h"
#import "RKRelationshipMapping.h"
#import "RKResponseDescriptor.h"

@interface SurveyFactory ()

@property (strong, nonatomic) Survey *survey;

@end

@implementation SurveyFactory

- (Survey *)survey
{
    if (!_survey) {
        _survey = [[Survey alloc] init];
    }
    return _survey;
}


-(void) createSurveyFromUrl:(NSURL *) url withCompletion:(void (^)(Survey *survey))completion
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    RKObjectMapping* surveyMapping = [RKObjectMapping mappingForClass:[Survey class]];
    [surveyMapping addAttributeMappingsFromDictionary:@{
                                                        @"title": @"title",
                                                        @"geoms": @"geoms"
                                                        }];
    
    RKObjectMapping* fieldMapping = [RKObjectMapping mappingForClass:[Field class]];
    [fieldMapping addAttributeMappingsFromDictionary:@{
                                                       @"id": @"fieldId",
                                                       @"type": @"type",
                                                       @"label": @"label",
                                                       @"required": @"required",
                                                       @"persistent": @"persistent",
                                                       @"properties": @"properties"
                                                       }];
    
    [surveyMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"fields"
                                                                                  toKeyPath:@"fields"
                                                                                withMapping:fieldMapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:surveyMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        self.survey = [result firstObject];
        NSLog(@"Mapped the Survey: %@", self.survey);
        for (Field *field in self.survey.fields){
            NSString *fid = field.fieldId;
            NSString *type = field.type;
            NSLog(@"%@", fid);
            NSLog(@"%@", type);
        }
        completion(self.survey);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    
    [operation start];
}

//NSString* docID = [self createSurveyDocument:survey];
//
//// Dummy update
//[self updateDocument:CBObjects.sharedInstance.database documentId:docID];
//
//[self createOrderedByDateView];

//
//
//# pragma mark - CouchDB
//
//// creates the Document
//- (NSString *)createSurveyDocument: (NSDictionary *)survey {
//    
//    // 1. Create an empty document
//    CBLDocument *doc = [CBObjects.sharedInstance.database createDocument];
//    // 2. Save the ID of the new document
//    NSString *docID = doc.documentID;
//    // 3. Write the document to the database
//    NSError *error;
//    CBLRevision *newRevision = [doc putProperties: survey error:&error];
//    if (newRevision) {
//        NSLog(@"Document created and written to database, ID = %@", docID);
//    }
//    return docID;
//}
//
//- (CBLView *)getView {
//    CBLDatabase* database = [CBObjects sharedInstance].database;
//    return [database viewNamed:@"byDate"];
//}
//
//- (void) createOrderedByDateView {
//    CBLView* orderedByDateView = [self getView];
//    [orderedByDateView setMapBlock: MAPBLOCK({
//        emit(doc[@"date"], nil);
//    }) version: @"1" /* Version of the mapper */ ];
//    NSLog(@"Ordered By Date View created.");
//}
//
//- (BOOL) updateDocument:(CBLDatabase *) database documentId:(NSString *) documentId {
//    // 1. Retrieve the document from the database
//    CBLDocument *getDocument = [database documentWithID: documentId];
//    // 2. Make a mutable copy of the properties from the document we just retrieved
//    NSMutableDictionary *docContent = [getDocument.properties mutableCopy];
//    // 3. Modify the document properties
//    docContent[@"description"] = @"Anyone is invited!";
//    docContent[@"address"] = @"123 Elm St.";
//    docContent[@"date"] = @"2014";
//    // 4. Save the Document revision to the database
//    NSError *error;
//    CBLSavedRevision *newRev = [getDocument putProperties:docContent error:&error];
//    if (!newRev) {
//        NSLog(@"Cannot update document. Error message: %@", error.localizedDescription);
//    }
//    // 5. Display the new revision of the document
//    NSLog(@"The new revision of the document contains: %@", newRev.properties);
//    return YES;
//}

@end
