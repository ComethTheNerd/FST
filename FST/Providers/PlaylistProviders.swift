import SwiftUI

class FSTPlaylistListDataProvider : ObservableObject
{
    @Published
    var loading : Bool = false;
    
    @Published
    var error   : FSTError?
    
    @Published
    var playlists : [FSTPlaylist]?
    
    
    func refresh()
    {
        loading = true
        
        // [dho] TODO playlist creator!
        playlists = [
            FSTPlaylist(
                id: UUID().uuidString,
                name: "⭐ Favourites",
                description: "I could watch these whenever!",
                image: nil,
                movies: []
            ),
            FSTPlaylist(
                id: UUID().uuidString,
                name: "🧸 Chill Films",
                description: "Films I like to relax to",
                image: nil,
                movies: []
            )
        ]
        
        loading = false
    }
    
    @discardableResult
    func add(movies : [FSTMovie], to index : Int) -> Int
    {
        guard let existingPlaylists = playlists, (0..<existingPlaylists.count).contains(index) else
        {
            return 0
        }
        
        let target = existingPlaylists[index]
        
        var update = existingPlaylists
        
        let combinedMovies = MergeMovieLists(target.movies, movies)
        
        update[index] = FSTPlaylist(
            id: target.id,
            name: target.name,
            description: target.description,
            image: target.image,
            movies : combinedMovies
        )

        self.playlists = update
 
        return combinedMovies.count - target.movies.count
    }
}


