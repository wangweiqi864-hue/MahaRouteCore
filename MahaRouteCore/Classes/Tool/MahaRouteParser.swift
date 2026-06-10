//
//  MahaRouteParser.swift
//  MahaRouteCore
//

import Foundation
import MahaLogCore

func mahaRouteLog<T>(_ message: T) {
    // MahaLog.record("[MahaRouteCore]---\(message)")
}

// 路由解析工具
final class MahaRouteParser {
    private static let httpPrefix = "http://"
    private static let httpsPrefix = "https://"
    private static let pathRegex = "path\\s*=\\s*\\((.*?)\\)"

    static func parse(url: String) -> MahaRouteModel? {
        let routePrefix = MahaRouteCenter.routeSchemePrefix
        if url.hasPrefix(routePrefix) == false {
            if url.hasPrefix(httpPrefix) || url.hasPrefix(httpsPrefix) {
                return MahaRouteModel(type: .open, path: url, pageType: .h5)
            }
            mahaRouteLog("parser---匹配不到协议=\(url)")
            return nil
        }

        var routeURL = url
        let routeType = parseType(url: routeURL)
        if routeType == .unavailable {
            return nil
        }

        if routeType == .open {
            routeURL = routeURL.replacingOccurrences(of: "\(routePrefix)\(routeType.rawValue)?", with: "")

            guard var path = parsePath(url: routeURL) else {
                mahaRouteLog("parser--跳转失败--path不存在--\(routeURL)")
                return nil
            }

            routeURL = routeURL.replacingOccurrences(of: "path=\(path)", with: "")
            var params: [String: String] = [:]
            let paramItems = routeURL.components(separatedBy: "&")
            for item in paramItems where item.isEmpty == false {
                let pair = item.components(separatedBy: "=")
                if pair.count == 2 {
                    params[pair[0]] = pair[1]
                }
            }

            let pageType = MahaRouteModel.parsePageType(params: params)
            var pathParams: [String: String] = [:]

            if (pageType == .h5 || pageType == .halfH5) &&
                (path.hasPrefix(httpPrefix) || path.hasPrefix(httpsPrefix)) {
                return MahaRouteModel(type: routeType, params: params, path: path, pathParams: pathParams, pageType: pageType)
            }

            if path.contains("?") {
                let items = path.components(separatedBy: "?")
                if items.count == 2 {
                    path = items[0]
                    let pathParamItems = items[1].components(separatedBy: "&")
                    for item in pathParamItems where item.isEmpty == false {
                        let pair = item.components(separatedBy: "=")
                        if pair.count == 2 {
                            pathParams[pair[0]] = pair[1]
                        }
                    }
                } else if items.count > 2 {
                    path = items[0]
                    for (index, item) in items.enumerated() where index > 0 && index != items.count - 1 {
                        path += "?" + item
                    }
                    path += "?"
                    let pathParamItems = (items.last ?? "").components(separatedBy: "&")
                    for item in pathParamItems where item.isEmpty == false {
                        let pair = item.components(separatedBy: "=")
                        if pair.count == 2 {
                            pathParams[pair[0]] = pair[1]
                        }
                    }
                }
            }

            return MahaRouteModel(type: routeType, params: params, path: path, pathParams: pathParams, pageType: pageType)
        }

        return nil
    }

    private static func parseType(url: String) -> MahaRouteActionType {
        let routePrefix = NSRegularExpression.escapedPattern(for: MahaRouteCenter.routeSchemePrefix)
        let routeTypeRegex = "^\(routePrefix)(.*?)\\?"
        if let type = match(message: url, pattern: routeTypeRegex)?.first {
            return MahaRouteActionType(rawValue: type) ?? .unavailable
        }
        return .unavailable
    }

    private static func parsePath(url: String) -> String? {
        match(message: url, pattern: pathRegex)?.first
    }
}

extension MahaRouteParser {
    private static func match(message: String, pattern: String) -> [String]? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(
                in: message,
                options: [],
                range: NSRange(message.startIndex..., in: message)
            )
            var results: [String] = []
            for match in matches {
                if let range = Range(match.range(at: 1), in: message) {
                    results.append(String(message[range]))
                }
            }
            return results
        } catch {
            print("regex 出错: \(error)")
        }
        return nil
    }
}
