//
//  MahaRouteModel.swift
//  MahaRouteCore
//

import Foundation

private let routeDynamicKey = "dynamic"
private let routeDataKey = "data"

public enum MahaRouteActionType: String {
    case unavailable = "un"
    case open = "open"
}

public enum MahaRoutePageType: String {
    case unavailable = "0"
    case h5 = "1"
    case halfH5 = "2"
    case app = "3"
}

public enum MahaRouteTokenType: String {
    case unavailable = "0"
    case xToken = "1"
    case token = "2"
    case universal = "6"
}

public enum MahaRouteLanguageType: String {
    case unavailable = "0"
    case language = "1"
}

public enum MahaRouteUserIDType: String {
    case unavailable = "0"
    case uid = "1"
}

public enum MahaRouteVersionType: String {
    case unavailable = "0"
    case version = "1"
}

public enum MahaRouteBottomSafeAreaType: String {
    case unavailable = "0"
    case has = "1"
    case none = "2"
}

public struct MahaRouteModel {
    public var type: MahaRouteActionType = .unavailable

    public var params: [String: String] = [:]
    public var path = ""
    public var pathParams: [String: String] = [:]
    public var extParam: [String: Any]?

    public var pageType: MahaRoutePageType = .unavailable

    public var tokenType: MahaRouteTokenType {
        if let dynamic = params[routeDynamicKey], dynamic.isEmpty == false {
            let characters = Array(dynamic)
            if characters.count > 1 {
                return MahaRouteTokenType(rawValue: String(characters[1])) ?? .unavailable
            }
        }
        return .unavailable
    }

    public var languageType: MahaRouteLanguageType {
        if let dynamic = params[routeDynamicKey], dynamic.isEmpty == false {
            let characters = Array(dynamic)
            if characters.count > 2 {
                return MahaRouteLanguageType(rawValue: String(characters[2])) ?? .unavailable
            }
        }
        return .unavailable
    }

    public var userIDType: MahaRouteUserIDType {
        if let dynamic = params[routeDynamicKey], dynamic.isEmpty == false {
            let characters = Array(dynamic)
            if characters.count > 3 {
                return MahaRouteUserIDType(rawValue: String(characters[3])) ?? .unavailable
            }
        }
        return .unavailable
    }

    public var versionType: MahaRouteVersionType {
        if let dynamic = params[routeDynamicKey], dynamic.isEmpty == false {
            let characters = Array(dynamic)
            if characters.count > 4 {
                return MahaRouteVersionType(rawValue: String(characters[4])) ?? .unavailable
            }
        }
        return .unavailable
    }

    public var bottomSafeAreaType: MahaRouteBottomSafeAreaType {
        if let routeData = pathParams[routeDataKey], routeData.isEmpty == false {
            let characters = Array(routeData)
            if let firstCharacter = characters.first {
                return MahaRouteBottomSafeAreaType(rawValue: String(firstCharacter)) ?? .unavailable
            }
        }
        return .unavailable
    }

    static func parsePageType(params: [String: String]) -> MahaRoutePageType {
        if let dynamic = params[routeDynamicKey], dynamic.isEmpty == false {
            let characters = Array(dynamic)
            if let firstCharacter = characters.first {
                return MahaRoutePageType(rawValue: String(firstCharacter)) ?? .unavailable
            }
        }
        return .unavailable
    }
}
