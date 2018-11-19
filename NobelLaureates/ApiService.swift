//
//  ApiService.swift
//  NobelLaureates
//
//  Created by Herbert Caller on 18/11/2018.
//  Copyright © 2018 hacaller. All rights reserved.
//

import Foundation

enum LaureateQuery: String {
    case Physics = "physics"
    case Physiology = "physiology"
    case Japan = "japan"
    case Italy = "italy"
}

protocol ApiServiceDelegate {
    func consumeLaureates(laureates: [LaureateResponse], query:LaureateQuery)
}

class ApiService {
    
    var delegate: ApiServiceDelegate?
    var laureates: [LaureateResponse] = []
    var queries: [LaureateQuery]?
    
    func findAllLaureates() {
        let fullUrl = Constants.baseUrl + Constants.endPoint
        guard let mUrl = URL(string: fullUrl) else {
            return
        }
        let request = URLRequest(url: mUrl)
        let task = URLSession.shared.dataTask( with: request, completionHandler: { (data, response, error) in
            self.handleResponse(data: data, response: response, error: error) } )
        task.resume()
        
    }
    
    func handleResponse(data:Data?, response:URLResponse?, error:Error?) {
        if let data = data {
            do {
                let jsonString = try JSONSerialization.jsonObject(with: data, options:
                    JSONSerialization.ReadingOptions.mutableContainers) as? NSArray
                for case let item in jsonString! {
                    if let laureate = LaureateResponse(json: item as! [String : Any]) {
                        self.laureates.append(laureate)
                    }
                }
                self.concurrencyDispatchHandler(laureates: self.laureates, queries: self.queries!)
            } catch {
            }
        }
    }
    
    func concurrencyDispatchHandler(laureates: [LaureateResponse], queries:[LaureateQuery]){
        let queue = DispatchQueue.global(qos: .background)
        for case let query in queries {
            let work = DispatchWorkItem.init(block: {
                var filteredLaureates: [LaureateResponse] = []
                for laureate in self.laureates {
                    if (laureate.country.lowercased().contains(query.rawValue) ||
                        laureate.category.lowercased().contains(query.rawValue)){
                        filteredLaureates.append(laureate)
                    }
                }
                DispatchQueue.main.async {
                    self.delegate?.consumeLaureates(laureates: filteredLaureates, query: query)
                }
            })
            queue.async(execute: work)
        }
    }
    
    func concurrencyHandler(laureates: [LaureateResponse], queries:[LaureateQuery]){
        let ops = BlockOperation()
        for case let query in queries {
            ops.addExecutionBlock {
                var filteredLaureates: [LaureateResponse] = []
                for laureate in self.laureates {
                    if (laureate.country.lowercased().contains(query.rawValue) ||
                        laureate.category.lowercased().contains(query.rawValue)){
                        filteredLaureates.append(laureate)
                    }
                }
                DispatchQueue.main.async {
                    self.delegate?.consumeLaureates(laureates: filteredLaureates, query: query)
                }
            }
        }
        let queue = OperationQueue()
        queue.addOperation(ops)
    }
    
    func concurrencyHandlerDisp(laureates: [LaureateResponse], queries:[LaureateQuery]){
        for case let query in queries {
            OperationQueue.init().addOperation {
                var filteredLaureates: [LaureateResponse] = []
                for laureate in self.laureates {
                    if (laureate.country.lowercased().contains(query.rawValue) ||
                        laureate.category.lowercased().contains(query.rawValue)){
                        filteredLaureates.append(laureate)
                    }
                }
                DispatchQueue.main.async {
                    self.delegate?.consumeLaureates(laureates: filteredLaureates, query: query)
                }
                
            }
        }
    }
    
    func concurrencyHandlerOp(laureates: [LaureateResponse], queries:[LaureateQuery]){
        for case let query in queries {
            OperationQueue.init().addOperation {
                var filteredLaureates: [LaureateResponse] = []
                for laureate in self.laureates {
                    if (laureate.country.lowercased().contains(query.rawValue) ||
                        laureate.category.lowercased().contains(query.rawValue)){
                        filteredLaureates.append(laureate)
                    }
                }
                 OperationQueue.main.addOperation {
                 self.delegate?.consumeLaureates(laureates: filteredLaureates, query: query)
                 }
            }
        }
    }
    
}
