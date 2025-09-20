//
//  AppLogger.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 05/08/2025.
//

import Foundation

enum AppLogger{
    
    enum LogType{
        case info
        case warning
        case error
        case network
        case api
        case general
        
        fileprivate var prefix: String{
            switch self{
            case .info:
                return "INFO"
            case .warning:
                return "WARNING"
            case .error:
                return "ERROR ALERT"
            case .network:
                return "NETWORK ALERT"
            case .api:
                return "API"
            case .general:
                return ""
            }
        }
    }
    
    struct Context{
        let file: String
        let function: String
        let line: Int
        var description: String{
            return "\((file as NSString).lastPathComponent):\(line) \(function)"
        }
    }
    
    static func info(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line){
        let context = Context(file: file, function: function, line: line)
        AppLogger.handleLog(logType: .info, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    static func warning(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line){
        let context = Context(file: file, function: function, line: line)
        AppLogger.handleLog(logType: .warning, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    static func error(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line){
        let context = Context(file: file, function: function, line: line)
        AppLogger.handleLog(logType: .error, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    static func network(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line){
        let context = Context(file: file, function: function, line: line)
        AppLogger.handleLog(logType: .network, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    static func api(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line){
        let context = Context(file: file, function: function, line: line)
        AppLogger.handleLog(logType: .api, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    static func general(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line){
        let context = Context(file: file, function: function, line: line)
        AppLogger.handleLog(logType: .general, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    static func all(_ info: Any, file: String = #file, function: String = #function, line: Int = #line){
        let context = Context(file: file, function: function, line: line)
        handleAllPrint(info: "\(info) -> \(context.description)")
    }
    
    fileprivate static func handleAllPrint(info: Any){
//        #if DEBUG
        print(info)
//        #endif
    }
    
    fileprivate static func handleLog(logType: LogType, str: String, shouldLogContext: Bool, context: Context){
        let logCompinents = ["[\(logType.prefix)]", str]
        var fullString = logCompinents.joined(separator: " ")
        if shouldLogContext{
            fullString += " -> \(context.description)"
        }
        
        handleAllPrint(info: fullString)
    }
    
}
