//
//  ProfileViewController.swift
//  assignment3
//
//  Created by 小星星的三天 on 4/5/2022.
//
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var totalUnfinished: UILabel!
    @IBOutlet var totalFinished: UILabel!
    @IBOutlet var totalRepeated: UILabel!
    @IBOutlet var totalExerciseTImeCount: UILabel!
    @IBOutlet var totalExerciseCount: UILabel!
    @IBOutlet var selfImage: UIImageView!
    
    @IBOutlet var totalRightClick: UILabel!
    
    @IBOutlet var nameLabel: UILabel!
    var histories = [History]()
    var totalGameCount = 0
    var totalGameTime = 0
    var totalFinishedGame = 0
    var totalUnfinishedGame = 0
    var totalRepeat = 0
    var totalRightClicks = 0
    var name = ""
    let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        let db = Firestore.firestore()
        let historyCollection = db.collection("histories")
        historyCollection.getDocuments() { [self] (result, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                for document in result!.documents
                {
                    let conversionResult = Result
                    {
                        try document.data(as: History.self)
                    }
                    switch conversionResult
                    {
                        case .success(let convertedDoc):
//                            if var history = convertedDoc
//                            {
//                                history.id = document.documentID
                                self.histories.append(convertedDoc)
                                totalRepeat += convertedDoc.repeat
                                totalGameTime += convertedDoc.duration
                                totalGameCount += 1
                        totalRightClicks += convertedDoc.rightClick
                                if convertedDoc.completed == true{
                                    totalFinishedGame += 1
                                }else{
                                    totalUnfinishedGame += 1
                                }
                            //}
//                            else
//                            {
//                                print("Document does not exist")
//                            }
                        case .failure(let error):
                            print("Error decoding history: \(error)")
                    }
                }
                //self.tableView.reloadData()
            }
            addValues()
        // Do any additional setup after loading the view.
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
    func addValues(){
        self.totalExerciseCount.text = "\(totalGameCount) times"
        self.totalExerciseTImeCount.text = "\(totalGameTime) S"
        self.totalRepeated.text = "\(totalRepeat) rounds"
        self.totalFinished.text = "\(totalFinishedGame) times"
        self.totalUnfinished.text = "\(totalUnfinishedGame) times"
        self.totalRightClick.text = "\(totalRightClicks) times"
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "back2Main") {
            if let mainController = segue.destination as? ViewController {

            }
        }
    }
    
    
    @IBAction func takeAPicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("camera available")
        }else{
            print("no camera available")
        }
    }
    
    
    @IBAction func selectAPicture(_ sender: Any) {
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
                selfImage.image = image
                dismiss(animated: true, completion: nil)
                uploadPicture(imageURL: url)
            }
        }
        
    }
    
    func uploadPicture(imageURL: URL){
        let path = storage.child("images/\(name).png")
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
