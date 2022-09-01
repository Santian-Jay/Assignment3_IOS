//
//  HistoryViewController.swift
//  assignment3
//
//  Created by 小星星的三天 on 4/5/2022.
//
import Firebase
import FirebaseFirestoreSwift
import UIKit

class HistoryViewController: UIViewController {
    var histories = [History]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        let db = Firestore.firestore()
//
//        //let historyCollection = db.collection("histories")
//        let historyCollection = db.collection("histories")
//        historyCollection.getDocuments() { (result, err) in
//            if let err = err
//            {
//                print("Error getting documents: \(err)")
//            }
//            else
//            {
//                for document in result!.documents
//                {
//                    let conversionResult = Result
//                    {
//                        try document.data(as: History.self)
//                    }
//                    switch conversionResult
//                    {
//                        case .success(let convertedDoc):
//                            if var history = convertedDoc
//                            {
//                                history.id = document.documentID
//                                print("History: \(history)")
//                                self.histories.append(history)
//                            }
//                            else
//                            {
//                                print("Document does not exist")
//                            }
//                        case .failure(let error):
//                            print("Error decoding history: \(error)")
//                    }
//                }
//                self.tableView.reloadData()
//                //self.view.tableView.reloadData()
//            }
        }
         
//        let matrix = History(id: "123", startTIME: "2022/05/08", endTime: "20220508", repeated: 20, duration: 60, completed: true, gameMode: "exercise1")
//        do {
//            try historyCollection.addDocument(from: matrix, completion: { (err) in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("Successfully created movie")
//                }
//            })
//        } catch let error {
//            print("Error writing city to Firestore: \(error)")
//        }
        // Do any additional setup after loading the view.
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
