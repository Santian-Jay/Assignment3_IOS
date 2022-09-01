//
//  HistoryUITableViewController.swift
//  assignment3
//
//  Created by 小星星的三天 on 8/5/2022.
//
import Firebase
import FirebaseFirestoreSwift
import UIKit

class HistoryUITableViewController: UITableViewController {
    var histories = [History]()
    var deleteIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        
        let historyCollection = db.collection("histories")
        historyCollection.getDocuments() { (result, err) in
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
                                //print("History: \(history)")
                                self.histories.append(convertedDoc)
//                            }
//                            else
//                            {
//                                print("Document does not exist")
//                            }
                        case .failure(let error):
                            print("Error decoding history: \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return histories.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryUITableViewCell", for: indexPath)

        //get the history for this row
        let history = histories[indexPath.row]

        //down-cast the cell from UITableViewCell to our cell class HistoryUITableViewCell
        //note, this could fail, so we use an if let.
        if let historyCell = cell as? HistoryUITableViewCell
        {
            //populate the cell
            historyCell.startTime.text = "Start Time: \(history.startTime)"
            historyCell.endTime.text = "End Time: \(history.endTime)"
            historyCell.duration.text = "Duration: \(String(history.duration))"
            historyCell.round.text = "Repeated: \(String(history.repeat))"
            historyCell.completed.text = "Completed: \(String(history.completed))"
            
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        // is this the segue to the details screen? (in more complex apps, there is more than one segue per screen)
        if segue.identifier == "ShowHistoryDetailSegue"
        {
              //down-cast from UIViewController to DetailViewController (this could fail if we didn’t link things up properly)
              guard let detailViewController = segue.destination as? HistoryDetailViewController else
              {
                  fatalError("Unexpected destination: \(segue.destination)")
              }

              //down-cast from UITableViewCell to MovieUITableViewCell (this could fail if we didn’t link things up properly)
              guard let selectedHistoryCell = sender as? HistoryUITableViewCell else
              {
                  fatalError("Unexpected sender: \( String(describing: sender))")
              }

              //get the number of the row that was pressed (this could fail if the cell wasn’t in the table but we know it is)
              guard let indexPath = tableView.indexPath(for: selectedHistoryCell) else
              {
                  fatalError("The selected cell is not being displayed by the table")
              }

              //work out which movie it is using the row number
              let selectedHistory = histories[indexPath.row]

              //send it to the details screen
              detailViewController.history = selectedHistory
              detailViewController.historyIndex = indexPath.row
        }
    }
    
    @IBAction func unwindToHistoryList(sender: UIStoryboardSegue)
    {
        //we could reload from db, but lets just trust the local movie object
            if let detailScreen = sender.source as? HistoryDetailViewController
            {
                histories[detailScreen.historyIndex!] = detailScreen.history!
                histories.remove(at: deleteIndex)
                self.tableView.reloadData()
            }
    }

    @IBAction func unwindToHistoryListWithCancel(sender: UIStoryboardSegue)
    {
    }
}
