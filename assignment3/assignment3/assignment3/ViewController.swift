//
//  ViewController.swift
//  assignment3
//
//  Created by 小星星的三天 on 4/5/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var nameField: UITextField!
    let defaultName = UserDefaults.standard
    var userName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName = defaultName.string(forKey: "name")!
        nameField.text = userName
    }
    
    @IBAction func exerciseButton(_ sender: Any) {
        self.performSegue(withIdentifier: "goToExerciseScreen", sender: nil)
    }


    @IBAction func historyButton(_ sender: Any) {
        self.performSegue(withIdentifier: "goToHistoryScreen", sender: nil)
        //self.performSegue(withIdentifier: "gototest", sender: nil)
    }
    
    @IBAction func profileButton(_ sender: Any) {
        self.performSegue(withIdentifier: "goToProfileScreen", sender: nil)
    }
    
    @IBAction func nameEntered(_ sender: Any) {
        userName = nameField.text!
        print(userName)
        defaultName.set(userName, forKey: "name")

    }
    
    @IBAction func unwindToMainWithCancel(sender: UIStoryboardSegue)
    {
        
    }
    
    @IBAction func unwind2MainWithCancel(sender: UIStoryboardSegue)
    {
        //self.nameField.text = self.userName
        
        self.nameField.text = defaultName.string(forKey: "name")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfileScreen" {
            if let secondScreen = segue.destination as? ProfileViewController {
                secondScreen.name = nameField.text!
            }
        }
    }
}

