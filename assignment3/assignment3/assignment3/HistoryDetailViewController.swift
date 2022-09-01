//
//  HistoryDetailViewController.swift
//  assignment3
//
//  Created by 小星星的三天 on 9/5/2022.
//
import Firebase
import FirebaseFirestoreSwift
import UIKit

class HistoryDetailViewController: UIViewController {
    @IBOutlet var dStartTime: UILabel!
    @IBOutlet var dEndTime: UILabel!
    @IBOutlet var dDuration: UILabel!
    @IBOutlet var dRepeated: UILabel!
    @IBOutlet var dCompleted: UILabel!
    @IBOutlet var dMode: UILabel!
    @IBOutlet var dImage: UIImageView!
    @IBOutlet var dList: UITextView!
    @IBOutlet var dExerciseChoose: UILabel!
    @IBOutlet var dClickedCount: UILabel!
    @IBOutlet var listview: UITextView!
    
    var history: History?
    var historyIndex: Int?
    var deleteIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let displayHistory = history
            {
                //self.navigationItem.title = displayMovie.title //this awesome line sets the page title
            self.dStartTime.text = "Start Time: \(displayHistory.startTime)"
            self.dEndTime.text = "End Time: \(displayHistory.endTime)"
            self.dDuration.text = "Duration: \(String(displayHistory.duration))"
            self.dRepeated.text = "Repeated: \(String(displayHistory.repeat))"
            self.dCompleted.text = "Completed: \(String(displayHistory.completed))"
            self.dMode.text = "Exercise Mode: \(String(displayHistory.gameMode))"
            self.dClickedCount.text = "Total correctly clicked :\(String(displayHistory.rightClick))"
            self.dList.text = "Buttons Clicked Order: \(String(describing: displayHistory.listToString()))"
            //self.dList.text = "Buttons Clicked Order: \(String(describing: displayHistory.clickedButtons))"
            self.dExerciseChoose.text = "Exercise: exercise\(String(describing: displayHistory.exercise))"
            //self.listview.text = "Buttons Clicked Order: \(String(describing: displayHistory.buttonCountToString()))"
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
    @IBAction func shareHistory(_ sender: Any) {
        shareRecord()
    }
    
    @IBAction func deleteHistory(_ sender: Any) {
        showAlertWindow()
        //deleteRecord()
    }
    @IBAction func cancel(_ sender: Any) {
        self.performSegue(withIdentifier: "detailToHistory", sender: nil)
    }
    
    func showAlertWindow(){
        let alert = UIAlertController(
            title: "Hi Dear",
            message: "Are you sure you want to delete this record?",
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {(action:UIAlertAction!)in
            //self.performSegue(withIdentifier: "goToGameOverScreen", sender: nil)
            }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self](action:UIAlertAction!)in
            deleteRecord()
            }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteRecord(){
        let db = Firestore.firestore()
        
        let historyCollection = db.collection("histories")
        let id = history?.id
        
        historyCollection.document(id!).delete(){ err in
            if let err = err {
                print("Error deleting record: \(err)")
            }else{
                print("Deleting record successfully!")
                self.performSegue(withIdentifier: "deleteSegue", sender: nil)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "back2history") {
            if let historyController = segue.destination as? HistoryUITableViewController {
                //historyController.deleteIndex = self.deleteIndex
                historyController.deleteIndex = self.historyIndex ?? 0
            }
        }
    }
    
    func shareRecord(){
        let tempString = history?.shareRecoed()
        
        let shareViewController = UIActivityViewController(activityItems: [tempString], applicationActivities: [])
        
        present(shareViewController, animated: true, completion: nil)
    }
}
