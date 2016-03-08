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
    
    
    func getOrCreateDocument(json: JSON) -> CBLDocument? {
  
        let id = json["id"].string
        var document: CBLDocument?
        
        if let docId = id {
            if let doc = self.database.existingDocumentWithID(docId) {
                document = doc
            } else {
                document = self.database.documentWithID(docId)
                do {
                    try document!.putProperties(json.dictionaryObject!)
                    print("Saved document id ", docId)
                } catch {
                    print("Error saving document id")
                }
            }
        }
        
        return document
    }
    
    func getDocumentById(id: String) -> CBLDocument? {
        
        var document: CBLDocument?
        
        if let doc = self.database.existingDocumentWithID(id) {
            document = doc
        }
        
        return document
    }
    
    func removeAllActiveFlags(){
        let query = self.database.createAllDocumentsQuery()
        query.allDocsMode = CBLAllDocsMode.AllDocs
        do {
            let result = try query.run()
            while let row = result.nextRow() {
                if let document = row.document {
                    if let properties = document.properties {
                        print(properties["active"])
                    }
                    removeActiveFlag(document)
                }
            }
        } catch {
            print("Error retrieving documents")
        }
    }
    
    
    func setActiveFlag(document: CBLDocument){
        self.removeAllActiveFlags()
        if var updatedProperties = document.properties {
            updatedProperties["active"] = true
            do {
                try document.putProperties(updatedProperties)
            } catch {
                print("Error updating document")
            }
        }
    }
    
    
    func removeActiveFlag(document: CBLDocument){
        if var updatedProperties = document.properties {
            updatedProperties["active"] = false
            do {
                try document.putProperties(updatedProperties)
            } catch {
                print("Error updating document")
            }
        }
    }
    
    func saveUpdatedSurvey(jsonDict: [String : AnyObject])  {
        
        let docId = jsonDict["id"] as! String
        
        if let doc = self.database.existingDocumentWithID(docId) {
            
            do {
                try doc.update({ (newSurveyRevision) -> Bool in
                    print("updating fields")
                    newSurveyRevision["fields"] = jsonDict["fields"]
                    return true
                })
                print("Saved document id ", docId)
            } catch {
                print("Error saving document id")
            }
        }else{
            print("Error trying to update survey - existing survey not found")
        }
    }
    
    func saveUpdatedSurveyRecords(jsonDict: [String : AnyObject])  {
        
        let docId = jsonDict["id"] as! String
        
        if let doc = self.database.existingDocumentWithID(docId) {
            
            do {
                try doc.update({ (newSurveyRevision) -> Bool in
                    print("updating fields")
                    
//                    print(JSON(jsonDict))
                    
                    newSurveyRevision["records"] = jsonDict["records"]
                    return true
                })
                print("Saved document id ", docId)
            } catch {
                print("Error saving document id")
            }
        }else{
            print("Error trying to update survey - existing survey not found")
        }
    }

    
}
