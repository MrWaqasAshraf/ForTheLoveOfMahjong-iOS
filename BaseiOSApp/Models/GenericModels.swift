//
//  GenericModels.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 30/09/2025.
//

import Foundation

struct ValuesDetailModel: Codable {
    var id: Int?
}

//MARK: AnyCodableValue (Generic Datatype)
enum AnyCodableValue: Codable {
  case integer(Int)
  case string(String)
  case float(Float)
  case double(Double)
  case boolean(Bool)
  case stringArray([String])
  case userInfoModel(UserInfoData)
  case null
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let x = try? container.decode(Int.self) {
      self = .integer(x)
      return
    }
    if let x = try? container.decode(String.self) {
      self = .string(x)
      return
    }
    if let x = try? container.decode(Float.self) {
      self = .float(x)
      return
    }
    if let x = try? container.decode(Double.self) {
      self = .double(x)
      return
    }
    if let x = try? container.decode(Bool.self) {
      self = .boolean(x)
      return
    }
    if let x = try? container.decode(String.self) {
      self = .string(x)
      return
    }
    if let x = try? container.decode([String].self) {
      self = .stringArray(x)
      return
    }
      if let x = try? container.decode(UserInfoData.self) {
          self = .userInfoModel(x)
        return
      }
    if container.decodeNil() {
      self = .string("")
      return
    }
    throw DecodingError.typeMismatch(AnyCodableValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type"))
  }
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .integer(let x):
      try container.encode(x)
    case .string(let x):
      try container.encode(x)
    case .float(let x):
      try container.encode(x)
    case .double(let x):
      try container.encode(x)
    case .boolean(let x):
      try container.encode(x)
    case .stringArray(let x):
      try container.encode(x)
    case .userInfoModel(let x):
      try container.encode(x)
    case .null:
      try container.encode(self)
      break
    }
  }
  //Get safe Values
  var stringValue: String {
    switch self {
    case .string(let s):
      return s
    case .integer(let s):
      return "\(s)"
    case .double(let s):
      return "\(s)"
    case .float(let s):
      return "\(s)"
    case .stringArray(let s):
      return s.joined(separator: ", ")
    case .userInfoModel(let s):
      return "\(s)"
    default:
      return ""
    }
  }
  var intValue: Int {
    switch self {
    case .integer(let s):
      return s
    case .string(let s):
      return (Int(s) ?? 0)
    case .float(let s):
      return Int(s)
    case .userInfoModel(let s):
      return Int(s.id ?? "") ?? 0
    case .null:
      return 0
    default:
      return 0
    }
  }
  var floatValue: Float {
    switch self {
    case .float(let s):
      return s
    case .integer(let s):
      return Float(s)
    case .string(let s):
      return (Float(s) ?? 0)
    case .userInfoModel(let s):
        return Float(s.id ?? "") ?? 0
    default:
      return 0
    }
  }
  var doubleValue: Double {
    switch self {
    case .double(let s):
      return s
    case .string(let s):
      return (Double(s) ?? 0.0)
    case .integer(let s):
      return (Double(s))
    case .float(let s):
      return (Double(s))
    case .userInfoModel(let s):
        return Double(s.id ?? "") ?? 0
    default:
      return 0.0
    }
  }
    
    var userInfoModel: UserInfoData {
      switch self {
      case .double(let s):
        return UserInfoData(id: nil, firstName: nil, lastName: nil)
      case .string(let s):
        return UserInfoData(id: nil, firstName: nil, lastName: nil)
      case .integer(let s):
        return UserInfoData(id: nil, firstName: nil, lastName: nil)
      case .float(let s):
        return UserInfoData(id: nil, firstName: nil, lastName: nil)
      case .userInfoModel(let s):
          return s
      default:
          return UserInfoData(id: nil, firstName: nil, lastName: nil)
      }
    }
    
  var booleanValue: Bool {
    switch self {
    case .boolean(let s):
      return s
    case .integer(let s):
      return s == 1
    case .string(let s):
      let bool = (Int(s) ?? 0) == 1
      return bool
    default:
      return false
    }
  }
  var stringArrayValue: [String] {
    switch self {
    case .boolean(_):
      return []
    case .integer(_):
      return []
    case .string(let s):
      return [s]
    default:
      return []
    }
  }
}
