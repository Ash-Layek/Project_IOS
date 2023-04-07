//
//  ContactListViewController.swift
//  Project_IOS
//
//  Created by user234279 on 4/4/23.
//

import UIKit
import SQLite3

class ContactListViewController: UIViewController {
    
    
    var lastNames = [String]();
    
    
    var hmida = "";
    
    @IBOutlet weak var TB_LIST: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var db: OpaquePointer?

        
        var statement: OpaquePointer?
      

        if let databasePath = getDatabasePath(), sqlite3_open(databasePath, &db) == SQLITE_OK {
            let query = "SELECT LastName FROM ContactInfo"
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
               
                while sqlite3_step(statement) == SQLITE_ROW {
                    if let cString = sqlite3_column_text(statement, 0) {
                        let lastName = String(cString: cString)
                        lastNames.append(lastName)
                    }
                }
                
                sqlite3_finalize(statement)
                sqlite3_close(db)
                
                print("Retrieved last names: \(lastNames)")
            } else {
                print("Error preparing SELECT statement: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Error opening database.")
        }

        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegu}
    */

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


extension ContactListViewController : UITableViewDataSource {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lastNames.count
        
            }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = lastNames[indexPath.row];
        
        
        
        return cell;
        
    }


    	
    
}
