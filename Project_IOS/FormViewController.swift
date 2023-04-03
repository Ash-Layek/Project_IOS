//
//  FormViewController.swift
//  Project_IOS
//
//  Created by user234279 on 4/2/23.
//

import UIKit
import SQLite3


class FormViewController: UIViewController {

    
    let databasePath = ""

    
    var db: OpaquePointer?
      
    
        
    @IBOutlet weak var NotesField: UITextView!
    @IBOutlet weak var PhoneField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var LastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        
        
        
       

        // Do any additional setup after loading the view.
    }
    
    
    func insertData(){
        
        
        
        let fname = firstNameField.text ?? "";
        let lname = LastNameField.text ?? "";
        let email = EmailField.text ?? "";
        let phone = PhoneField.text ?? "";
        let notes = NotesField.text ?? "";
      
        
        let intPhone = Int(phone) ?? 0;
        
        
        
        let insertQuery = "INSERT INTO ContactInfo (FirstName, LastName, Email, Phone, Notes) VALUES (?, ?, ?, ?, ?)"
        
        
        
        
        var statement: OpaquePointer?
        
        if let path = Bundle.main.path(forResource: "IOS_DB", ofType: "db") {
            print("Database path: \(path)")
            
            if sqlite3_open(path, &db) == SQLITE_OK {
                print("Successfully opened connection to database.")
                
                if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
                    sqlite3_bind_text(statement, 1, (fname as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(statement, 2, (lname as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(statement, 3, (email as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(statement, 4, Int32(intPhone) ?? 0)
                    sqlite3_bind_text(statement, 5, (notes as NSString).utf8String, -1, nil)

                    if sqlite3_step(statement) == SQLITE_DONE {
                        print("Successfully inserted row.")
                        let alertController = UIAlertController(title: "Success", message: "Record inserted successfully.", preferredStyle: .alert)

                        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                            alertController.dismiss(animated: true, completion: nil)
                        }

                        alertController.addAction(okAction)

                        self.present(alertController, animated: true, completion: nil)
                        
                        
                    } else {
                        print("Could not insert row.")
                    }
                    
                    sqlite3_finalize(statement)
                }


            
            } else {
                print("Unable to open database.")
            }
        } else {
            print("Database not found.")
        }
        
        
    }
    
    
    
    
    @IBAction func SubmitPressed(_ sender: Any) {
        
        insertData();
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
