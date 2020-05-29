//
//  PictureRequest.swift
//  Exercise2
//
//  Created by Hung Vuong on 5/28/20.
//  Copyright © 2020 Hung Vuong. All rights reserved.
//

import Foundation

enum HolidayError: Error {
    case noDataAvailble
    case canNotProcessData
}

struct ImageRequest {
    let resourceURL: URL
    
    init(numberOfPage: Int, limit: Int) {
        let resourceString = "https://5eba40143f971400169923ef.mockapi.io/person?page=\(numberOfPage)&limit=\(limit)"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        self.resourceURL = resourceURL
    }
    
    func getImage(completion: @escaping(Result<[ImageInfo], HolidayError>) -> Void)  {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailble))
                return
            }
            do {
                let decoder = JSONDecoder()
                let imageResponse = try decoder.decode([ImageInfo].self, from: jsonData)
                let imageDetails = imageResponse
                completion(.success(imageDetails))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }

}

