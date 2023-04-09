//
//  EditContactViewController.swift
//  Project_IOS
//
//  Created by user234279 on 4/9/23.
//

import UIKit

class EditContactViewController: UIViewController {
    
    
    var firstName = "";
    
    var lastName = "";
    
    var email = "";
    
    var phone = "";
    
    var notes = "";

    @IBOutlet weak var First_TXTBOX: UITextField!
    
    @IBOutlet weak var Last_TXTBOX: UITextField!
    
    @IBOutlet weak var Email_TXTBOX: UITextField!
    
    @IBOutlet weak var Notes_TXTVIEW: UITextView!
    
    @IBOutlet weak var Phone_TXTBOX: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        First_TXTBOX.text = firstName;
        
        Last_TXTBOX.text = lastName;
        
        Email_TXTBOX.text = email;
        
        Phone_TXTBOX.text = phone;
        
        Notes_TXTVIEW.text = notes;
        
        Notes_TXTVIEW.isEditable = false;
        
        
        
        
        
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
