//
//  CouchBaseUtils.swift
//  
//
//  Created by Ian Fieldhouse on 26/01/2016.
//
//

import Foundation
import SwiftyJSON


class CouchBaseUtils {
    
    var database: CBLDatabase!
    
    init(databaseName: String) {
        let manager = CBLManager.sharedInstance()
        
        do {
            try self.database = manager.databaseNamed(databaseName)
        } catch {
            print("Can't access database")
        }
    }
    
    
    func getOrCreateDocument(jsonData: AnyObject) -> CBLDocument? {
        let json = JSON(jsonData)
        let id = json["id"].string
        var document: CBLDocument?
        
        if let docId = id {
            if let doc = self.database.existingDocumentWithID(docId) {
                document = doc
            } else {
                document = self.database.documentWithID(docId)
                do {
                    try document!.putProperties(jsonData as! [String : AnyObject])
                    print("Saved document id ", docId)
                } catch {
                    print("Error saving document id")
                }
            }
        }
        
        return document
    }
    
}
