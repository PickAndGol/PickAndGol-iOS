
import Foundation

public typealias JSONDictionary = [String: Any]

public protocol JSONDecodable {
    init?(dictionary: JSONDictionary) throws
}



//public func decode<T: JSONDecodable>(_ dictionary: JSONDictionary) -> T? {
//    return T(dictionary: dictionary)
//}
//
//public func decode<T: JSONDecodable>(_ dictionaries: [JSONDictionary]) -> [T] {
//    return dictionaries.flatMap(decode)
//}
//
//public func decode<T: JSONDecodable>(_ data: Data) -> T? {
//    
//    guard
//        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
//        let jsonDictionary = jsonObject as? JSONDictionary,
//        let object: T = decode(jsonDictionary)
//        else {
//            return nil
//    }
//    
//    return object
//}
