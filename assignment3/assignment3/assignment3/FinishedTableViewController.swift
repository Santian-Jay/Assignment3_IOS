//
//  FinishedTableViewController.swift
//  assignment3
//
//  Created by 小星星的三天 on 9/5/2022.
//
import Firebase
import FirebaseFirestoreSwift
import UIKit

class FinishedTableViewController: UITableViewController {
    var fhistories = [History]()
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
                            //if var history = convertedDoc
                            //{
                                //history.id = document.documentID
                                //print("History: \(history)")
                                if(convertedDoc.completed == true){
                                    self.fhistories.append(convertedDoc)
                                }
                            //}
                            //else
                            //{
                               // print("Document does not exist")
                            //}
                        case .failure(let error):
                            print("Error decoding history: \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fhistories.count
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

        //get the movie for this row
        let history = fhistories[indexPath.row]

        //down-cast the cell from UITableViewCell to our cell class MovieUITableViewCell
        //note, this could fail, so we use an if let.
        if let historyCell = cell as? HistoryUITableViewCell
        {
            //populate the cell
            historyCell.fStartTime.text = "Start Time: \(history.startTime)"
            historyCell.fEndTime.text = "End Time: \(history.endTime)"
            historyCell.fDuration.text = "Duration: \(String(history.duration))"
            historyCell.fRound.text = "Repeated: \(String(history.repeat))"
            historyCell.fCompleted.text = "Completed: \(String(history.completed))"
            
//            historyCell.start.text = "Start Time: \(history.startTime)"
//            historyCell.end.text = "End Time: \(history.endTime)"
//            historyCell.dura.text = "Duration: \(String(history.duration))"
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
              let selectedHistory = fhistories[indexPath.row]

              //send it to the details screen
              detailViewController.history = selectedHistory
              detailViewController.historyIndex = indexPath.row
        }
    }
}
