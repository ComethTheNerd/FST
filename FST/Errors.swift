import SwiftUI

enum FSTError
{
    case networkError(error : URLError)
    case invalidSearch(input : String)
    case omdb(message : String)
    case decodingError(error : Error)
    case general(error : Error)
}

extension FSTError
{
    var localizedDescription : String {
        switch self {
        
        case .networkError(let error):
            return error.localizedDescription
            
        case .invalidSearch(let input):
            return "Invalid search string \"\(input)\""
            
        case .omdb(let message):
            return message;
            
        case .decodingError(let error):
            return error.localizedDescription
            
        case .general(let error):
            return error.localizedDescription
        
        }    
    }
}
