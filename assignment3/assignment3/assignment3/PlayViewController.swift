//
//  PlayViewController.swift
//  assignment3
//
//  Created by 小星星的三天 on 8/5/2022.
//
import Firebase
import FirebaseFirestoreSwift
import UIKit
import grpc

class PlayViewController: UIViewController {
    var playArea:UIView = UIView(frame:CGRect(x: 0, y: 240, width:390, height:560))
    var placedButtons:[UIButton] = [UIButton]()
    var allPressed = [Bool]()
    var clickedList = [Int]()
    var buttonList = [String]()
    var buttonPressedCount = [String]()
    var endGame = false
    var numberOfButtons = 5
    var buttonSize = 60
    var isIndication = true
    var hasRepeated = 0
    var goalText = "time"
    var timeOrCount = 60
    var isRandom = true
    var xPosition = 0
    var yPosition = 0
    var offset = 0
    var totalTimeOrCount = 0
    var countDownTimer: Timer?
    var playDuration = 0
    var timeLeft = 0
    var exerciseMode = "free"
    var exerciseChoose = 1
    var tempString = ""
    var recordID = ""
    var completed = false
    var endTime = ""
    var getPoints = 0
    var rightClick = 0
    
    var targetButtons = [UIButton]()
    var dragButtons = [UIButton]()
    var targetButtonsY = [1, 120, 239, 358, 470]
    var targetButtonsX = [0, 71, 141, 231, 311]
    @IBOutlet var startTimeText: UILabel!
    @IBOutlet var durationText: UILabel!
    @IBOutlet var repeatText: UILabel!
    @IBOutlet var durationBar: UISlider!
    @IBOutlet var durationBarMappingText: UILabel!
    @IBOutlet var exeTitle: UILabel!
    @IBOutlet var h1: UILabel!
    @IBOutlet var indicationImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playArea.backgroundColor = .systemGray6
        offset = buttonSize
        timeLeft = timeOrCount
        
        self.view.addSubview(playArea)
        switch exerciseChoose{
        case 1:
            exeTitle.text = "Exercise 1"
            h1.isHidden = false
            CreateButtons()
        default:
            h1.isHidden = true
            indicationImage.image = UIImage(named: "indication")
            exeTitle.text = "Exercise 2"
            createExercise2TargetButtons()
            createExercise2DragButtons()
        }
        
