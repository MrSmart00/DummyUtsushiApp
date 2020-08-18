{% include "Includes/Header.stencil" %}

import Foundation
import Moya

private func JSONResponseDataFormatter(data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data, options: [])
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

public enum AbstractTarget: TargetType {
    case target(TargetType, Data, URL?)

    public init(_ target: TargetType, _ data: Data = .init(), _ baseURL: URL? = nil) {
        self = .target(target, data, baseURL)
    }

    public var path: String {
        target.path
    }

    public var baseURL: URL {
        switch self {
        case let .target(_, _, url): return url ?? target.baseURL
        }
    }

    public var method: Moya.Method {
        target.method
    }

    public var sampleData: Data {
        switch self {
        case let .target(_, data, _): return data
        }
    }

    public var task: Task {
        target.task
    }

    public var validationType: ValidationType {
        target.validationType
    }

    public var headers: [String: String]? {
        target.headers
    }

    public var target: TargetType {
        switch self {
        case let .target(target, _, _): return target
        }
    }
}

extension AbstractTarget: AccessTokenAuthorizable {
    public var authorizationType: AuthorizationType? {
        if let _target = target as? AccessTokenAuthorizable {
            return _target.authorizationType
        } else {
            return .none
        }
    }
}