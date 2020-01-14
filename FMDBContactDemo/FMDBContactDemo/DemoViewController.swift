//
//  DemoViewController.swift
//  FMDBContactDemo

import UIKit
import ContactsUI

class DemoViewController: UIViewController {
//        var contacts = [CNContact]()
//        var contactDictionary = [String: [CNContact]]()
//        var contactsSectionTitles = [String]()
//        
//        let store = CNContactStore()
//        
//        @IBOutlet weak var tblView: UITableView!
//        
//        let database = FMDatabase.init()
//        
//        @IBAction func btnAddPressed(_ sender: Any) {
//        }
//        @IBAction func btnRefreshPressed(_ sender: Any) {
//        }
//        @IBOutlet weak var btnAdd: UIBarButtonItem!
//        @IBOutlet weak var btnRefresh: UIBarButtonItem!
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            // Do any additional setup after loading the view, typically from a nib.
//            
//            authorizeContacts { (isAuthorized) in
//                if isAuthorized{
//                    self.fetchContacts()
//                    self.tblView.dataSource = self
//                    self.tblView.delegate = self
//                    self.tblView.reloadData()
//                    
//                    //                self.openContactPicker()
//                    //                self.example1()
//                }else {
//                    self.alert("Please grant access to Contacts in Settings")
//                }
//            }
//            
//            
//            
//            let fileURL = try! FileManager.default
//                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//                .appendingPathComponent("contact.sqlite")
//            
//            print(fileURL)
//            
//            let database = FMDatabase(url: fileURL)
//            
//            guard database.open() else {
//                print("Unable to open database")
//                return
//            }
//            do {
//                
//                //            if !(database.columnExists("id", inTableWithName: "contactTable")) {
//                //                let alterTable = "ALTER TABLE contactTable ADD COLUMN id"
//                //                if database.executeUpdate(alterTable, withArgumentsIn: []){
//                //                    print("new column added")
//                //                }
//                //                else {
//                //                    print("issue in operation")
//                //                }
//                //            }
//                
//                try database.executeUpdate("create table contacts(id integer primary key autoincrement not null, firstname text, lastname text, companyname text, phonenumber text, imagePath text)", values: nil)
//                //
//                try database.executeUpdate("insert into contacts (firstname, lastname, companyname, phonenumber, imagePath) values (?, ?, ?, ?, ?)", values: ["Hemanshu", "Liya", "E2logy", "9427202864", ""])
//                
//                //            try database.executeUpdate("update contactTable set firstname=?, lastname=?, phonenumber=?  where id=1", values: ["Mahendra", "Liya", "9427202864"])
//            } catch {
//                print("failed: \(error.localizedDescription)")
//            }
//            
//            database.close()
//            
//        }
//        
//        func alert(_ txt: String){
//            let c = UIAlertController(title: nil, message: txt,
//                                      preferredStyle: .alert)
//            
//            c.addAction(UIAlertAction(title: "OK",
//                                      style: .default, handler: {action in
//                                        self.dismiss(animated: true, completion: nil)
//            }))
//            
//            present(c, animated: true, completion: nil)
//        }
//        
//        func authorizeContacts(completionHandler
//            : @escaping (_ succeeded: Bool) -> Void){
//            
//            switch CNContactStore.authorizationStatus(for: .contacts){
//            case .authorized:
//                completionHandler(true)
//                break
//            case .notDetermined:
//                CNContactStore().requestAccess(for: .contacts){succeeded, err in
//                    completionHandler(err == nil && succeeded)
//                }
//                break
//            case .denied:
//                completionHandler(false)
//                break
//            case .restricted:
//                completionHandler(false)
//                break
//            default:
//                completionHandler(false)
//            }
//            
//        }
//        
//        
//        func createContactTable() {
//            
//        }
//        
//        func InsertIntoContactTable() {
//            
//        }
//        
//        func updateContactTable(){
//            do {
//                
//            } catch {
//                print("failed: \(error.localizedDescription)")
//            }
//        }
//        
//        func openDatabase() {
//            
//            createContactTable()
//        }
//        
//        func openContactPicker() {
//            let cnPicker = CNContactPickerViewController()
//            cnPicker.delegate = self
//            self.present(cnPicker, animated: true, completion: nil)
//        }
//        
//        //MARK:- CNContactPickerDelegate Method
//        
//        
//        func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
//            contacts.forEach { contact in
//                for number in contact.phoneNumbers {
//                    let phoneNumber = number.value
//                    print("number is = \(phoneNumber)")
//                }
//            }
//        }
//        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
//            print("Cancel Contact Picker")
//        }
//        
//        func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
//            guard let nc = navigationController else {return}
//            
//            //whatever happens, pop back to our view controller
//            defer{nc.popViewController(animated: true)}
//            
//            guard let contact = contact else{
//                print("The contact creation was cancelled")
//                return
//            }
//            
//            print("Contact was created successfully \(contact)")
//        }
//        
//        //Allows the user to create a new contact
//        func example1(){
//            
//            let contact = CNContact().mutableCopy() as! CNMutableContact
//            contact.givenName = "hemanshu"
//            contact.familyName = "liya"
//            
//            let controller = CNContactViewController(forNewContact: contact)
//            controller.contactStore = store
//            controller.delegate = self
//            
//            navigationController?
//                .pushViewController(controller, animated: true)
//            
//        }
//        
//        func fetchContacts() {
//            let contactStore = CNContactStore()
//            let keysToFetch = [
//                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
//                CNContactPhoneNumbersKey,
//                CNContactEmailAddressesKey, CNContactNamePrefixKey] as [Any]
//            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
//            request.sortOrder = CNContactSortOrder.givenName
//            
//            
//            do {
//                try contactStore.enumerateContacts(with: request) { (contact, stop) in
//                    for number in contact.phoneNumbers {
//                        let phoneNumber = number.value
//                        print("number is = \(phoneNumber)")
//                    }
//                    self.contacts.append(contact)
//                }
//                
//                for contact in contacts {
//                    let contactKey = String(contact.givenName.prefix(1))
//                    if var contactValues = contactDictionary[contactKey] {
//                        contactValues.append(contact)
//                        contactDictionary[contactKey] = contactValues
//                    } else {
//                        contactDictionary[contactKey] = [contact]
//                    }
//                }
//                
//                contactsSectionTitles = [String](contactDictionary.keys)
//                contactsSectionTitles = contactsSectionTitles.sorted(by: { $0 < $1 })
//                print(contacts)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    
//    extension ViewController: UITableViewDataSource{
//        func numberOfSections(in tableView: UITableView) -> Int {
//            return contactsSectionTitles.count
//        }
//        
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            let contactKey = contactsSectionTitles[section]
//            if let contactValues = contactDictionary[contactKey] {
//                return contactValues.count
//            }
//            
//            return 0
//        }
//        
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            
//            
//            
//            let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
//            
//            // Configure the cell...
//            let contactKey = contactsSectionTitles[indexPath.section]
//            if let contactValues = contactDictionary[contactKey] {
//                cell.textLabel?.text = contactValues[indexPath.row].givenName
//            }
//            
//            
//            return cell
//        }
//    }
//    
//    extension ViewController: UITableViewDelegate{
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 60
//        }
//        
//        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 60
//        }
//        
//        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//            return contactsSectionTitles[section]
//        }
//        func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//            return contactsSectionTitles
//        }
}
