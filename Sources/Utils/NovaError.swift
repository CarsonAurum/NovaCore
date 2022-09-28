//
//  Created by Carson Rau on 2/28/22.
//

import protocol Swift.Error

/// An error thrown within the core Nova framework.
@usableFromInline
internal enum NovaError: Error {
    case invalidCast
}
