//
//  BenchmarkModel.swift
//
//
//  Created by Christoph Weinhuber on 10.01.23.
//

import Foundation

public enum NetworkAction : Encodable {
    case received(data: Int)
    case sent(data: Int)
}

public class NetworkSnapshot : Encodable {
    let date : Date
    let type : NetworkAction
    
    init(date: Date = Date(), type: NetworkAction) {
        self.date = date
        self.type = type
    }
}

public class BatterySnapshot : Encodable {
    let batteryLevel : Int
    let date : Date
    
    init(batteryLevel: Int, date: Date = Date()) {
        self.batteryLevel = batteryLevel
        self.date = date
    }
}

public class ActionSnaptshot : Encodable {
    let action : String
    let date : Date
    
    public init(action: String, date: Date = Date()) {
        self.action = action
        self.date = date
    }
}

public enum BatteryState : Encodable {
    case unplugged
    case charging
    case full
    case unknown
}


public class BenchmarkSnaptshot : Encodable {
    private var batteryHistory : [BatterySnapshot] = []
    
    private var networkHistory : [NetworkSnapshot] = []
    
    
    private var actionHistory : [ActionSnaptshot] = []
    
    private var deviceID: String = ""
    
    init(batteryHistory : [BatterySnapshot], networkHistory : [NetworkSnapshot], actionHistory : [ActionSnaptshot], deviceID : String) {
        self.batteryHistory = batteryHistory
        self.networkHistory = networkHistory
        self.actionHistory = actionHistory
        self.deviceID = deviceID
    }
    
}
