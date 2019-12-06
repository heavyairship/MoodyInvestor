//
//  AlphaVantageService.swift
//  MoodyInvestor
//
//  Created by Andrew Fichman on 12/3/19.
//  Copyright © 2019 Andrew Fichman. All rights reserved.
//

import UIKit

// MARK: Protocols
/// Protocol abstraction of common rest api characteristics
protocol RestApi {
    var host : String { get }
    var scheme : String { get }
    var basePath : String { get }
    var requiredParameters : Array<URLQueryItem> { get }
}

/// Represents a specifc request to a RestAPI, requires class as responseJSON is mutable
protocol ApiRequest : class {
    var method : String { get }
    var path : String { get }
    var queryStringParameters : Array<URLQueryItem> { get }
    var api : RestApi { get }
    var responseJSON : [String : Any]? { get set }
}

// MARK: Extensions
extension ApiRequest {
    
    /// Constructs the full url for the ApiRequest
    ///
    /// - Returns: an optional url for the specific request
    private func buildUrl() -> URL? {
        var components = URLComponents()
        components.scheme = api.scheme
        components.host = api.host
        components.path = api.basePath + path
        components.queryItems = queryStringParameters + api.requiredParameters
        return components.url
    }
    
    /// Creates the request object used to call the RestApi
    ///
    /// - Returns: the request object for a specific ApiRequest
    private func createRequest() -> URLRequest? {
        guard let url = buildUrl() else {
            print(URLError(URLError.Code.badURL))
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }
    
    /// Receives the result of the asynchronous call to the rest api and stores in
    /// the instancd variable `responseJSON`
    ///
    /// - Parameter data: the payload of the response from the rest api
    public func receiveResponse(_ data : Data?) {
        guard let responseData = data else {
            print("No data received from server, \(String(describing: api.host))")
            return
        }
        do {
            guard let results = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                print("Cannot unwrap JSON response, \(String(describing: api.host))")
                return
            }
            responseJSON = results
        }
        catch {
            print("Cannot decode JSON response, \(String(describing: api.host))")
            return
        }
    }
    
    /// Makes asynchronous call to fetch response from server, stores response on self
    ///
    /// - Returns: self to allow for chained method calls
    public func callApi() -> ApiRequest {
        guard let apiRequest = createRequest() else {
            print("No Request to make")
            return self
        }
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        let sem = DispatchSemaphore(value: 0)
        let dataTask = session.dataTask(with: apiRequest) {(data, response, error) in
            defer { sem.signal() }
            guard error == nil else {
                print("Error Reaching API, \(String(describing: apiRequest.url))")
                return
            }
            self.receiveResponse(data)
        }
        dataTask.resume()
        let _ = sem.wait(timeout: DispatchTime.distantFuture)
        return self
    }
}

// MARK: Alpha Vantage Specific
/// Used to make calls to Alpha Vantage Stock Data API
struct AlphaVantageRestApi : RestApi {
    let host = "www.alphavantage.co"
    let scheme = "https"
    let basePath = "/query"
    let requiredParameters = [URLQueryItem(name: "apikey", value: "QE3W4HQKT4KSYNKZ")]
}


/// Base class for requests to the Alpha Vantage Stock Data API.  Intended to be subclasssed, but can
/// be used directly if library does not support a new api.
class AlphaVantageRequest : ApiRequest {
    private static let alphaApi = AlphaVantageRestApi()
    let method = "GET"
    let path = ""
    let queryStringParameters : Array<URLQueryItem>
    let api : RestApi = AlphaVantageRequest.alphaApi
    var responseJSON : [String : Any]?
    
    /// Creates the Alpha Vantage Api Request
    ///
    /// - Parameters:
    ///   - function: which Alpha Vantage function, or stock data, is being requested
    ///   - symbol: which company/organization's data is being requested
    ///   - additional: additional parameters considered optional by api
    init(function : String, symbol : String, _ additional : [(String, String?)] = []) {
        self.queryStringParameters = [URLQueryItem(name: "function", value: function),
                                      URLQueryItem(name: "symbol", value: symbol)] + additional.map { URLQueryItem(name: $0, value: $1) }
    }
}

// MARK: Stock Time Series Data
class TimeSeriesIntraDayRequest : AlphaVantageRequest {
    init(symbol : String, interval: String, _ additional : (String, String?)...) {
        super.init(function : "TIME_SERIES_INTRADAY", symbol : symbol, additional + [("interval", interval)])
    }
}

class TimeSeriesDailyRequest : AlphaVantageRequest {
    init(symbol : String, _ additional : (String, String?)...) {
        super.init(function: "TIME_SERIES_DAILY", symbol: symbol, additional)
    }
}

class TimeSeriesDailyAdjustedRequest : AlphaVantageRequest {
    init(symbol : String, _ additional : (String, String?)...) {
        super.init(function: "TIME_SERIES_DAILY_ADJUSTED", symbol: symbol, additional)
    }
}

class GlobalQuote : AlphaVantageRequest {
    init(symbol : String, _ additional : (String, String?)...) {
        super.init(function: "GLOBAL_QUOTE", symbol: symbol, additional)
    }
}

/*class MultiGlobalQuote : AlphaVantageRequest {
    init(function : String, symbols : [String], _ additional : [(String, String?)] = []) {
        var queryStringParameters = [URLQueryItem]()
        queryStringParameters.append(URLQueryItem(name: "function", value: function))
        for symbol in symbols {
            queryStringParameters.append(URLQueryItem(name: "symbols", value: symbol))
        }
        self.queryStringParameters = queryStringParameters + additional.map { URLQueryItem(name: $0, value: $1) }
    }
}*/

class RSIRequest : AlphaVantageRequest {
    init(symbol : String, interval : String, timePeriod : Int, seriesType : String,  _ additional : (String, String?)...) {
        super.init(function: "RSI", symbol: symbol, additional + [("interval", interval), ("time_period", "\(timePeriod)"), ("series_type", seriesType)])
    }
}