        prepareGame()
        startTimer()
    }
    
    func CreateButtons(){
        for index in 1...numberOfButtons{
            let butt:UIButton = UIButton()
            butt.setTitle(String(index), for: .normal)
            butt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
            butt.tag = index
            butt.backgroundColor = .systemGray4
            clickedList.append(0)
            allPressed.append(false)
            if(index - 1 == 0 && isIndication){
                butt.backgroundColor = .systemGreen
            }
            
            playArea.addSubview(butt)
            if(index == numberOfButtons){
                butt.addTarget(self, action: #selector(click), for: .touchUpInside)
            }else if(index - 1 == 0){
                butt.addTarget(self, action: #selector(firstClick), for: .touchUpInside)
            }else{
                butt.addTarget(self, action: #selector(normalClick), for: .touchUpInside)
            }
            
            if(index - 1 == 0){
                xPosition = Int(arc4random_uniform(UInt32(Int(playArea.frame.width)) - UInt32(buttonSize + 1)) + 1)
                yPosition = Int(arc4random_uniform(UInt32(Int(playArea.frame.height)) - UInt32(buttonSize + 1)) + 1)
                butt.frame = CGRect(x:xPosition, y:yPosition, width: buttonSize,height: buttonSize)
                placedButtons.append(butt)
            }else{
                var overlapping = false
                repeat{
                    xPosition = Int(arc4random_uniform(UInt32(Int(playArea.frame.width)) - UInt32(buttonSize + 1)) + 1)
                    yPosition = Int(arc4random_uniform(UInt32(Int(playArea.frame.height)) - UInt32(buttonSize + 1)) + 1)
                    butt.frame = CGRect(x:xPosition, y:yPosition, width: buttonSize,height: buttonSize)
                    for btn in placedButtons{
                        overlapping = isOverlapping(button: btn, button1: butt)
                        if(overlapping){
                            break
                        }
                    }
                }while(overlapping)
                placedButtons.append(butt)
            }
        }
    }
    
    func isOverlapping(button: UIButton, button1:UIButton) -> Bool{
        var isOverlap = false
        let isOverlap1 = Int(button.frame.origin.x) + offset >= Int(button1.frame.origin.x) && Int(button.frame.origin.x) <= Int(button1.frame.origin.x) + offset && Int(button.frame.origin.y) + offset >= Int(button1.frame.origin.y) && Int(button.frame.origin.y) <= Int(button1.frame.origin.y) + offset
        
        let isOverlap2 = Int(button1.frame.origin.x) + offset >= Int(button.frame.origin.x) && Int(button1.frame.origin.x) <= Int(button.frame.origin.x) + offset && Int(button1.frame.origin.y) + offset >= Int(button.frame.origin.y) && Int(button1.frame.origin.y) <= Int(button.frame.origin.y) + offset
        
        if(isOverlap1 && isOverlap2){
            isOverlap = true
        }
        
        return isOverlap
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func click(sender: UIButton){
        tempString += String(numberOfButtons)
        clickedList[numberOfButtons - 1] += 1
        if(!endGame && allPressed[numberOfButtons - 2]){
            sender.isHidden = true
            hasRepeated += 1
            rightClick += 1
            print(rightClick)
            let remain = timeOrCount - hasRepeated
            repeatText.text = String(hasRepeated)
            if (exerciseMode != "free"){
                if(goalText == "repeat"){
                    durationBar.setValue(Float(remain), animated: true)
                    durationBarMappingText.text = "\(timeOrCount - hasRepeated) T remaining"
                    if hasRepeated == timeOrCount{
                        endGame = true
                        completed = true
                        gameOver()
                    }
                }
            }
            
            if(isRandom){
                setRandomPosition()
            }else{
                showButtons()
            }

        }
    }
    
    func setRandomPosition(){
        let newString = tempString
        if tempString != ""{
            buttonList.append(newString)
        }
        tempString = ""
        endGame = false
        var currentButtons = [UIButton]()
        if exerciseChoose == 1{
            for index in 0...numberOfButtons - 1{
                allPressed[index] = false
                if(index == 0){
                    placedButtons[index].frame.origin.x = CGFloat(Int(arc4random_uniform(UInt32(Int(playArea.frame.width)) - UInt32(buttonSize)) + 1))
                    placedButtons[index].frame.origin.y = CGFloat(Int(arc4random_uniform(UInt32(Int(playArea.frame.height)) - UInt32(buttonSize)) + 1))
                    placedButtons[index].isHidden = false
                    placedButtons[index].backgroundColor = .systemGray4
                    if(isIndication){
                        placedButtons[index].backgroundColor = .systemGreen
                    }
                    currentButtons.append(placedButtons[index])
                }else{
                    var overlapping = false
                    repeat{
                        placedButtons[index].frame.origin.x = CGFloat(Int(arc4random_uniform(UInt32(Int(playArea.frame.width)) - UInt32(buttonSize)) + 1))
                        placedButtons[index].frame.origin.y = CGFloat(Int(arc4random_uniform(UInt32(Int(playArea.frame.height)) - UInt32(buttonSize)) + 1))
                        for btn in currentButtons{
                            overlapping = isOverlapping(button: btn, button1: placedButtons[index])
                            if(overlapping){
                                break
                            }
                        }
                    }while(overlapping)
                    currentButtons.append(placedButtons[index])
                    placedButtons[index].isHidden = false
                    placedButtons[index].backgroundColor = .systemGray4
                }
            }
        }else{
            for index in 0...numberOfButtons - 1{
                targetButtons[index].backgroundColor = .systemGray4
                dragButtons[index].backgroundColor = .systemGray4
                allPressed[index] = false
                targetButtons[index].isHidden = false
                if(index == 0){
                    dragButtons[index].frame.origin.x = CGFloat(Int(arc4random_uniform(UInt32(Int(playArea.frame.width)) - UInt32(buttonSize + 93)) + 93))
                    dragButtons[index].frame.origin.y = CGFloat(Int(arc4random_uniform(UInt32(Int(playArea.frame.height)) - UInt32(buttonSize + 1)) + 1))
                    dragButtons[index].isHidden = false
                    currentButtons.append(dragButtons[index])
                }else{
                    var overlapping = false
                    repeat{
                        dragButtons[index].frame.origin.x = CGFloat(Int(arc4random_uniform(UInt32(Int(playArea.frame.width)) - UInt32(buttonSize + 93)) + 93))
                        dragButtons[index].frame.origin.y = CGFloat(Int(arc4random_uniform(UInt32(Int(playArea.frame.height)) - UInt32(buttonSize + 1 )) + 1))
                        for btn in currentButtons{
                            overlapping = isOverlapping(button: btn, button1: dragButtons[index])
                            if(overlapping){
                                break
                            }
                        }
                    }while(overlapping)
                    currentButtons.append(dragButtons[index])
                    dragButtons[index].isHidden = false
                }
            }
            if isIndication{
                setColor()
            }
        }
    }
    
    func showButtons(){
        let newString = tempString
        buttonList.append(newString)
        tempString = ""
        endGame = false
        
        if exerciseChoose == 1{
            for index in 0...numberOfButtons - 1{
                if(index != 0 && isIndication){
                    placedButtons[index].backgroundColor = .systemGray4
                }
                placedButtons[index].isHidden = false
                allPressed[index] = false
            }
        }else{
            for index in 0...numberOfButtons - 1{
                targetButtons[index].backgroundColor = .systemGray4
                dragButtons[index].backgroundColor = .systemGray4
                dragButtons[index].isHidden = false
                targetButtons[index].isHidden = false
                allPressed[index] = false
            }
            if isIndication{
                setColor()
            }
        }
    }
    
    @objc func firstClick(sender: UIButton){
        tempString += String(1)
        clickedList[sender.tag - 1] += 1
        rightClick += 1
        print(rightClick)
        if !endGame{
            sender.isHidden = true
            allPressed[sender.tag - 1] = true
            if(sender.tag <= numberOfButtons - 2 && isIndication){
                placedButtons[sender.tag].backgroundColor = .systemGreen
            }
        }
    }
    
    @objc func normalClick(sender: UIButton){
        tempString += String(sender.tag)
        clickedList[sender.tag - 1] += 1
        if(!endGame){
            if(sender.tag - 1 != 0 && sender.tag < numberOfButtons){
                if(allPressed[sender.tag - 2]){
                    sender.isHidden = true
                    allPressed[sender.tag - 1] = true
                    rightClick += 1
                    print(rightClick)
                    if(sender.tag <= numberOfButtons - 1 && isIndication){
                        placedButtons[sender.tag].backgroundColor = .systemGreen
                    }
                }
            }
        }
    }
    
    func currentTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyy HH:mm:ss"
        let time = format.string(from: Date())
        return time
    }
    
    func gameOver(){
        let newString = tempString
        buttonList.append(newString)
        tempString = ""
        print(buttonList)
        endTime = currentTime()
        for count in clickedList{
            buttonPressedCount.append(String(count))
        }
        print(buttonPressedCount)
        let db = Firestore.firestore()
        let historyCollection = db.collection("histories")

        historyCollection.document(recordID).updateData([
            "endTime": endTime,
            "repeat": hasRepeated,
            "duration": playDuration,
            "completed": completed,
            "rightClick": rightClick,
            "clickedButtons": buttonList,
            "clickCountList":buttonPressedCount]){
                error in
                if let error = error{
                    print("Updating record error: \(error)")
                }else{
                    print("Updatting record successfully!")
                }
            }
        self.performSegue(withIdentifier: "goToGameOverScreen", sender: nil)
    }
    
    func gameOver1(){
        let newString = tempString
        buttonList.append(newString)
        tempString = ""
        print(buttonList)
        endTime = currentTime()
        for count in clickedList{
            buttonPressedCount.append(String(count))
        }
        print(buttonPressedCount)
        let db = Firestore.firestore()
        let historyCollection = db.collection("histories")

        historyCollection.document(recordID).updateData([
            "endTime": endTime,
            "repeat": hasRepeated,
            "duration": playDuration,
            "completed": completed,
            "rightClick": rightClick,
            "clickedButtons": buttonList,
            "clickCountList":buttonPressedCount]){
                error in
                if let error = error{
                    print("Updating record error: \(error)")
                }else{
                    print("Updatting record successfully!")
                }
            }
    }
    
    func prepareGame(){
        recordID = currentTime()
        startTimeText.text = recordID
        durationText.text = "0"
        repeatText.text = "0"
        durationBar.setValue(Float(timeOrCount), animated: true)
        createHistoryRecord()
        if exerciseMode != "free"{
            switch goalText{
            case "time":
                durationBarMappingText.text = "\(timeOrCount) S remaining"
            default :
                durationBarMappingText.text = "\(timeOrCount) T remaining"
                timeLeft = 24 * 60 * 60 * 1000
            }
        }else{
            durationBar.isHidden = true
            durationBarMappingText.isHidden = true
        }
    }
    
    func createHistoryRecord(){
        let db = Firestore.firestore()
        let historyCollection = db.collection("histories")
        recordID = currentTime()
        
        historyCollection.document(recordID).setData([
            "id": recordID,
            "startTime": recordID,
            "endTime": "",
            "repeat": hasRepeated,
            "duration": playDuration,
            "completed": completed,
            "exercise": exerciseChoose,
            "gameMode": exerciseMode,
            "rightClick": rightClick,
            "clickedButtons": buttonList,
            "clickCountList":buttonPressedCount]){
                error in
                if let error = error{
                    print("Creating record error: \(error)")
                }else{
                    print("Creating record successfully!")
                }
            }
    }
    
    func startTimer(){
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTick), userInfo: nil, repeats: true)
    }
    
    @objc func onTick(){
        if(exerciseMode != "free"){
            timeLeft -= 1
            if(timeLeft >= 0){
                //durationBar.setValue(Float(timeLeft), animated: true)
                if(goalText == "time"){
                    durationBar.setValue(Float(timeLeft), animated: true)
                    durationBarMappingText.text = "\(timeLeft) S remaining"
                }
                endGame = false
                playDuration += 1
                durationText.text = String(playDuration)
            }else{
                countDownTimer?.invalidate()
                countDownTimer = nil
                endGame = true
                completed = true
                gameOver()
                self.performSegue(withIdentifier: "goToGameOverScreen", sender: nil)
            }
        }else{
            playDuration += 1
            durationText.text = String(playDuration)
        }
    }
    
    @IBAction func pauseGame(_ sender: Any) {
        countDownTimer?.fireDate = .distantFuture
        showAlertWindow()
    }
    
    func showAlertWindow(){
        let alert = UIAlertController(
            title: "Hi Dear",
            message: "Do you want to continue?",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {(action:UIAlertAction!)in
            self.gameOver()
            self.performSegue(withIdentifier: "goToGameOverScreen", sender: nil)
            }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self](action:UIAlertAction!)in
            self.countDownTimer?.fireDate = .distantPast
            }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func playToExe(_ sender: Any) {
        countDownTimer?.fireDate = .distantFuture
        showAlertWindow2()
    }
    
    func showAlertWindow2(){
        let alert = UIAlertController(
            title: "Hi Dear",
            message: "Do you want to exit?",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {(action:UIAlertAction!)in
            self.countDownTimer?.fireDate = .distantPast
            
            }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self](action:UIAlertAction!)in
            self.gameOver1()
            self.performSegue(withIdentifier: "play2exe", sender: nil)
            }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToGameOverScreen") {
            if let gameOver = segue.destination as? GameOverViewController {
                gameOver.startTime = self.recordID
                gameOver.endTime = self.endTime
                gameOver.duration = self.playDuration
                gameOver.repeated = self.hasRepeated
                gameOver.completed = self.completed
                gameOver.mode = self.exerciseMode
                gameOver.exerciseChoose = self.exerciseChoose
                gameOver.buttonClickedcount = self.clickedList
                gameOver.buttonClickedList = self.buttonList
                gameOver.numberOfButtons = self.numberOfButtons
            }
        }
    }
    
    func createExercise2TargetButtons(){
        for index in 1...5{
            let butt = UIButton()
            butt.backgroundColor = .systemGray4
            targetButtons.append(butt)
            targetButtons[index - 1].isHidden = true
            playArea.addSubview(butt)
        }
        
        targetButtons[0].frame = CGRect(x:1, y:targetButtonsY[0], width: buttonSize,height: buttonSize)
        targetButtons[0].setImage(UIImage(named: "rock"), for: .normal)
        targetButtons[0].tag = 3
        
        targetButtons[1].frame = CGRect(x:1, y:targetButtonsY[1], width: buttonSize,height: buttonSize)
        targetButtons[1].setImage(UIImage(named: "scissors"), for: .normal)
        targetButtons[1].tag = 1
        
        targetButtons[2].frame = CGRect(x:1, y:targetButtonsY[2], width: buttonSize,height: buttonSize)
        targetButtons[2].setImage(UIImage(named: "paper"), for: .normal)
        targetButtons[2].tag = 2
        
        targetButtons[3].frame = CGRect(x:1, y:targetButtonsY[3], width: buttonSize,height: buttonSize)
        targetButtons[3].setImage(UIImage(named: "rock"), for: .normal)
        targetButtons[3].tag = 2
        
        targetButtons[4].frame = CGRect(x:1, y:targetButtonsY[4], width: buttonSize,height: buttonSize)
        targetButtons[4].setImage(UIImage(named: "paper"), for: .normal)
        targetButtons[4].tag = 3
        
        for i in 0...numberOfButtons - 1{
            targetButtons[i].isHidden = false
        }
    }
    
    func createExercise2DragButtons(){
        for index in 1...5{
            let butt = UIButton()
            butt.backgroundColor = .systemGray4
            clickedList.append(0)
            allPressed.append(false)
            dragButtons.append(butt)
            dragButtons[index - 1].isHidden = true
            butt.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drag)))
            playArea.addSubview(butt)
        }
        
        dragButtons[0].frame = CGRect(x:targetButtonsX[0], y:1, width: buttonSize,height: buttonSize)
        dragButtons[0].setImage(UIImage(named: "rock"), for: .normal)
        dragButtons[0].tag = 1
        
        dragButtons[1].frame = CGRect(x:targetButtonsX[1], y:1, width: buttonSize,height: buttonSize)
        dragButtons[1].setImage(UIImage(named: "scissors"), for: .normal)
        dragButtons[1].tag = 2
        
        dragButtons[2].frame = CGRect(x:targetButtonsX[2], y:1, width: buttonSize,height: buttonSize)
        dragButtons[2].setImage(UIImage(named: "paper"), for: .normal)
        dragButtons[2].tag = 3
        
        dragButtons[3].frame = CGRect(x:targetButtonsX[3], y:1, width: buttonSize,height: buttonSize)
        dragButtons[3].setImage(UIImage(named: "paper"), for: .normal)
        dragButtons[3].tag = 3
        
        dragButtons[4].frame = CGRect(x:targetButtonsX[4], y:1, width: buttonSize,height: buttonSize)
        dragButtons[4].setImage(UIImage(named: "scissors"), for: .normal)
        dragButtons[4].tag = 2
        setRandomPosition()
    }
    
    @objc func drag(gesture: UIPanGestureRecognizer){
        //let translation = gesture.translation(in: self.view)
        let panView = gesture.view
        //print(panView?.frame)
        if gesture.state == .began{
            clickedList[panView!.tag - 1] += 1
            tempString += String(panView!.tag)
        }else if gesture.state == .changed{
            switch panView?.tag{
            case 1:
                if (panView?.frame)!.intersects(targetButtons[1].frame){
                    panView?.isHidden = true
                    targetButtons[1].isHidden = true
                    allPressed[1] = true
                }else{
                    let translation = gesture.translation(in: self.playArea)
                    panView?.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
                }
            case 2:
                if (panView?.frame)!.intersects(targetButtons[2].frame){
                    panView?.isHidden = true
                    targetButtons[2].isHidden = true
                    allPressed[2] = true
                }else if (panView?.frame)!.intersects(targetButtons[4].frame) && targetButtons[4].isHidden == false{
                    panView?.isHidden = true
                    targetButtons[4].isHidden = true
                    allPressed[4] = true
                }else{
                    let translation = gesture.translation(in: self.playArea)
                    panView?.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
                }
            default:
                if (panView?.frame)!.intersects(targetButtons[0].frame){
                    panView?.isHidden = true
                    targetButtons[0].isHidden = true
                    allPressed[0] = true
                }else if (panView?.frame)!.intersects(targetButtons[3].frame) && targetButtons[3].isHidden == false{
                    panView?.isHidden = true
                    targetButtons[3].isHidden = true
                    allPressed[3] = true
                }else{
                    let translation = gesture.translation(in: self.playArea)
                    panView?.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
                }
            }
        }else if gesture.state == .ended{
            print(allPressed)
            print(getPoints)
            if isIndication{
                setColor()
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {panView?.transform = .identity}, completion: nil)
            if checkPress() && dragButtons[numberOfButtons - 1].isHidden == true{
                hasRepeated += 1
                durationBar.setValue(Float(timeOrCount - hasRepeated), animated: true)
                if goalText == "repeat"{
                    durationBarMappingText.text = "\(timeOrCount - hasRepeated) T remaining"
                }
                
                self.repeatText.text = "\(hasRepeated)"
                
                if hasRepeated == timeOrCount{
                    endGame = true
                    gameOver()
                }
                
                if isRandom{
                    setRandomPosition()
                }else{
                    showButtons()
                }
            }
        }
    }
    
    func checkPress() -> Bool{
        var allPress = true
        for i in 0...numberOfButtons - 1{
            if !allPressed[i]{
                allPress = false
                break
            }
        }
        return allPress
    }
    
    func setColor(){
        for i in 0...numberOfButtons - 1{
            if !allPressed[i]{
                switch i{
                case 0:
                    targetButtons[0].backgroundColor = .systemGreen
                    if dragButtons[2].isHidden == false{
                        dragButtons[2].backgroundColor = .systemGreen
                    }else{
                        dragButtons[3].backgroundColor = .systemGreen
                    }
                case 1:
                    targetButtons[1].backgroundColor = .systemGreen
                    dragButtons[0].backgroundColor = .systemGreen
                case 2:
                    targetButtons[2].backgroundColor = .systemGreen
                    if dragButtons[1].isHidden == false{
                        dragButtons[1].backgroundColor = .systemGreen
                    }else{
                        dragButtons[4].backgroundColor = .systemGreen
                    }
                case 3:
                    targetButtons[3].backgroundColor = .systemGreen
                    if dragButtons[3].isHidden == false{
                        dragButtons[3].backgroundColor = .systemGreen
                    }else{
                        dragButtons[2].backgroundColor = .systemGreen
                    }
                default:
                    targetButtons[4].backgroundColor = .systemGreen
                    if dragButtons[4].isHidden == false{
                        dragButtons[4].backgroundColor = .systemGreen
                    }else{
                        dragButtons[1].backgroundColor = .systemGreen
                    }
                }
                break
            }
        }
    }
}
