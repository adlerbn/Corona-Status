//
//  ApiManager.swift
//  Corona Status
//
//  Created by Yahya Bn on 7/7/21.
//

import Foundation

protocol ApiManagerDelegateStatus {
    func didUpdateLatestReport(with report: LatestReport, apiType: ApiType)
}

protocol ApiManagerDelegateCountry {
    func didUpdateReportByRegion(with country: CountryData, apiType: ApiType)
}

enum ApiType: String {
    case getLatestReport = "/v1/summary/latest"
    case getReportByRegion = "/v1/summary/region"
}

enum HttpMethod: String {
    case GET
    case POST
    case DELETE
}

class ApiManager {
    private let type: ApiType
    private let httpMethod: HttpMethod
    private var token: String = "9661e94941msh1f6cb0e92f5a0b2p1c1287jsnc2a8a4fc4d35"
    private let baseUrl: String = "https://coronavirus-map.p.rapidapi.com"
    private var body: String?
    private let headers = [
        "x-rapidapi-key": "9661e94941msh1f6cb0e92f5a0b2p1c1287jsnc2a8a4fc4d35",
        "x-rapidapi-host": "coronavirus-map.p.rapidapi.com"
    ]
    
    var delegateStatus: ApiManagerDelegateStatus?
    var delegateCountry: ApiManagerDelegateCountry?
    
    init(type: ApiType, httpMethod: HttpMethod) {
        print("initialize API")
        self.type = type
        self.httpMethod = httpMethod
    }
    
    private func fetchURL(_ addOne: String = "") {
        print("fetchURL")
        let urlString: String = "\(baseUrl)\(type.rawValue)\(addOne)"
        print(urlString)
        performRequest(urlString)
    }
    private func performRequest(_ urlString: String) {
        print("performRequest")
        //URL
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0)
            request.httpMethod = httpMethod.rawValue
            
//            request.addValue("application/json", forHTTPHeaderField: "content-type")
//            request.addValue("coronavirus-map.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
//            request.addValue(token, forHTTPHeaderField: "x-rapidapi-key")
            
            request.allHTTPHeaderFields = headers
            
//            let requestBody = body?.data(using: .utf8)
//            request.httpBody = requestBody
            
            //Get The URL Session
            let session = URLSession.shared
            
            //Create The Data Task
            let dataTask = session.dataTask(with: request, completionHandler: handle(data: response: error: ))
            
            //Fire Of The Data Task
            dataTask.resume()
        }
    }
    
    private func handle(data: Data?, response: URLResponse?, error: Error?) {
        print("handle")
        if error != nil {
            print("Fetch data, \(error!)")
            return
        }
        if let safeData = data {
            guard let str = String(data: safeData, encoding: .utf8) else { return }
            print("Str",str)
            checkResponse(safeData)
        }
    }
    
    func getDailyReportByCountryNames(_ region: String) {
        let addOne = "?region=\(region)"
        fetchURL(addOne)
    }
    
    func getLatestTotals() {
        fetchURL()
    }
    
    private func checkResponse(_ data: Data) {
        switch type {
        case .getLatestReport:
            print("checked Response totalStatus")
            if let latestReport = parseJSONTotalStatusData(apiData: data) {
                delegateStatus?.didUpdateLatestReport(with: latestReport, apiType: .getLatestReport)
            }
        case .getReportByRegion:
            print("checked Response Login")
            if let region = parseJSONCountriesData(apiData: data) {
                print(region)
                delegateCountry?.didUpdateReportByRegion(with: region, apiType: .getReportByRegion)
            }
        
        }
    }
    
    private func parseJSONCountriesData(apiData: Data) -> CountryData? {
        let jsonDecoder = JSONDecoder()
        do {
            let decodedData = try jsonDecoder.decode(CountryData.self, from: apiData)
            return decodedData
        } catch {
            print("Error Decoding Data CountriesData")
            return nil
        }
    }
    
    private func parseJSONTotalStatusData(apiData: Data) -> LatestReport? {

        let jsonDecoder = JSONDecoder()
        do {
            let decodedData = try jsonDecoder.decode(LatestReport.self, from: apiData)
            return decodedData
        } catch {
            print("Error Decoding Data LatestReport")
            return nil
        }
    }
}

