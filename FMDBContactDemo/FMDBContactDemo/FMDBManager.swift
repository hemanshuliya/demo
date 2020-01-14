//
//  FMDBManager.swift
//  FMDBContactDemo
//
//

import UIKit
import Contacts

struct ContactDetail {
    var contactid: String?
    var firstname: String?
    var lastname: String?
    var companyname: String?
    var phonenumber: String?
    var imageurl: String?
}


class FMDBManager: NSObject {
    let field_ContactID = "identifier"
    let field_firstname = "firstname"
    let field_lastname = "lastname"
    let field_companyname = "companyname"
    let field_phonenumber = "phonenumber"
    let field_imageURL = "imageurl"
    
    
    static let shared: FMDBManager = FMDBManager()
    
    let databaseFileName = "contactlist.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    func createDatabase() -> Bool {
        var created = false
        
        print(pathToDatabase)
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    let createContactListTableQuery = "create table contactlist (\(field_ContactID) text, \(field_firstname) text, \(field_lastname) text, \(field_companyname) text, \(field_phonenumber) text,  \(field_imageURL) text)"
                    
                    
                    do {
                        try database.executeUpdate(createContactListTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
//                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    func insertContactDataFromArray(arrContacts: [CNContact]){
        if openDatabase() {
            do {
                //
                database.beginTransaction()
                
                for contact in arrContacts {
                    let yesNo = checkIfContactIdIsPresent(contactIdentifier: contact.identifier)
                    if !yesNo {
                        let identifier = contact.identifier
                        let firstname  = contact.givenName
                        let lastname  = contact.familyName
                        let companyname  = contact.departmentName
                        let phonenumber  = contact.phoneNumbers[0]
                        let imagename  = ""//contact.imageData
                        
                        try database.executeUpdate("insert into contactlist (identifier, firstname, lastname, companyname, phonenumber, imagePath) values (?, ?, ?, ?, ?, ?)", values: [identifier, firstname, lastname, companyname, phonenumber, imagename])
                    }
                }
                
                database.commit()
                
            } catch {
                    print("failed: \(error.localizedDescription)")
            }
            
            
//            database.close()
        }
    }
    
    func insertContactData(identifier:String, firstname: String, lastname: String, companyname: String, phonenumber : String, imagename: String)  {
        if openDatabase() {
            do {
                //
                database.beginTransaction()
                
                try database.executeUpdate("insert into contactlist (identifier, firstname, lastname, companyname, phonenumber, imagePath) values (?, ?, ?, ?, ?, ?)", values: [identifier, firstname, lastname, companyname, phonenumber, imagename])
                
                database.commit()
                
            } catch {
                print("failed: \(error.localizedDescription)")
            }
            
            
            database.close()
        }
    }
    
    func loadContacts() -> [ContactDetail]! {
        var arrcontactLists: [ContactDetail]!
        
        if openDatabase() {
            let query = "select * from contactlist order by \(field_firstname) asc"
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let contact = ContactDetail(contactid: results.string(forColumn: field_ContactID), firstname: results.string(forColumn: field_firstname), lastname: results.string(forColumn: field_lastname), companyname: results.string(forColumn: field_companyname), phonenumber: results.string(forColumn: field_phonenumber), imageurl: results.string(forColumn: field_imageURL))
                    
            
                    if arrcontactLists == nil {
                        arrcontactLists = [ContactDetail]()
                    }
                    
                    arrcontactLists.append(contact)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return arrcontactLists
    }
    
    func checkIfContactIdIsPresent(contactIdentifier : String) -> Bool{
        let contacts = self.loadContacts()
        let filteredItems = contacts?.filter({$0.contactid == contactIdentifier  })
        if filteredItems != nil, filteredItems?.count ?? 0 > 0{
            return true
        }else {
            return false
        }
    }
    
    func loadContact(withID ID: String, completionHandler: (_ contactDetail: ContactDetail?) -> Void) {
        var contactInfo: ContactDetail!
        
        if openDatabase() {
            let query = "select * from contactlist where \(field_ContactID)=?"
            
            do {
                let results = try database.executeQuery(query, values: [ID])
                
                if results.next() {
                    contactInfo = ContactDetail(contactid: results.string(forColumn: field_ContactID), firstname: results.string(forColumn: field_firstname), lastname: results.string(forColumn: field_lastname), companyname: results.string(forColumn: field_companyname), phonenumber: results.string(forColumn: field_phonenumber), imageurl: results.string(forColumn: field_imageURL))
                    
                }
                else {
                    print(database.lastError())
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        completionHandler(contactInfo)
    }
    
    func updateContactInfo(withID ID: String, firstname: String, lastname: String, companyname: String, phonenumber: String, imageurl : String) {
        if openDatabase() {
            let query = "update movies set \(field_firstname)=?, \(field_lastname)=?, \(field_companyname)=?, \(field_phonenumber)=?, \(field_imageURL)=?, where \(field_ContactID)=?"
            
            do {
                try database.executeUpdate(query, values: [firstname, lastname, companyname, phonenumber, imageurl, ID])
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
    
    func alert(_ txt: String, VC : UIViewController){
        let c = UIAlertController(title: nil, message: txt,
                                  preferredStyle: .alert)
        
        c.addAction(UIAlertAction(title: "OK",
                                  style: .default, handler: {action in
                                    VC.dismiss(animated: true, completion: nil)
        }))
        
        VC.present(c, animated: true, completion: nil)
    }
    
    
    
}
