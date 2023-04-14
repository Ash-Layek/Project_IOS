//
//  EditContactViewController.swift
//  Project_IOS
//
//  Created by user234279 on 4/9/23.
//

import UIKit

import SQLite3

class EditContactViewController: UIViewController {
    
    
    var firstName = "";
    
    var lastName = "";
    
    var email = "";
    
    var phone = "";
    
    var notes = "";
    
    var updatedFirstName = "";
    
    var updatedLastName = "";
    
    var updatedEmail = "";
    
    var updatedPhone = "";

    @IBOutlet weak var First_TXTBOX: UITextField!
    
    @IBOutlet weak var Last_TXTBOX: UITextField!
    
    @IBOutlet weak var Email_TXTBOX: UITextField!
    
    @IBOutlet weak var Notes_TXTVIEW: UITextView!
    
    @IBOutlet weak var Phone_TXTBOX: UITextField!
    
    
    var db : OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
      
        
        Email_TXTBOX.resignFirstResponder();
        
        Phone_TXTBOX.resignFirstResponder()
        
        Notes_TXTVIEW.resignFirstResponder();
        
        
        
        First_TXTBOX.text = firstName;
        
        Last_TXTBOX.text = lastName;
        
        Email_TXTBOX.text = email;
        
        Phone_TXTBOX.text = phone;
        
        Notes_TXTVIEW.text = notes;
        
        Notes_TXTVIEW.isEditable = false;
        
        
        
        
       
        
        
        
        
        
        
    }
    
    
    @IBAction func saveClicked(_ sender: Any) {
        
        
        editData();
        
    }
    
    func editData() {
        
        
        
        
        let insertQuery = "UPDATE  ContactInfo SET FirstName=?, LastName=?, Email=?, Phone=? WHERE LastName=?"
        
        var statement: OpaquePointer?
        
        if let databasePath = getDatabasePath() {
            if sqlite3_open(databasePath, &db) == SQLITE_OK {
                
                print(databasePath);
                if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
                    sqlite3_bind_text(statement, 1, (updatedFirstName as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(statement, 2, (updatedFirstName as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(statement, 3, (updatedEmail as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(statement, 4, Int32(updatedPhone) ?? 0)
                    sqlite3_bind_text(statement, 5, (lastName as NSString).utf8String, -1, nil)
                    

                    if sqlite3_step(statement) == SQLITE_DONE {
                        print("Successfully Updated row.")
                        let alertController = UIAlertController(title: "Success", message: "Record inserted successfully.", preferredStyle: .alert)

                        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                            alertController.dismiss(animated: true, completion: nil)
                        }

                        alertController.addAction(okAction)

                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        print("Could not update row.")
                    }
                    
                    sqlite3_finalize(statement)
                }
                sqlite3_close(db)
            } else {
                print("Unable to open database.")
            }
        } else {
            print("Could not get database path.")
        }
        
       
    }

    
    
    
    
    
    func getDatabasePath() -> String? {
        if let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let databasePath = "\(documentsPath)/IOS_DB.db"
            if !FileManager.default.fileExists(atPath: databasePath) {
                if let bundlePath = Bundle.main.path(forResource: "IOS_DB", ofType: "db") {
                    do {
                        try FileManager.default.copyItem(atPath: bundlePath, toPath: databasePath)
                    } catch {
                        print("Error copying database: \(error)")
                        return nil
                    }
                } else {
                    print("Database not found in bundle.")
                    return nil
                }
            }
            return databasePath
        } else {
            print("Documents directory not found.")
            return nil
        }
        
        
    }
   
    

   

}
