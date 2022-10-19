//
//  CellAPI.swift
//  NetflixApp
//
//  Created by Fatih on 17.10.2022.
//

import Foundation

struct Constants {
    static let Api_Key = "7449b8e0901923de98300585d22d2be7"
    static let Api_URL = "https://api.themoviedb.org"
    static let youtubeAPI = "AIzaSyAyLrQ7To5Q5jeKS_LKcw9U3rvEAd9oitI"
    static let youtubeURL = "https://youtube.googleapis.com/youtube/v3/search?"
    
}

enum ErrorAPI: Error {
    case failedToData
}
class CallerAPI {
     static let shared = CallerAPI()
    
    
    
    func TrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.Api_URL)/3/trending/movie/day?api_key=\(Constants.Api_Key)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(ErrorAPI.failedToData))
            }
        }
        
        task.resume()
    }



        
    func TrendingTv(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.Api_URL)/3/trending/tv/day?api_key=\(Constants.Api_Key)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(ErrorAPI.failedToData))
            }
        }
            
            task.resume()
        }

    func UpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.Api_URL)/3/movie/upcoming?api_key=\(Constants.Api_Key)&language=en-US&page=1") else {return}
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
        
            do {
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(ErrorAPI.failedToData))
            }

        }
            task.resume()
    }


    func Popular(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.Api_URL)/3/movie/popular?api_key=\(Constants.Api_Key)&language=en-US&page=1") else {return}
           let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
               
            do {
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(ErrorAPI.failedToData))
               }

           }
           
           task.resume()
       }

     func TopRated(completion: @escaping (Result<[Movie], Error>) -> Void) {
         guard let url = URL(string: "\(Constants.Api_URL)/3/movie/top_rated?api_key=\(Constants.Api_Key)&language=en-US&page=1") else {return }
         let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
             guard let data = data, error == nil else {
                 return
             }
             
             do {
                 let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                 completion(.success(results.results))

             } catch {
                 completion(.failure(ErrorAPI.failedToData))
             }

         }
         task.resume()
     }
    
    
    func getSearchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.Api_URL)/3/discover/movie?api_key=\(Constants.Api_Key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(ErrorAPI.failedToData))
            }

        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.Api_URL)/3/search/movie?api_key=\(Constants.Api_Key)&query=\(query)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(ErrorAPI.failedToData))
            }

        }
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        

        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.youtubeURL)q=\(query)&key=\(Constants.youtubeAPI)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                
                completion(.success(results.items[0]))
                

            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }

        }
        task.resume()
    }

    
}
