//
//  Post.swift
//  FilmsCarousel
//
//  Created by Eduardo Martin Lorenzo on 21/6/22.
//

import SwiftUI

struct Post: Identifiable {
    let id = UUID().uuidString
    var postImage: String
    var title: String
    var description: String
    var starRating: Int
}

var posts = [
    Post(postImage: "poster1", title: "Spider-Man", description: "Primera película del trepamuros", starRating: 7),
    Post(postImage: "poster2", title: "Spider-Man 2", description: "Segunda película del trepamuros", starRating: 8),
    Post(postImage: "poster3", title: "Spider-Man 3", description: "Tercera película del trepamuros", starRating: 7),
    Post(postImage: "poster4", title: "The Amazing Spiderman", description: "Primera película del reinicio del trepamuros", starRating: 6),
    Post(postImage: "poster5", title: "The Amazing Spiderman 2", description: "Segunda película del reinicio del trepamuros", starRating: 8),
    Post(postImage: "poster6", title: "Spiderman: Homecoming", description: "Primera película del trepamuros del MCU", starRating: 7),
    Post(postImage: "poster7", title: "Spiderman: Far From Home", description: "Segunda película del trepamuros del MCU", starRating: 8),
    Post(postImage: "poster8", title: "Spiderman: No Way Home", description: "Última película del trepamuros del MCU", starRating: 10),
]
