import Foundation

public enum JSONError : ErrorType {
    case MissingValueForKey(String)
    case TypeMismatchForKey(String)
}

infix operator <| { associativity left precedence 150 }
infix operator <|? { associativity left precedence 150 }

public func <| <A>(dictionary: [String: AnyObject], key: String) throws -> A {
    let pathComponents = key.componentsSeparatedByString(".")
    
    var accumulator: Any = dictionary
    
    for component in pathComponents {
        if let dict = accumulator as? [String:AnyObject] {
            if let value = dict[component] {
                accumulator = value
                continue
            }
        }
        throw JSONError.MissingValueForKey(key)
    }
    
    if let value = accumulator as? A {
        return value
    }
    else {
        throw JSONError.TypeMismatchForKey(key)
    }
}

public func <|? <A>(dictionary: [String: AnyObject], key: String) throws -> A? {
    let pathComponents = key.componentsSeparatedByString(".")
    
    var accumulator: Any = dictionary
    
    for component in pathComponents {
        if let dict = accumulator as? [String:AnyObject] {
            if let value = dict[component] {
                accumulator = value
                continue
            }
        }
        throw JSONError.MissingValueForKey(key)
    }
    
    return accumulator as? A
}
