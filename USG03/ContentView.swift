//
//  ContentView.swift
//  USG03
//
//  Created by 최성빈 on 2023/01/30.
//

//
//  ContentView.swift
//  iMovie
//
//  Created by hyunho lee on 2023/01/29.
//


/*
 {
   "message": "success",
   "paging": {
     "total": 28,
     "skip": 0,
     "limit": 10
   },
   "data": [
     {
       "genre": [
         "드라마",
         "범죄",
         "스릴러"
       ],
       "_id": "631f9079842a834b759419d9",
       "title": "수리남",
       "image": "/poster/1663012985184.jpeg"
     }
 */


import SwiftUI

struct Movie: Codable, Hashable {
    let title: String
    let image: String
}

struct MovieResponse: Codable {
    let data: [Movie]
}

struct ContentView: View {
    
    @State var movies: [Movie] = []
    
    func fetchMovieList() {
        print("fetchMovieList")
        // 1. URL
        let urlStr = "http://mynf.codershigh.com:8080/api/movies"
        let url = URL(string: urlStr)!
        
        // 2. Request
        let request = URLRequest(url: url)
        
        // 3. Session, Task
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let ret = try JSONDecoder().decode(MovieResponse.self, from: data!)
                for item in ret.data {
                    movies.append(item)
                }
            }
            catch {
                print("Error", error)
            }
        }.resume()
    }
    
    var body: some View {
        VStack {
            List(movies, id: \.self) { item in
                HStack {
                    
                    AsyncImage(url: URL(string: "http://mynf.codershigh.com:8080"+item.image)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 100)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    
                    Text(item.title)
                }
            }
            
            Button {
                fetchMovieList()
            } label: {
                Text("Get")
            }
            
        }
        .padding()
    }
    
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
