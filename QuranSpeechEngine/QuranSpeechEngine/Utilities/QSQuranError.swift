// //swiftlint:disable:this file_header
//  QSNetworkError.swift
//  SwinjectMVVMExample
//
//  Created by Yoichi Tagaya on 8/22/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import Foundation

protocol QSQuranError: Error {
  // This is a workaround to `localizedDescription` as it was not calling our implementation
  // and instead uses system default implementation of `localizedDescription`.
  var localizedDescriptionv2: String { get }
}

public enum QSNetworkError: QSQuranError {
    /// Unknown or not supported error.
    case unknown(Error)

    /// Not connected to the internet.
    case notConnectedToInternet

    /// International data roaming turned off.
    case internationalRoamingOff

    /// Connection is lost.
    case connectionLost

    /// Cannot reach the server.
    case serverNotReachable

    case parsing(String)

    case serverError(String)

    internal init(error: Error) {
        if let error = error as? QSNetworkError {
            self = error
        } else if let error = error as? URLError {
            switch error.code {
            case .timedOut, .cannotFindHost, .cannotConnectToHost:
                self = .serverNotReachable
            case .networkConnectionLost:
                self = .connectionLost
            case .dnsLookupFailed:
                self = .serverNotReachable
            case .notConnectedToInternet:
                self = .notConnectedToInternet
            case .internationalRoamingOff:
                self = .internationalRoamingOff
            default:
                self = .unknown(error)
            }
        } else {
            self = .unknown(error)
        }
    }

    public var localizedDescriptionv2: String {
        let text: String
        switch self {
        case .unknown:
            text = NSLocalizedString("QSNetworkError_Unknown", comment: "Error description")
        case .serverError:
            text = NSLocalizedString("QSNetworkError_Unknown", comment: "Error description")
        case .notConnectedToInternet:
            text = NSLocalizedString("QSNetworkError_NotConnectedToInternet", comment: "Error description")
        case .internationalRoamingOff:
            text = NSLocalizedString("QSNetworkError_InternationalRoamingOff", comment: "Error description")
        case .serverNotReachable:
            text = NSLocalizedString("QSNetworkError_ServerNotReachable", comment: "Error description")
        case .connectionLost:
            text = NSLocalizedString("QSNetworkError_ConnectionLost", comment: "Error description")
        case .parsing:
            text = NSLocalizedString("QSNetworkError_Parsing", comment: "When a parsing error occurs")
        }
        return text
    }
}
