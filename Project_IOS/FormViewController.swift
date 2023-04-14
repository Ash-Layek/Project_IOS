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

       
        
        
        NotesField.resignFirstResponder();
        
        PhoneField.resignFirstResponder();
        
        EmailField.resignFirstResponder();
        
        LastNameField.resignFirstResponder();
        
        firstNameField.resignFirstResponder();
        
        
        
        
        
        
        
        
       

        // Do any additional setup after loading the view.
    }
    
    
    func insertData(){
        
        
        let fname = firstNameField.text ?? ""
           let lname = LastNameField.text ?? ""
           let email = EmailField.text ?? ""
           let phone = PhoneField.text ?? ""
           let notes = NotesField.text ?? ""
           let intPhone = Int(phone) ?? 0
           
           let insertQuery = "INSERT INTO ContactInfo (FirstName, LastName, Email, Phone, Notes) VALUES (?, ?, ?, ?, ?)"
           
           var statement: OpaquePointer?
           
           if let databasePath = getDatabasePath() {
               if sqlite3_open(databasePath, &db) == SQLITE_OK {
                   
                   print(databasePath);
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
   






    
    
    @IBAction func SubmitPressed(_ sender: Any) {
        
        
        if (firstNameField.text?.isEmpty == false && LastNameField.text?.isEmpty == false && EmailField.text?.isEmpty == false && PhoneField.text?.isEmpty == false && NotesField.text.isEmpty == false){
            
            
            
            
            if (isValidEmail(EmailField.text ?? "")){
                
                
                insertData();
                
                
                
            } else {
                
                
                let alertController = UIAlertController(title: "Error", message: "Email Formatting is wrong..", preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                    alertController.dismiss(animated: true, completion: nil)
                }

                alertController.addAction(okAction)

                self.present(alertController, animated: true, completion: nil)
                
                
            }
            
            
            
            
            
        } else {
            
            
            let alertController = UIAlertController(title: "Error", message: "No  Field Should be Left Empty.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                alertController.dismiss(animated: true, completion: nil)
            }

            alertController.addAction(okAction)

            self.present(alertController, animated: true, completion: nil)
        }
        
      //  insertData();
        
        
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
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
