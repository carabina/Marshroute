import UIKit

/// Описание одного из совершенных обработчиком переходов.
/// Хранится в истории, чтобы иметь возможность выполнять обратные переходы.
/// Все важные ссылки хранятся слабо, чтобы не нарушать UIKit'овый цикл управления памятью.
/// т.е. чтобы спокойно пользоваться кнопкой `< Back`, например
struct CompletedTransitionContext {
    /// идентификатор перехода
    /// для точной отмены нужного перехода и возвращения на предыдущий экран через
    /// ```swift
    /// undoTransitionWith(transitionId:)
    let transitionId: TransitionId
    
    /// контроллер роутера, вызвавшего переход.
    private (set) weak var sourceViewController: UIViewController?
    
    /// обработчик переходов для роутера модуля, вызвавшего переход
    private (set) weak var sourceTransitionsHandler: TransitionsHandler?
    
    /// контроллер, на который перешли
    private (set) weak var targetViewController: UIViewController?
    
    /// обработчик переходов для роутера модуля, на контроллер которого перешли
    let targetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    let storableParameters: TransitionStorableParameters?
    
    /// параметры запуска анимации перехода
    let animationLaunchingContext: TransitionAnimationLaunchingContext
    
    init?(forwardTransitionContext context: ForwardTransitionContext,
        sourceViewController: UIViewController,
        sourceTransitionsHandler: TransitionsHandler)
    {
        assert(!context.needsAnimatingTargetTransitionHandler, "проставьте это значение раньше")
        
        guard let targetTransitionsHandlerBox = CompletedTransitionTargetTransitionsHandlerBox(forwardTransitionTargetTransitionsHandlerBox: context.targetTransitionsHandlerBox)
            else { return nil }
        
        self.transitionId = context.transitionId
        
        self.sourceViewController = sourceViewController
        self.sourceTransitionsHandler = sourceTransitionsHandler
        
        self.targetViewController = context.targetViewController
        self.targetTransitionsHandlerBox = targetTransitionsHandlerBox
        
        self.storableParameters = context.storableParameters

        self.animationLaunchingContext = context.animationLaunchingContext
    }
    
    /// Все важные ссылки хранятся слабо, чтобы не нарушать UIKit'овый цикл управления памятью.
    /// т.е. чтобы спокойно пользоваться кнопкой `< Back`, например, и targetViewController освободится.
    /// запись об таком переходе очищается лениво
    var isZombie: Bool {
        return targetViewController == nil
    }
}

// MARK: - convenience
extension CompletedTransitionContext {
    init(transitionId: TransitionId,
        sourceViewController: UIViewController?,
        sourceTransitionsHandler: TransitionsHandler?,
        targetViewController: UIViewController?,
        targetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox,
        storableParameters: TransitionStorableParameters?,
        animationLaunchingContext: TransitionAnimationLaunchingContext)
    {
        self.transitionId = transitionId
        self.sourceViewController = sourceViewController
        self.sourceTransitionsHandler = sourceTransitionsHandler
        self.targetViewController = targetViewController
        self.targetTransitionsHandlerBox = targetTransitionsHandlerBox
        self.storableParameters = storableParameters
        self.animationLaunchingContext = animationLaunchingContext
    }
}