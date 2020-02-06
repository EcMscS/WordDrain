//
//  NetworkManager.swift
//  Hangman
//
//  Created by Jeffrey Lai on 1/10/20.
//  Copyright © 2020 Jeffrey Lai. All rights reserved.
//

import UIKit

class NetworkManager {
    
    //Test 0: https://api.wordnik.com/v4/words.json/randomWord?api_key=9g7xmsir8mthknqwy51238vhqpgmr9agp742yond3kfom30nf
    //Test 1: https://api.wordnik.com/v4/words.json/wordOfTheDay?api_key=9g7xmsir8mthknqwy51238vhqpgmr9agp742yond3kfom30nf

    //Test 2: https://api.wordnik.com/v4/words.json/randomWords?hasDictionaryDef=true&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=5&maxLength=-1&limit=50&api_key=9g7xmsir8mthknqwy51238vhqpgmr9agp742yond3kfom30nf

    
    static let shared = NetworkManager()
    let wordNikApiKey = "9g7xmsir8mthknqwy51238vhqpgmr9agp742yond3kfom30nf"
    let listOfWordsBaseURL = "https://api.wordnik.com/v4/words.json/randomWords?hasDictionaryDef=true&excludePartOfSpeech=article%2Cabbreviation%2Cpreposition%2Caffix%2Cfamily-name%2Cgiven-name%2Cidiom%2Cproper-noun%2Csuffix&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=5&maxLength=-1&limit=10&api_key="
    let wordOfTheDayBaseURL = "https://api.wordnik.com/v4/words.json/wordOfTheDay?api_key="
    let randomWordURL = "https://api.wordnik.com/v4/words.json/randomWord?api_key="
    
    private init() {}
    
    func getWordOfTheDay(completed: @escaping(Result<RandomWord, HMError>) -> Void) {
        let wordURL = wordOfTheDayBaseURL + wordNikApiKey
        
        guard let url = URL(string: wordURL) else {
            completed(.failure(.urlFailure))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                print("Error Message is: \(String(describing: error))")
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error in response")
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                print("Error in data")
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let word = try decoder.decode(RandomWord.self, from: data)
                completed(.success(word))
            } catch {
                print("Failed to decode")
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func getListOfWords(completed: @escaping(Result<[Word], HMError>) -> Void) {
        let listURL = listOfWordsBaseURL + wordNikApiKey
        
        guard let url = URL(string: listURL) else {
            completed(.failure(.urlFailure))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                print("Error Message is: \(String(describing: error))")
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error in response")
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                print("Error in data")
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let words = try decoder.decode([Word].self, from: data)
                completed(.success(words))
            } catch {
                print("Failed to decode")
                completed(.failure(.invalidData))
            }
        }
        task.resume()
        
    }
}
