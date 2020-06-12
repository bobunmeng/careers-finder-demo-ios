import Foundation
import RxSwift

class Dependencies {

    static let sharedInstance = Dependencies()

    let mainScheduler = MainScheduler.instance
    let backgroundScheduler: ImmediateSchedulerType = {
        return ConcurrentDispatchQueueScheduler(qos: .userInteractive)
    }()

    private init() {}

}
