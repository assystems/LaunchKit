//
//  File.swift
//  
//
//  Created by Riku Yamane on 2023/11/16.
//

import Foundation

public struct Version: Comparable {
    public let major: Int
    public let minor: Int
    public let revision: Int

    public init(major: Int, minor: Int, revision: Int) {
        self.major = major
        self.minor = minor
        self.revision = revision
    }

    public static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        }

        if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        }

        return lhs.revision < rhs.revision
    }

    public static func == (lhs: Version, rhs: Version) -> Bool {
        return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.revision == rhs.revision
    }
}
extension Version {
    public init?(versionString: String) {
        let components = versionString.components(separatedBy: ".")
        guard components.count == 3,
            let major = Int(components[0]),
            let minor = Int(components[1]),
            let revision = Int(components[2]) else {
                return nil
        }
        self.init(major: major, minor: minor, revision: revision)
    }
}
