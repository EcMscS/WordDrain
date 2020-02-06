//
//  HMError.swift
//  Hangman
//
//  Created by Jeffrey Lai on 1/28/20.
//  Copyright © 2020 Jeffrey Lai. All rights reserved.
//

import Foundation

enum HMError: String, Error {
    case urlFailure = "Unable to completed request with current url"
    case unableToComplete = "Unable to complete your request, please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server is invalid, please try again"
}
