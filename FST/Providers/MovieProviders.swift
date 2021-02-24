import SwiftUI

class FSTMovieListDataProvider : ObservableObject
{
    @Published
    var loading : Bool = false;
    
    @Published
    var error   : FSTError?
    
    @Published
    var movies : [FSTMovie]?
    
    private var latestRequest : URLSessionDataTask?
    
    func searchMovies(_ input : String)
    {
        latestRequest?.cancel()
        
        loading = true
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.latestRequest = QueryMovies(matching: input)
            {
                result in DispatchQueue.main.async {
                    self?.queryMoviesResultHandler(result: result)
                }
            }
        }
    }
    
    private func queryMoviesResultHandler(result : FSTQueryMoviesResult)
    {
        if latestRequest == result.task {
            loading = false
        }
        
        if let task = result.task, task.state != .completed {
            return
        }
  
        movies  = result.movies
        error   = result.error
    }
}
