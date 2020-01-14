//
//  ViewController.swift
//  FMDBContactDemo
//
//

import UIKit
import ContactsUI

class ViewController: UIViewController, CNContactViewControllerDelegate {
    var contacts = [CNContact]()
    var contactDictionary = [String: [ContactDetail]]()
    var contactsSectionTitles = [String]()
    var selectedcontact : ContactDetail? = nil

    @IBOutlet weak var tblView: UITableView!
    
    let database = FMDatabase.init()
    
    
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    @IBOutlet weak var btnRefresh: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeContacts { (isAuthorized) in
            if isAuthorized{
                
                
                let arrOfContacts = self.fetchContactListFromNativeApplication()
                if FMDBManager.shared.createDatabase() {
                    
                }
                FMDBManager.shared.insertContactDataFromArray(arrContacts: arrOfContacts)
                DispatchQueue.main.async {
                    self.tblView.dataSource = self
                    self.tblView.delegate = self
                    self.tblView.reloadData()
                }
                
                let arrContacts = FMDBManager.shared.loadContacts()
                
                for contact in arrContacts! {
                    let contactKey = String(contact.firstname!.prefix(1)).uppercased()
                    if var contactValues = self.contactDictionary[contactKey] {
                        contactValues.append(contact)
                        self.contactDictionary[contactKey] = contactValues
                    } else {
                        self.contactDictionary[contactKey] = [contact]
                    }
                }
                
                
            }
        }
       
    }
    
    func callMethodinViewdidLoad(){
        
        authorizeContacts { (isAuthorized) in
            if isAuthorized{
                self.fetchContacts()
                DispatchQueue.main.async {
                    self.tblView.dataSource = self
                    self.tblView.delegate = self
                    self.tblView.reloadData()
                }
            }else {
                FMDBManager.shared.alert("Please grant access to Contacts in Settings", VC: self)
            }
        }

        //Database
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("contact.sqlite")
        
        print(fileURL)
        
        let database = FMDatabase(url: fileURL)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        do {
            
            //            if !(database.columnExists("id", inTableWithName: "contactTable")) {
            //                let alterTable = "ALTER TABLE contactTable ADD COLUMN id"
            //                if database.executeUpdate(alterTable, withArgumentsIn: []){
            //                    print("new column added")
            //                }
            //                else {
            //                    print("issue in operation")
            //                }
            //            }
            
            try database.executeUpdate("create table contacts(id integer primary key autoincrement not null, firstname text, lastname text, companyname text, phonenumber text, imagePath text)", values: nil)
            //
            try database.executeUpdate("insert into contacts (firstname, lastname, companyname, phonenumber, imagePath) values (?, ?, ?, ?, ?)", values: ["Hemanshu", "Liya", "E2logy", "9427202864", ""])
            
            //            try database.executeUpdate("update contactTable set firstname=?, lastname=?, phonenumber=?  where id=1", values: ["Hemanshu1", "Liya1", "94272028641"])
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
        
    }
    
    func dropTable()  {
        //Database
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("contact.sqlite")
        
        print(fileURL)
        
        let database = FMDatabase(url: fileURL)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        do {
            //
            database.beginTransaction()
            
            try database.executeQuery("drop table contacts", values: nil)
            
            database.commit()
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
    }
    
    @IBAction func btnAddPressed(_ sender: Any) {
    }
    @IBAction func btnRefreshPressed(_ sender: Any) {
        
        self.viewDidLoad()
        
        
    }
    
    func insertIntoDB(identifier: String, firstname: String, lastname: String, companyname: String, phonenumber : String, imagename: String) {
        //Database
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("contact.sqlite")
        
        print(fileURL)
        
        let database = FMDatabase(url: fileURL)
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        do {
            //
            database.beginTransaction()
            
            try database.executeUpdate("insert into contacts (identifier, firstname, lastname, companyname, phonenumber, imagePath) values (?, ?, ?, ?, ?, ?)", values: [identifier, firstname, lastname, companyname, phonenumber, imagename])
            
            database.commit()
        
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
    }
    
   
    func authorizeContacts(completionHandler
        : @escaping (_ succeeded: Bool) -> Void){
        
        switch CNContactStore.authorizationStatus(for: .contacts){
        case .authorized:
            completionHandler(true)
            break
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts){succeeded, err in
                completionHandler(err == nil && succeeded)
            }
            break
        case .denied:
            completionHandler(false)
            break
        case .restricted:
            completionHandler(false)
            break
        default:
            completionHandler(false)
        }
        
    }
    
    func getPath()->(Bool, String) {
        let fileManager = FileManager.default
        var filePath : String? = ""
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let name = "\(NSDate.timeIntervalSinceReferenceDate)"
            let fileURL = documentDirectory.appendingPathComponent(name)
            filePath = fileURL.absoluteString
            let image = #imageLiteral(resourceName: "hemanshu.jpg")
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                try imageData.write(to: fileURL)
                print(fileURL)
                return (true, filePath ?? "")
            }
        } catch {
            print(error)
        }
        return (false, filePath ?? "")
    }
    func getImageFromPath(imagePath: String) -> UIImage{
//        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
//        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
//        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
////        if let dirPath          = paths.first
////        {
            let imageURL = URL(fileURLWithPath: imagePath)
            let image    = UIImage(contentsOfFile: imageURL.path)
            // Do whatever you want with the image
//        }
        return image ?? UIImage()
    }
    
    func fetchContactListFromNativeApplication() -> [CNContact] {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey, CNContactDepartmentNameKey, CNContactNamePrefixKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        request.sortOrder = CNContactSortOrder.givenName
        
        
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                var phoneNumber : String?
                for number in contact.phoneNumbers {
                    phoneNumber = "\(number.value)"
                    print("number is = \(String(describing: phoneNumber))")
                }
                
                self.contacts.append(contact)
                
            }
        } catch {
            print(error.localizedDescription)
        }
        return self.contacts
    }
    
    
    func fetchContacts() {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey, CNContactDepartmentNameKey, CNContactNamePrefixKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        request.sortOrder = CNContactSortOrder.givenName

        
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                var phoneNumber : String?
                for number in contact.phoneNumbers {
                    phoneNumber = "\(number.value)"
                    print("number is = \(String(describing: phoneNumber))")
                }
               
                self.contacts.append(contact)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}


extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactsSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contactKey = contactsSectionTitles[section]
        if let contactValues = contactDictionary[contactKey] {
            return contactValues.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        
        // Configure the cell...
        let contactKey = contactsSectionTitles[indexPath.section]
        if let contactValues = contactDictionary[contactKey] {
            cell.textLabel?.text = contactValues[indexPath.row].firstname
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactKey = contactsSectionTitles[indexPath.section]
        if let contactValues = contactDictionary[contactKey] {
            selectedcontact = contactValues[indexPath.row]
        }

        self.performSegue(withIdentifier: "abcd", sender: self)
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactsSectionTitles[section]
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactsSectionTitles
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "abcd" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.contact = selectedcontact
        }
    }
}


