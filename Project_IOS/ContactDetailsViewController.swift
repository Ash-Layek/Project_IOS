//
//  ContactDetailsViewController.swift
//  Project_IOS
//
//  Created by user234279 on 4/8/23.
//

import UIKit
import SQLite3

class ContactDetailsViewController: UIViewController {
    @IBOutlet weak var myTestLabel: UILabel!
    
    @IBOutlet weak var firstNameLBL: UILabel!
    
    
    @IBOutlet weak var notesTXT: UITextView!
    
    @IBOutlet weak var emailLBL: UILabel!
    
    @IBOutlet weak var phoneLBL: UILabel!
    
    var lastname = "";
    
    var firstname = "";
    
    var email = ""
    
    var phone = ""
    
    var notes__ = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        myTestLabel.text = lastname;
        
        var db : OpaquePointer?
        
        
        if let databasePath = getDatabasePath(), sqlite3_open(databasePath, &db) == SQLITE_OK {
            let query = "SELECT FirstName, LastName, Email, Phone, Notes FROM ContactInfo WHERE LastName = ?"
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                
                sqlite3_bind_text(statement, 1, (lastname as NSString).utf8String, -1, nil)
               
                while sqlite3_step(statement) == SQLITE_ROW {
                    if let cString = sqlite3_column_text(statement, 0) {
                        let firstName = String(cString: cString)
                    
                        print(firstName)
                        myTestLabel.text = firstName;
                        
                        firstname = firstName;

                        
                    }
                    
                    if let cString = sqlite3_column_text(statement, 1) {
                        let lastName = String(cString: cString)
                    
                        
                       print(lastName)
                        
                        firstNameLBL.text = lastName;
                        
                        lastname  = lastName;
                        
                        
                        
                    }
                    
                    if let cString = sqlite3_column_text(statement, 2) {
                        let lastName = String(cString: cString)
                    
                        
                       print(lastName)
                        
                        emailLBL.text = lastName
                        
                        email = lastName;
                        
                        
                    }
                    
                    if let cString = sqlite3_column_text(statement, 3) {
                        let lastName = String(cString: cString)
                    
                        
                       print(lastName)
                        
                        phoneLBL.text = lastName
                        
                        phone = lastName;
                        
                        
                    }
                    
                    if let cString = sqlite3_column_text(statement, 4) {
                        let lastName = String(cString: cString)
                    
                        
                       print(lastName)
                        
                        notesTXT.text = lastName
                        
                        notes__ = lastName;
                        
                        
                    }
                }
                
                sqlite3_finalize(statement)
                sqlite3_close(db)
                
               
            } else {
                print("Error preparing SELECT statement: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Error opening database.")
        }


        
        
    }
    
    @IBAction func editClicked(_ sender: Any) {
        
        if let vc = storyboard?.instantiateViewController(identifier: "EditContactViewController") as? EditContactViewController {
            
            
            vc.firstName = firstname;
            
            vc.lastName = lastname;
            
            vc.email = email;
            
            vc.phone = phone;
            
            vc.notes = notes__;
            
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        
        saveNotes();
        
    }
    func saveNotes()
    {
        var db: OpaquePointer?
        
        notes__  = notesTXT.text

        var statement: OpaquePointer?
        let query = "UPDATE ContactInfo SET Notes = ? WHERE LastName = ?"

        if let databasePath = getDatabasePath(), sqlite3_open(databasePath, &db) == SQLITE_OK {
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, notes__, -1, nil)
                sqlite3_bind_text(statement, 2, lastname, -1, nil)

                // Begin a transaction
                if sqlite3_exec(db, "BEGIN TRANSACTION", nil, nil, nil) != SQLITE_OK {
                    print("Error beginning transaction: \(String(cString: sqlite3_errmsg(db)))")
                    return
                }

                if sqlite3_step(statement) != SQLITE_DONE {
                    print("Error updating notes: \(String(cString: sqlite3_errmsg(db)))")

                    // Roll back the transaction if there was an error
                    if sqlite3_exec(db, "ROLLBACK TRANSACTION", nil, nil, nil) != SQLITE_OK {
                        print("Error rolling back transaction: \(String(cString: sqlite3_errmsg(db)))")
                    }
                } else {
                    // Commit the transaction if there were no errors
                    if sqlite3_exec(db, "COMMIT TRANSACTION", nil, nil, nil) != SQLITE_OK {
                        print("Error committing transaction: \(String(cString: sqlite3_errmsg(db)))")
                    } else {
                        print("Update successful!")
                    }
                }

                sqlite3_finalize(statement)
            } else {
                print("Error preparing UPDATE statement: \(String(cString: sqlite3_errmsg(db)))")
            }

            sqlite3_close(db)
        } else {
            print("Error opening database.")
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




