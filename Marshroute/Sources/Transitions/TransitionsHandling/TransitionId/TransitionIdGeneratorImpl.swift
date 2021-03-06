import Foundation

public final class TransitionIdGeneratorImpl {
    public init() {}
}

extension TransitionIdGeneratorImpl: TransitionIdGenerator {
    public func generateNewTransitionId()
        -> TransitionId
    {
        let result = NSUUID().UUIDString
        return result
    }
}
