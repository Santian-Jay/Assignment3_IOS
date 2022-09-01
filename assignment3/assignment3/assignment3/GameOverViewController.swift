//
//  GameOverViewController.swift
//  assignment3
//
//  Created by 小星星的三天 on 14/5/2022.
//
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit

class GameOverViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var gStartTime: UILabel!
    @IBOutlet var gEndTime: UILabel!
    @IBOutlet var gDuration: UILabel!
    @IBOutlet var gRepeated: UILabel!
    @IBOutlet var gCompleted: UILabel!
    @IBOutlet var gMode: UILabel!
    @IBOutlet var gImage: UIImageView!
    @IBOutlet var gList: UITextView!
    @IBOutlet var gExerciseChoose: UILabel!
    @IBOutlet var gClickedCount1: UILabel!
    @IBOutlet var gClickedCount2: UILabel!
    @IBOutlet var gClickedCount3: UILabel!
    @IBOutlet var gClickedCount4: UILabel!
    @IBOutlet var gClickedCount5: UILabel!

    var buttonClickedcount = [Int]()
    var buttonClickedList = [String]()
    var numberOfButtons = 0
    var startTime: String = ""
    var endTime: String = ""
    var duration: Int = 0
    var repeated:Int = 0
    var completed:Bool = false
    var mode: String = ""
    var exerciseChoose: Int = 1
    let storage = Storage.storage().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        gClickedCount1.text = "1: \(buttonClickedcount[0])"
        gClickedCount2.text = "2: \(buttonClickedcount[1])"
        gList.text = stringToString()
        gStartTime.text = "\(startTime)"
        gEndTime.text = "\(endTime)"
        gDuration.text = "\(duration)"
        gRepeated.text = "\(repeated)"
        gCompleted.text = "\(completed)"
        gMode.text = "\(mode)"
        gExerciseChoose.text = "exercise\(exerciseChoose)"
        setListValue()

        // Do any additional setup after loading the view.
    }
    
    func stringToString() -> String{
        var tempString = ""
        for data in 0...buttonClickedList.count - 1{
            if data != buttonClickedList.count - 1{
                if buttonClickedList[buttonClickedList.count - 1] == "" && data != buttonClickedList.count - 2{
                    tempString += "\(buttonClickedList[data]), "
                }else if buttonClickedList[buttonClickedList.count - 1] == "" && data == buttonClickedList.count - 2{
                    tempString += "\(buttonClickedList[data])"
                }else{
                    tempString += "\(buttonClickedList[data]), "
                }
            }else{
                tempString += "\(buttonClickedList[data])"
            }
        }
        
        return tempString
    }
    
    func setListValue(){
        switch numberOfButtons{
        case 3:
            gClickedCount3.isHidden = false
            gClickedCount3.text = "3: \(buttonClickedcount[2])"
        case 4:
            gClickedCount3.isHidden = false
            gClickedCount4.isHidden = false
            gClickedCount3.text = "3: \(buttonClickedcount[2])"
            gClickedCount4.text = "4: \(buttonClickedcount[3])"
        default:
            gClickedCount3.isHidden = false
            gClickedCount4.isHidden = false
            gClickedCount5.isHidden = false
            gClickedCount3.text = "3: \(buttonClickedcount[2])"
            gClickedCount4.text = "4: \(buttonClickedcount[3])"
            gClickedCount5.text = "5: \(buttonClickedcount[4])"
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func saveAndGoToHistory(_ sender: Any) {
        self.performSegue(withIdentifier: "saveToHistory", sender: nil)
    }
    
    
    @IBAction func takePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("camera available")
        }else{
            print("no camera available")
        }
    }
    
    
    @IBAction func selectPicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            print("no photo library available")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            if let url = info[.imageURL] as? URL{
                gImage.image = image
                dismiss(animated: true, completion: nil)
                uploadPicture(imageURL: url)
            }
        }
    }
    
    func uploadPicture(imageURL: URL){
        let path = storage.child("images/\(startTime).png")
        let imagePath = imageURL
        
        let upload = path.putFile(from: imagePath, metadata: nil) {(metadata, err) in
            guard let metadata = metadata else{
                print(err?.localizedDescription)
                return
            }
            print("upload successfully!")
        }
        
    }
    
}
