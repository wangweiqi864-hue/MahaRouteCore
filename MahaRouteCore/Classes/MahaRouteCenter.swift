//
//  MahaRouteCenter.swift
//  MahaRouteCore
//

import Foundation
import UIKit

open class MahaRouteCenter {
    @discardableResult
    /// 跳转路由
    /// - Parameters:
    ///   - url: 路由地址
    ///   - navigationController: 指定跳转的导航栏控制器, 不传则内部自己处理
    ///   - params: 其他参数, 会拼接到 url 后面
    ///   - extParam: 其他参数, 用于传递额外逻辑参数
    /// - Returns: 是否跳转成功
    public static func openRoute(
        url: String,
        navigationController: UINavigationController? = nil,
        params: [String: Any]? = nil,
        extParam: [String: Any]? = nil
    ) -> Bool {
        let routeCenter = self.init()
        routeCenter.params = params
        routeCenter.extParam = extParam
        routeCenter.url = url
        routeCenter.navigationController = navigationController
        mahaRouteLog("打开---url---\(url)--params=\(params ?? [:])")
        return routeCenter.open()
    }

    public static func generateRoutePath(
        url: String,
        navigationController: UINavigationController? = nil,
        params: [String: Any]? = nil,
        extParam: [String: Any]? = nil
    ) -> String {
        let routeCenter = self.init()
        routeCenter.params = params
        routeCenter.extParam = extParam
        routeCenter.url = url
        routeCenter.navigationController = navigationController

        let isParsed = routeCenter.parse()
        if isParsed {
            return routeCenter.routeModel?.path ?? ""
        }
        return ""
    }

    private var url = ""
    private var routeModel: MahaRouteModel?
    private var params: [String: Any]?
    private var extParam: [String: Any]?
    public var navigationController: UINavigationController?

    public required init() {}

    deinit {
#if DEBUG
        debugPrint("================MahaRouteCenter销毁")
#endif
    }

    /// 跳转 h5
    open func jumpH5(routeModel: MahaRouteModel) -> Bool {
        false
    }

    /// 跳转半屏 H5
    open func jumpHalfH5(routeModel: MahaRouteModel) -> Bool {
        false
    }

    /// 跳转原生界面
    open func jumpAppPage(routeModel: MahaRouteModel) -> Bool {
        false
    }
}

extension MahaRouteCenter {
    private func parse() -> Bool {
        if let routeModel = MahaRouteParser.parse(url: url) {
            mahaRouteLog("parser---解析success--\(routeModel.path)")
            self.routeModel = routeModel
            return true
        }

        mahaRouteLog("parser---解析fail---\(url)")
        return false
    }

    private func open() -> Bool {
        let isParsed = parse()
        if isParsed {
            return startJump()
        }
        return false
    }

    private func startJump() -> Bool {
        guard var routeModel = routeModel else {
            mahaRouteLog("startJump---跳转fail--路由对象不存在")
            return false
        }
        routeModel.extParam = extParam

        if routeModel.type == .open {
            if routeModel.pageType == .h5 {
                return jumpH5(routeModel: routeModel)
            }
            if routeModel.pageType == .halfH5 {
                return jumpHalfH5(routeModel: routeModel)
            }
            if routeModel.pageType == .app {
                return jumpAppPage(routeModel: routeModel)
            }
            return false
        }
        return false
    }

    // 添加剩余参数
    public func addQueryParams(url: String) -> String {
        guard let params = params else { return url }
        var routeURL = url
        for (key, value) in params {
            guard let value = value as? String, value.isEmpty == false else {
                continue
            }

            if routeURL.last == "?" {
                routeURL += "\(key)=\(value)"
            } else if routeURL.contains("?") {
                routeURL += "&\(key)=\(value)"
            } else {
                routeURL += "?\(key)=\(value)"
            }
        }
        return routeURL
    }

    /// url 拼接参数
    public func appendingQueryParam(url: String, name: String, value: String) -> String {
        var routeURL = url
        if routeURL.last == "?" {
            routeURL += "\(name)=\(value)"
        } else if routeURL.contains("?") {
            routeURL += "&\(name)=\(value)"
        } else {
            routeURL += "?\(name)=\(value)"
        }
        return routeURL
    }
}
