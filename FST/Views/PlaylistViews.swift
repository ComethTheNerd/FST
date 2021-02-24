import SwiftUI

struct FSTPlaylistCatalogView  : View {
    
    @EnvironmentObject var theme : FSTTheme
    @ObservedObject var playlistProvider : FSTPlaylistListDataProvider
    
    func onAppear()
    {
        if playlistProvider.playlists == nil {
            playlistProvider.refresh()
        }
    }
    
    func renderPlaylist(_ playlist : FSTPlaylist) -> some View
    {
        NavigationLink(destination: FSTPlaylistDetailView(playlist: playlist))
        { 
            FSTPlaylistListItemView(playlist: playlist) 
        }
    }
    
    var body  : some View {
        VStack {
     
            VStack
            {
                if playlistProvider.loading {
                    FSTLoadingView()
                }
                else
                {
                    List(playlistProvider.playlists ?? [], rowContent: renderPlaylist)
                }
            }
            .frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            
            if let error = playlistProvider.error
            {
                FSTErrorView(error : error)
            }
        }
        .onAppear(perform: onAppear)
    }
}


struct FSTPlaylistDetailView : View
{
    @EnvironmentObject var theme : FSTTheme
    
    let playlist : FSTPlaylist
    
    func renderMovie(_ movie : FSTMovie) -> some View
    {
        FSTMovieListItemView(movie: movie)
    }
    
    var body : some View
    {
        VStack(alignment: .leading, spacing: theme.paddingUnit)
        {
            HStack(alignment : .center, spacing: 0) {
                Spacer()
                VStack(alignment: .center, spacing: theme.paddingUnit)
                {
                    FSTThumbnailView(imageURL: playlist.image)
                        .cornerRadius(theme.paddingUnit)
                        .padding(.top, theme.paddingUnit)
                    
                    Text(playlist.name)
                        .font(theme.superheadingFont)
                        .fontWeight(theme.superheadingFontWeight)
                        .padding(.top, theme.paddingUnit)
                    
                    Text(playlist.description)
                        .font(theme.subheadingFont)
                        .fontWeight(theme.subheadingFontWeight)
                        .padding(.bottom, theme.paddingUnit)
                }
                Spacer()
            }
            
            Divider()
            
            List(playlist.movies, rowContent : renderMovie)
        }
    }
}


struct FSTAddToPlaylistView : View {
    @EnvironmentObject var theme : FSTTheme
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var playlistProvider : FSTPlaylistListDataProvider
    let movies : [FSTMovie]
    @Binding var selectKeeper : Set<String>
    @Binding var isEditing : Bool
    
    @State var showAlert : Bool = false
    @State var alertMessage : String = ""
    @State var didSucceed : Bool = false
    
    func onAppear()
    {
        if playlistProvider.playlists == nil {
            playlistProvider.refresh()
        }
    }
    
    func addMoviesTo(playlist : FSTPlaylist)
    {
        let index = playlistProvider.playlists?.firstIndex { $0.id == playlist.id } ?? -1
        
        if index > -1 {
            let selectedMovies = movies.filter { selectKeeper.contains($0.id) }

            if !selectedMovies.isEmpty
            {
                let added = playlistProvider.add(movies: selectedMovies, to: index)
                
                if added == selectedMovies.count
                {
                    alertMessage = "Added!"
                }
                else
                {
                    alertMessage = "Added (some duplicates were skipped)!"
                }
                
                selectKeeper.removeAll()
                isEditing = false
                didSucceed = true
            
            }
            else
            {
                alertMessage = "Could not find movies to add"
                didSucceed = false
            }
        }
        else
        {
            alertMessage = "Could not find playlist"
            didSucceed = false
        }
        
        showAlert = true
    }
    
    func renderPlaylist(_ playlist : FSTPlaylist) -> some View
    {
        FSTPlaylistListItemView(playlist: playlist).onTapGesture 
        {
            addMoviesTo(playlist: playlist)
        }
    }
    
    var body  : some View {
        VStack {
     
            VStack
            {
                if playlistProvider.loading {
                    FSTLoadingView()
                }
                else
                {
                    List(playlistProvider.playlists ?? [], rowContent: renderPlaylist)
                }
            }
            .frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            
            if let error = playlistProvider.error
            {
                Text("Error: \(error.localizedDescription)")
            }
         
            Text("My favourite color is black")
                .font(theme.headingFont)
                .fontWeight(theme.headingFontWeight)
        
        }.alert(isPresented: $showAlert) 
        {
            Alert(
                title: Text(didSucceed ? "Success" : "Uh oh"),
                message: Text(alertMessage), dismissButton: .default(Text("OK"))
            {
                if didSucceed {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
        .onAppear(perform: onAppear)
    }
    
}


struct FSTPlaylistListItemView : View
{
    @EnvironmentObject var theme : FSTTheme
    
    let playlist : FSTPlaylist
    
    var body: some View {
        HStack(alignment: .center, spacing: theme.paddingUnit)
        {
            FSTThumbnailView(imageURL: playlist.image)
                .cornerRadius(theme.paddingUnit)
            
            VStack(alignment: .leading, spacing : theme.paddingUnit)
            {
                Text(playlist.name)
                    .font(theme.headingFont)
                    .fontWeight(theme.headingFontWeight)
                
                Text(playlist.description)
                    .font(theme.subheadingFont)
                    .fontWeight(theme.subheadingFontWeight)
                
                Spacer()
            }
            .padding(.all, theme.paddingUnit)
        }
    }
}
