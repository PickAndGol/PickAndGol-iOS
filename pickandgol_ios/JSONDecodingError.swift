
import Foundation

enum JSONDecodingError : Error {
    
    case wrongJSONFormat
    case wrongURLFormatForJSONResource
    case errorDecodingJSON
    case nilJSONObject
}
