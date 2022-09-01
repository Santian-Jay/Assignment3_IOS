//
//  History.swift
//  assignment3
//
//  Created by 小星星的三天 on 8/5/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

public struct History: Codable{
    //@DocumentID var id:String?
    var id:String = ""
    var startTime:String = ""
    var endTime:String = ""
    var `repeat`:Int = 0
    var duration:Int = 0
    var completed:Bool
    var gameMode:String
    var exercise:Int
    var rightClick:Int
    var clickedButtons:[String]?
    var clickedCountList:[String]?

//    func buttonCountToString() -> String{
//        var tempString = ""
//        for data in clickedCountList!{
//            tempString += "\(data), "
//        }
//        return tempString
//    }
    
    func listToString() -> String{
        var tempString = ""
        for data in clickedButtons!{
            tempString += "\(data), "
        }
        return tempString
    }
    
    func shareRecoed() -> String{
        let tempString = "Start at \(startTime), lasted \(duration) seconds, game mode is \(gameMode), \(`repeat`) rounds completed, finally \(completed ? "finished": "not finished") exercise."
        
        return tempString
    }
}
