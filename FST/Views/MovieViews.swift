import SwiftUI

struct MovieCatalogView : View 
{
    @EnvironmentObject var theme : FSTTheme
    
    @StateObject var playlistProvider  = FSTPlaylistListDataProvider()
    @StateObject var movieProvider     = FSTMovieListDataProvider()
    
    @State var selectKeeper = Set<String>()
    @State var searchText : String = ""
    @State var isEditing : Bool = false
  
    var playlistsButton : some View {
        NavigationLink(
            destination: FSTPlaylistCatalogView(playlistProvider: playlistProvider)
                .navigationTitle("Playlists")
        )
        {
            Image(systemName: "list.bullet")
        }
    }

    var editButton : some View {
        Button(isEditing ? "Cancel" : "Select")
        {
            if isEditing
            {
                isEditing = false
            }
            else if movieProvider.movies?.isEmpty == false
            {
                selectKeeper.removeAll()
                isEditing = true
            }
        }
    }
    
    func renderMovie(_ movie : FSTMovie) -> some View
    {
        FSTMovieListItemView(movie: movie)
    }
   
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Divider()
                
                FSTTextField(
                    placeholder: "Search for a movie...",
                    text: $searchText,
                    disabled : isEditing || movieProvider.loading,
                    onCommit: {
                        DismissKeyboard()
                        movieProvider.searchMovies(searchText)
                    }
                )
                .padding(.horizontal, theme.paddingUnit * 2)
                .padding(.vertical, theme.paddingUnit)
                
                Divider()
                
                VStack {
                    if movieProvider.loading {
                        FSTLoadingView()
                    }
                    else if let movies = movieProvider.movies
                    {
                        if !movies.isEmpty
                        {
                            List(movies, selection: $selectKeeper, rowContent : renderMovie)
                            .environment(\.editMode, .constant(isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
                            
                            
                            if isEditing && !selectKeeper.isEmpty{
                                NavigationLink(
                                    destination:
                                        FSTAddToPlaylistView(
                                            playlistProvider: playlistProvider,
                                            movies: movies,
                                            selectKeeper: $selectKeeper,
                                            isEditing : $isEditing)
                                        .navigationTitle("Add to Playlist"),
                                    label: {
                                    
                                        FSTTextButton(label : "Add to Playlist")
                                    })
                                    .padding(.top, theme.paddingUnit)
                                 

                            }
                        }
                        else
                        {
                            Text("No results found")
                        }
                    }
                    
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .topLeading
                )
                
                
                if let error = movieProvider.error
                {
                    FSTErrorView(error : error)
                }
                                    
            }
            .navigationBarItems(leading: playlistsButton, trailing: editButton)
            .navigationBarTitle(Text("Movies"))
        }
        
        .phoneOnlyStackNavigationView()
    }
}

struct FSTMovieListItemView : View
{
    @EnvironmentObject var theme : FSTTheme
    
    let movie : FSTMovie
    
    var body: some View 
    {
        HStack(alignment: .center, spacing: theme.paddingUnit)
        {
            FSTThumbnailView(imageURL: movie.poster)
            
            VStack(alignment: .leading, spacing : theme.paddingUnit)
            {
                Text(movie.title)
                    .font(theme.headingFont)
                    .fontWeight(theme.headingFontWeight)
                
                Text(movie.year)
                    .font(theme.subheadingFont)
                    .fontWeight(theme.subheadingFontWeight)
                
                Spacer()
            }
            .padding(.all, theme.paddingUnit)
        }
    }
}
