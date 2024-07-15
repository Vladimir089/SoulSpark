//
//  Model.swift
//  SoulSpark
//
//  Created by Владимир Кацап on 15.07.2024.
//

import Foundation

var playersArr = [Players]()
var TeamArr = [Team]()

struct Players: Codable {
    var photo: Data
    var name: String
    var age: String
    var role: String
    //stat
    var matches: String
    var goals: String
    var fine: String
    
    var descriptiion: String
    
    init(photo: Data, name: String, age: String, role: String, matches: String, goals: String, fine: String, descriptiion: String) {
        self.photo = photo
        self.name = name
        self.age = age
        self.role = role
        self.matches = matches
        self.goals = goals
        self.fine = fine
        self.descriptiion = descriptiion
    }
    
}



struct Team: Codable {
    
    var photo: Data
    var name: String
    var description: String
    var wins: String
    var defeats: String
    var draw: String
    var players: [Players]
    
    init(photo: Data, name: String, description: String, wins: String, defeats: String, draw: String, players: [Players]) {
        self.photo = photo
        self.name = name
        self.description = description
        self.wins = wins
        self.defeats = defeats
        self.draw = draw
        self.players = players
    }
}
