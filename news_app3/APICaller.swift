//
//  APICaller.swift
//  news_app
//
//  Created by Ruben Hales on 3/30/23.
//



import Foundation

final class APICaller {
    static let shared = APICaller()

    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=US&apiKey=eda6154a62744b7bbad849130a7f7b6f")
        static let searchUrlString = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=eda6154a62744b7bbad849130a7f7b6f&q="
    }

    private init() {}

    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {

                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)

                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }

    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        let urltring = Constants.searchUrlString + query
        guard let url = URL(string: urltring) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {

                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)

                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}

// Models
struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
