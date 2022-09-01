//
//  ExerciseViewController.swift
//  assignment3
//
//  Created by 小星星的三天 on 4/5/2022.
//

import UIKit

class ExerciseViewController: UIViewController {

    @IBOutlet var buttonNumbersText: UILabel!
    @IBOutlet var goalText: UILabel!
    
    var exerciseMode: String = "free"
    var goal:String = "time"
    var timeOrrepeat: Int = 60
    var exerciseChoose: Int = 1
    var isRandom: Bool = true
    var isIndication: Bool = true
    var buttonSize: Int = 60
    var numerOfButtons = 3
    
    @IBOutlet var h2: UILabel!
    @IBOutlet var subtitle: UILabel!
    
    @IBOutlet var freeModeButton: UIButton!
    @IBOutlet var targetModeButton: UIButton!
    @IBOutlet var timeGoalButton: UIButton!
    @IBOutlet var repeatGoalButton: UIButton!
    @IBOutlet var slider: UISlider!
    @IBOutlet var exercise1Button: UIButton!
    @IBOutlet var exercise2Button: UIButton!
    @IBOutlet var numberOfButtonSlider: UISlider!
    @IBOutlet var sBUTTON: UIButton!
    @IBOutlet var mButton: UIButton!
    @IBOutlet var lButton: UIButton!
    @IBOutlet var goalUnit: UILabel!
    @IBOutlet var add10: UIButton!
    @IBOutlet var add30: UIButton!
    @IBOutlet var add60: UIButton!
    @IBOutlet var h3: UILabel!
    @IBOutlet var h4: UILabel!
    @IBOutlet var text1: UILabel!
    @IBOutlet var text2: UILabel!
    @IBOutlet var text3: UILabel!
    @IBOutlet var text4: UILabel!
    @IBOutlet var h5: UILabel!
    @IBOutlet var switch1: UISwitch!
    @IBOutlet var switch2: UISwitch!
    @IBOutlet var minus: UIButton!
    @IBOutlet var add: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalText.text = String(timeOrrepeat)
        buttonNumbersText.text = String(numerOfButtons)
        slider.setValue(Float(timeOrrepeat), animated: true)
        moveUp()
    }
    
    @IBAction func targetModeButton(_ sender: UIButton) {
        freeModeButton.isSelected = false
        targetModeButton.isSelected = true
        exerciseMode = "target"
        print(exerciseMode)
        moveDown()
    }
    @IBAction func freeModeButton(_ sender: UIButton) {
        targetModeButton.isSelected = false
        freeModeButton.isSelected = true
        exerciseMode = "free"
        moveUp()
    }
    
    @IBAction func timeGoalButton(_ sender: Any) {
        repeatGoalButton.isSelected = false
        timeGoalButton.isSelected = true
        goal = "time"
        goalUnit.text = "S"
        print(goal)
    }
    @IBAction func repeatGoalButton(_ sender: Any) {
        repeatGoalButton.isSelected = true
        timeGoalButton.isSelected = false
        goal = "repeat"
        goalUnit.text = "T"
        print(goal)
    }
    
    @IBAction func add10SButton(_ sender: Any) {
        if(timeOrrepeat < 300){
            timeOrrepeat += 10
            if(timeOrrepeat > 300){
                timeOrrepeat = 300
            }
        }
        goalText.text = String(timeOrrepeat)
        slider.setValue(Float(timeOrrepeat), animated: true)
    }
    
    @IBAction func add30SButton(_ sender: Any) {
        if(timeOrrepeat < 300){
            timeOrrepeat += 30
            if(timeOrrepeat > 300){
                timeOrrepeat = 300
            }
        }
        goalText.text = String(timeOrrepeat)
        slider.setValue(Float(timeOrrepeat), animated: true)
    }
    
    @IBAction func add60SButton(_ sender: Any) {
        if(timeOrrepeat < 300){
            timeOrrepeat += 60
            if(timeOrrepeat > 300){
                timeOrrepeat = 300
            }
        }
        goalText.text = String(timeOrrepeat)
        slider.setValue(Float(timeOrrepeat), animated: true)
    }
    
    @IBAction func exercise1Button(_ sender: Any) {
        exercise2Button.isSelected = false
        exercise1Button.isSelected = true
        exerciseChoose = 1
        print(exerciseChoose)
    }
    
    @IBAction func exercise2Button(_ sender: Any) {
        exercise2Button.isSelected = true
        exercise1Button.isSelected = false
        exerciseChoose = 2
        print(exerciseChoose)
    }
    
    @IBAction func minusButton(_ sender: Any) {
        if(numerOfButtons > 3){
            numerOfButtons -= 1
            numberOfButtonSlider.setValue(Float(numerOfButtons), animated: true)
        }else{
            numerOfButtons = 3
        }

        buttonNumbersText.text = String(numerOfButtons)
    }
    
    @IBAction func addButton(_ sender: Any) {
        if(numerOfButtons < 5){
            numerOfButtons += 1
            numberOfButtonSlider.setValue(Float(numerOfButtons), animated: true)
        }else{
            numerOfButtons = 5
        }

        buttonNumbersText.text = String(numerOfButtons)
    }
    
    @IBAction func sButton(_ sender: UIButton) {
        sBUTTON.isSelected = true
        mButton.isSelected = false
        lButton.isSelected = false
        buttonSize = 60
        print(buttonSize)
    }
    
    @IBAction func mButton(_ sender: UIButton) {
        sBUTTON.isSelected = false
        mButton.isSelected = true
        lButton.isSelected = false
        buttonSize = 70
        print(buttonSize)
    }
    
    @IBAction func lButton(_ sender: UIButton) {
        sBUTTON.isSelected = false
        mButton.isSelected = false
        lButton.isSelected = true
        buttonSize = 90
        print(buttonSize)
    }
    
    @IBAction func goalChangeBar(_ sender: UISlider) {
        timeOrrepeat = Int(sender.value)
        goalText.text = String(timeOrrepeat)
    }
    
    @IBAction func buttonNumbersBar(_ sender: UISlider) {
        numerOfButtons = Int(sender.value)
        buttonNumbersText.text = String(numerOfButtons)
    }
    
    
    @IBAction func randomSwitch(_ sender: UISwitch) {
        isRandom = sender.isOn
        print(isRandom)
    }
    
    @IBAction func indicationSwitch(_ sender: UISwitch) {
        isIndication = sender.isOn
        print(isIndication)
    }
    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func toPlayScreen(_ sender: Any) {
        self.performSegue(withIdentifier: "toPlay", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toPlay") {
            if let play = segue.destination as? PlayViewController {
                play.timeOrCount = self.timeOrrepeat
                play.goalText = self.goal
                play.numberOfButtons = self.numerOfButtons
                play.buttonSize = self.buttonSize
                play.isRandom = self.isRandom
                play.isIndication = self.isIndication
                play.exerciseMode = self.exerciseMode
                play.exerciseChoose = self.exerciseChoose
            }
        }
    }
    
    @IBAction func unwindToExerciseWithCancel(sender: UIStoryboardSegue)
    {
    }
    
    func moveUp(){
        goalText.isHidden = true
        h2.isHidden = true
        subtitle.isHidden = true
        timeGoalButton.isHidden = true
        timeGoalButton.isEnabled = true
        repeatGoalButton.isEnabled = true
        repeatGoalButton.isHidden = true
        slider.isHidden = true
        add10.isHidden = true
        add30.isHidden = true
        add60.isHidden = true
        goalUnit.isHidden = true
        print(exerciseMode)

        h3.frame.origin.y = 160
        exercise1Button.frame.origin.y = 195
        exercise2Button.frame.origin.y = 195
        h4.frame.origin.y = 252
        text1.frame.origin.y = 293
        text2.frame.origin.y = 293
        switch1.frame.origin.y = 293
        switch2.frame.origin.y = 293
        text3.frame.origin.y = 333
        text4.frame.origin.y = 333
        buttonNumbersText.frame.origin.y = 333
        minus.frame.origin.y = 370
        add.frame.origin.y = 370
        numberOfButtonSlider.frame.origin.y = 370
        h5.frame.origin.y = 420
        sBUTTON.frame.origin.y = 484
        mButton.frame.origin.y = 474
        lButton.frame.origin.y = 454
    }
    
    func moveDown(){
        goalText.isHidden = false
        h2.isHidden = false
        subtitle.isHidden = false
        timeGoalButton.isHidden = false
        repeatGoalButton.isHidden = false
        slider.isHidden = false
        add10.isHidden = false
        add30.isHidden = false
        add60.isHidden = false
        goalUnit.isHidden = false
        
        h3.frame.origin.y = 335
        exercise1Button.frame.origin.y = 372
        exercise2Button.frame.origin.y = 372
        h4.frame.origin.y = 432
        text1.frame.origin.y = 473
        text2.frame.origin.y = 473
        switch1.frame.origin.y = 473
        switch2.frame.origin.y = 473
        text3.frame.origin.y = 513
        text4.frame.origin.y = 513
        buttonNumbersText.frame.origin.y = 513
        minus.frame.origin.y = 550
        add.frame.origin.y = 550
        numberOfButtonSlider.frame.origin.y = 550
        h5.frame.origin.y = 600
        sBUTTON.frame.origin.y = 664
        mButton.frame.origin.y = 654
        lButton.frame.origin.y = 634
    }
    
}
