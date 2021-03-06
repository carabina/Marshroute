import Marshroute

final class TrackedModulesList {
    // MARK: - Private properties
    private var modules = [TrackedModule]()
    
    // MARK: - Internal
    func append(trackedModule: TrackedModule) {
        guard trackedModule.weakTransitionsHandlerBox?.unbox() !== nil
            else { return }
        
        releaseZombieModules()
        
        guard !modules.contains({ $0.transitionId == trackedModule.transitionId })
            else { return }
        
        modules.append(trackedModule)
    }
    
    func removeTrackedModuleWithTransitionUserId(
        transitionUserId: TransitionUserId,
        transitionId: TransitionId)
    {
        releaseZombieModules()
        
        let index = modules.indexOf {
            ($0.transitionUserId == transitionUserId) &&
                ($0.transitionId == transitionId)
        }
        
        if let trackedModuleIndex = index {
            modules.removeAtIndex(trackedModuleIndex)
        }
    }
    
    func removeTrackedModulesWithTransitionUserId(transitionUserId: TransitionUserId) {
        releaseZombieModules()
        
        let index = modules.indexOf { $0.transitionUserId == transitionUserId }
        
        if let trackedModuleIndex = index {
            modules.removeAtIndex(trackedModuleIndex)
        }

    }

    func trackedModulesWithTransitionUserId(
        transitionUserId: TransitionUserId,
        mismatchingTransitionId transitionId: TransitionId)
        -> [TrackedModule]
    {
        releaseZombieModules()
        
        let result = modules.filter {
            ($0.transitionUserId == transitionUserId) &&
                ($0.transitionId != transitionId)
        }
        
        return result
    }
    
    func trackedModulesWithTransitionUserId(transitionUserId: TransitionUserId)
        -> [TrackedModule]
    {
        releaseZombieModules()
        
        let result = modules.filter { $0.transitionUserId == transitionUserId }
        
        return result
    }
    
    // MARK: - Private
    private func releaseZombieModules() {
        modules = modules.filter { $0.weakTransitionsHandlerBox?.unbox() !== nil }
    }
}