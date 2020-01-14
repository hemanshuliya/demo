//
//  ViewController.swift
//  SQLiteSwiftDemo
//

//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var firstName: UITextField!
    var db: OpaquePointer?
    
    /*
     The above method calls sqlite3_open(), which opens or creates a new database file. If it’s successful, it returns an OpaquePointer; this is a Swift type for C pointers that can’t be represented directly in Swift. When you call this method, you’ll have to capture the returned pointer in order to interact with the database.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessagesFromServer { (data) in
            
            let str = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue)
            print("\(String(describing: str))")
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("\(json)")
                
            } catch {
                print("error serializing JSON: \(error)")
            }
        }
    }
    
    func getMessagesFromServer(completionHandler: @escaping (Data) -> ()) {
        let site = "http://13.233.99.30:3000/messages"
        let url = URL(string: site)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            if (err != nil) {
                completionHandler(Data())
            } else {
                completionHandler(data!)
            }
        }.resume()
    }
    
    func openDatabase() -> OpaquePointer? {
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Contacts.sqlite")
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(fileURL.path)")
            return db
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
            return nil
        }
    }
    
    
    @IBAction func btnOpenDataBase(_ sender: UIButton) {
        db = openDatabase()
        // 1
        var createTableStatement: OpaquePointer? = nil
        
        let createTableString = "CREATE TABLE IF NOT EXISTS Contacts (id INTEGER PRIMARY KEY AUTOINCREMENT, firstname TEXT, lastname TEXT);"
        // 2
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Contact table created.")
            } else {
                print("Contact table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        //4
        sqlite3_finalize(createTableStatement)
        
        readValues()
        
//        alterTableAddColumn()
    }
    
    @IBAction func btnInsertIntoDatabase(_ sender: UIButton) {
        let str_firstname : NSString = firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
        let str_lastname : NSString = lastname.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
        
        var insertStatement: OpaquePointer? = nil
        
        let insertStatementString = "INSERT INTO Contacts VALUES (?,?,?);"
        
         // 1
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK{
            if sqlite3_bind_text(insertStatement, 2, str_firstname.utf8String, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding firstname: \(errmsg)")
                return
            }
            
            if sqlite3_bind_text(insertStatement, 3, str_lastname.utf8String, -1, nil) != SQLITE_OK{
                //sqlite3_bind_text(opaquepointer, column number, variable, -1, nil)
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding lastname: \(errmsg)")
                return
            }
            
            if sqlite3_step(insertStatement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting hero: \(errmsg)")
                print("Could not insert row.")
                return
            }else{
                print("Successfully inserted row.")
            }
            
            
        }else {
            print("INSERT statement could not be prepared.")
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        
        // 5
        sqlite3_finalize(insertStatement)
        
        readValues()
        
    }
    
    func readValues(){
        
        let queryString = "SELECT * FROM Contacts;"
        
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
            print("SELECT statement could not be prepared")
            return
        }else {
            while(sqlite3_step(queryStatement) == SQLITE_ROW){
                let id = sqlite3_column_int(queryStatement, 0)
                let firstname = String(cString: sqlite3_column_text(queryStatement, 1))
                let lastname = String(cString: sqlite3_column_text(queryStatement, 2))
                
                print("\(id), \(firstname), \(lastname)")
                //            heroList.append(Hero(id: Int(id), name: String(describing: name), powerRanking: Int(powerrank)))
            }
        }
        
        // 6
        sqlite3_finalize(queryStatement)
    }
    
    func bluckInsert() {
    
      var insertStatement: OpaquePointer? = nil
      // 1
      let firstnames: [NSString] = ["Ray", "Chris", "Martha", "Danielle"]
    
        let insertStatementString = "INSERT INTO Contacts VALUES (?,?,?);"

        
      if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
    
        // 2
        for (index, name) in firstnames.enumerated() {
          // 3
//          let id = Int32(index + 1)
//          sqlite3_bind_int(insertStatement, 1, id)
          sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, name.utf8String, -1, nil)
    
          if sqlite3_step(insertStatement) == SQLITE_DONE {
            print("Successfully inserted row.")
          } else {
            print("Could not insert row.")
          }
          // 4
          sqlite3_reset(insertStatement)
        }
    
        sqlite3_finalize(insertStatement)
      } else {
        print("INSERT statement could not be prepared.")
      }
    }
    
    
    @IBAction func updateIntoDatabase(_ sender: UIButton) {
        let updateStatementString = "UPDATE Contacts SET firstname = 'Chris', lastname = 'tob' WHERE id = 1;"
        
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
        } else {
            print("UPDATE statement could not be prepared")
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        sqlite3_finalize(updateStatement)
        
        readValues()
    }
    
    @IBAction func deleteIntoDatabase(_ sender: UIButton) {
        let deleteStatementStirng = "DELETE FROM Contacts WHERE Id = 15;"
        
        
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
        } else {
            print("DELETE statement could not be prepared")
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        sqlite3_finalize(deleteStatement)
        
    }
    
    func tableHasColumn(db: OpaquePointer?, tableName: String, columnName: String) -> Bool {
        
        var retVal = false
        
        var tableColumnsQueryStatement: OpaquePointer? = nil
        
        let queryString = "PRAGMA table_info(\(tableName));"
        
        if sqlite3_prepare_v2(db, queryString, -1, &tableColumnsQueryStatement, nil) == SQLITE_OK{
            
            while (sqlite3_step(tableColumnsQueryStatement) == SQLITE_ROW) {
                
                let queryResultCol1 = sqlite3_column_text(tableColumnsQueryStatement, 1)
                let currentColumnName = String(cString: queryResultCol1!)
                
                if currentColumnName == columnName {
                    retVal = true
                    break
                }
            }
        }
        
        return retVal
    }
    
    func alterTableAddColumn() {
        if tableHasColumn(db: db, tableName: "Contacts", columnName: "blocknumber"){
            
        }else {
            let updateSQLString = "ALTER TABLE Contacts ADD COLUMN blocknumber TEXT default null";
            
            var updateStatement : OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, updateSQLString, -1, &updateStatement, nil) == SQLITE_OK{
                if(sqlite3_step(updateStatement)==SQLITE_DONE){
                    print("Table Altered")
                }else{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing select: \(errmsg)")
                }
            }
            // Release the compiled statement from memory
            sqlite3_finalize(updateStatement);
        }
    }
}

/*
 
 References :
 
 https://www.raywenderlich.com/385-sqlite-with-swift-tutorial-getting-started
 https://www.sqlite.org/cli.html
 
 */
