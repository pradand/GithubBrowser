//
//  ServiceProvider.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import Foundation

protocol RequestProvider {
    var httpMethod: HTTPMethod { get set }
    var endPoint: Constants.EndPoint { get set }
    var failOnNoReachability: Bool { get }
    func urlParameters() -> [URLQueryItem]
}

extension RequestProvider {
    var failOnNoReachability: Bool {
        return true
    }

    func urlParameters() -> [URLQueryItem] {
        return []
    }
}

enum HTTPMethod: String {
    case get
    case post
}

enum NetworkError {
    case URLErrorTimedOut
    case URLErrorCannotFindHost
    case URLErrorCannotConnectToHost
    case URLErrorNetworkConnectionLost
    case URLErrorDNSLookupFailed
    case URLErrorHTTPTooManyRedirects
    case URLErrorResourceUnavailable
    case URLErrorNotConnectedToInternet
    case NetworkUnrelated
}

enum URLError {
    case errorCode(_ code: Int)

    var rawValue: NetworkError {
        switch self {
        case .errorCode(let code):
            switch code {
            case -1001:
                return NetworkError.URLErrorTimedOut
            case -1003:
                return NetworkError.URLErrorCannotFindHost
            case -1004:
                return NetworkError.URLErrorCannotConnectToHost
            case -1005:
                return NetworkError.URLErrorNetworkConnectionLost
            case -1006:
                return NetworkError.URLErrorDNSLookupFailed
            case -1007:
                return NetworkError.URLErrorHTTPTooManyRedirects
            case -1008:
                return NetworkError.URLErrorResourceUnavailable
            case -1009:
                return NetworkError.URLErrorNotConnectedToInternet
            default:
                return NetworkError.NetworkUnrelated
            }
        }
    }
}

public enum CustomError: Error {
    case invalidEndpoint
    case invalidResponse
    case noData
    case networkTimeOut

    var description: String {
        switch self {
            case .invalidEndpoint:
                return NetworkStrings.invalidEndPoint
            case .invalidResponse:
                return NetworkStrings.invalidResponse
            case .noData:
                return NetworkStrings.noData
            case .networkTimeOut:
                return NetworkStrings.networkTimeOut
        }
    }
}

class ServiceProvider {

    static let shared = ServiceProvider()
    private let urlString = Constants.EndPoint.apiURLBase.literal
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()

    // MARK: - Functions
    
    func requestRouter(requestProvider: RequestProvider,
                       cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData) -> URLRequest? {

        if let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let fullURL = NSURLComponents(string: encodedURL + requestProvider.endPoint.literal) {

            fullURL.queryItems = appendQueryItems(requestProvider: requestProvider)

            if let url = fullURL.url {
                var request = URLRequest(url: url)
                var headers = request.allHTTPHeaderFields ?? [:]
                headers["Content-Type"] = "application/json"

                request.allHTTPHeaderFields = headers
                request.httpMethod = requestProvider.httpMethod.rawValue
                request.cachePolicy = cachePolicy
                return request
            }
        }

        return nil
    }

    private func appendQueryItems(requestProvider: RequestProvider) -> [URLQueryItem] {
        return requestProvider.urlParameters().compactMap({ (item) -> URLQueryItem? in
            guard item.value != nil else { return nil }
            return URLQueryItem(name: item.name, value: item.value)
        })
    }

    func setSessionConfigurationTimeoutLimit(_ timeInterval: TimeInterval) -> URLSessionConfiguration {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = timeInterval
        sessionConfiguration.timeoutIntervalForResource = timeInterval
        return sessionConfiguration
    }

    func fetch<T: Decodable>(of type: T.Type = T.self, requestProvider: RequestProvider, completion: @escaping (Result<T, CustomError>) -> ()) {

        guard Connectivity.isConnected && !requestProvider.failOnNoReachability else {
            completion(.failure(.networkTimeOut))
            return
        }

        guard let request = requestRouter(requestProvider: requestProvider, cachePolicy: Connectivity.useSafeCachePolicy) else {
            completion(.failure(.invalidEndpoint))
            return
        }

        self.dataTask(with: request, sessionConfiguration: setSessionConfigurationTimeoutLimit(10)) { [weak self] (data, response, error) in
            guard let jsonData = data else {
                if let errorCode = error?._code {
                    switch URLError.errorCode(errorCode).rawValue {
                        case .URLErrorCannotConnectToHost,
                             .URLErrorCannotFindHost,
                             .URLErrorDNSLookupFailed,
                             .URLErrorHTTPTooManyRedirects,
                             .URLErrorNetworkConnectionLost,
                             .URLErrorNotConnectedToInternet,
                             .URLErrorResourceUnavailable,
                             .URLErrorTimedOut:
                            completion(.failure(.networkTimeOut))
                        case .NetworkUnrelated:
                            completion(.failure(.noData))
                    }
                }
                return
            }

            do {
                guard let result = try self?.jsonDecoder.decode(T.self, from: jsonData) else {
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.success(result))
            } catch {
                completion(.failure(.invalidResponse))
            }
        }

    }

    public func dataTask(with request: URLRequest, sessionConfiguration: URLSessionConfiguration, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let session = URLSession(configuration: sessionConfiguration, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue.main)
        session.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }.resume()
    }

    public func dataTask(with url: URL, sessionConfiguration: URLSessionConfiguration, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let session = URLSession(configuration: sessionConfiguration, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue.main)
        session.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
}
