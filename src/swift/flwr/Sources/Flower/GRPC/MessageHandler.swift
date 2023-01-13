//
//  MessageHandler.swift
//  FlowerSDK
//
//  Created by Daniel Nugraha on 09.01.22.
//

import Foundation

func handle(client: Client, serverMsg: Flwr_Proto_ServerMessage) throws -> (Flwr_Proto_ClientMessage, Int, Bool) {
    switch serverMsg.msg {
    case .reconnectIns:
        let tuple = reconnect(reconnectMsg: serverMsg.reconnectIns)
        let disconnectMsg = tuple.0
        let sleepDuration = tuple.1
        return (disconnectMsg, sleepDuration, false)
    case .getParametersIns:
        return (getParameters(client: client), 0, true)
    case .fitIns:
        return (fit(client: client, fitMsg: serverMsg.fitIns), 0, true)
    case .evaluateIns:
        return (evaluate(client: client, evaluateMsg: serverMsg.evaluateIns), 0, true)
    case .getPropertiesIns:
        return (getProperties(client: client, propertiesMsg: serverMsg.getPropertiesIns), 0, true)
    default:
        throw FlowerException.UnknownServerMessage
    }
}

func reconnect(reconnectMsg: Flwr_Proto_ServerMessage.ReconnectIns) -> (Flwr_Proto_ClientMessage, Int) {
    var reason: Flwr_Proto_Reason = .ack
    var sleepDuration: Int = 0
    if reconnectMsg.seconds != 0 {
        reason = .reconnect
        sleepDuration = Int(reconnectMsg.seconds)
    } else {
        if #available(iOS 14.0, *) {
            ParameterConverter.shared.finalize()
        }
    }
    var disconnect = Flwr_Proto_ClientMessage.DisconnectRes()
    disconnect.reason = reason
    var ret = Flwr_Proto_ClientMessage()
    ret.disconnectRes = disconnect
    return (ret, sleepDuration)
 }

func getParameters(client: Client) -> Flwr_Proto_ClientMessage {
    let parametersRes = client.getParameters()
    let parametersResProto = parametersResToProto(res: parametersRes)
    var ret = Flwr_Proto_ClientMessage()
    ret.getParametersRes = parametersResProto
    return ret
}

func getProperties(client: Client, propertiesMsg: Flwr_Proto_ServerMessage.GetPropertiesIns) -> Flwr_Proto_ClientMessage {
    let propertiesIns = propertiesInsFromProto(msg: propertiesMsg)
    let propertiesRes = client.getProperties(ins: propertiesIns)
    let propertiesResProto = propertiesResToProto(res: propertiesRes)
    var ret = Flwr_Proto_ClientMessage()
    ret.getPropertiesRes = propertiesResProto
    return ret
}

func fit(client: Client, fitMsg: Flwr_Proto_ServerMessage.FitIns) -> Flwr_Proto_ClientMessage {
    let fitIns = fitInsFromProto(msg: fitMsg)
    let fitRes = client.fit(ins: fitIns)
    let fitResProto = fitResToProto(res: fitRes)
    var ret = Flwr_Proto_ClientMessage()
    ret.fitRes = fitResProto
    return ret
}

func evaluate(client: Client, evaluateMsg: Flwr_Proto_ServerMessage.EvaluateIns) -> Flwr_Proto_ClientMessage {
    let evaluateIns = evaluateInsFromProto(msg: evaluateMsg)
    let evaluateRes = client.evaluate(ins: evaluateIns)
    let evaluateResProto = evaluateResToProto(res: evaluateRes)
    var ret = Flwr_Proto_ClientMessage()
    ret.evaluateRes = evaluateResProto
    return ret
}
