//
//  Created by Carson Rau on 3/31/22.
//


public extension UnsafeMutablePointer {
    var raw: UnsafeMutableRawPointer {
        .init(self)
    }
}

public extension UnsafeMutablePointer {
    func buffer(n: Int) -> UnsafeMutableBufferPointer<Pointee> {
        .init(start: self, count: n)
    }
    func advanced(by n: Int, wordSize: Int) -> UnsafeMutableRawPointer {
        self.raw.advanced(by: n * wordSize)
    }
}
