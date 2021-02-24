import SwiftUI

struct FSTMovie : Encodable, Identifiable
{
    let id      : String;
    let title   : String;
    let year    : String;
    let poster  : URL?;
}

extension FSTMovie: Decodable 
{
    private enum CodingKeys : String, CodingKey {
        case id = "imdbID", title = "Title", year = "Year", poster = "Poster"
    }
    
    init(from decoder: Decoder) throws {
        let values   = try decoder.container(keyedBy: CodingKeys.self)
    
        id           = try values.decode(String.self, forKey: .id)
        title        = (try values.decode(String.self, forKey: .title)).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        year         = (try values.decode(String.self, forKey: .year)).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        // [dho] NOTE `.Poster` value can be set to "N/A" - 18/02/21
        poster       = URL(string: try values.decode(String.self, forKey: .poster))
   }
}

func MergeMovieLists(_ movies1 : [FSTMovie], _ movies2 : [FSTMovie]) -> [FSTMovie]
{
    return movies1 + movies2.filter {
        movie in !movies1.contains(where: { $0.id == movie.id })
    }
}


