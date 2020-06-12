import Foundation
import Alamofire
import AlamofireObjectMapper
import RxSwift

class CareerApiManager : BaseService {

    static let shared = CareerApiManager()
    private let authDataStore: AuthDataStore
    private let careerInfoDataStore: CareerInfoDataStore
    private let partnerDataStore: PartnerDataStore

    private init() {
        authDataStore = AuthDataStoreImpl()
        careerInfoDataStore = CareerInfoDataStoreImpl()
        partnerDataStore = PartnerDataStoreImpl()
    }

    func fetchCategories() -> Single<[Category]> {
        return Single.create { observer in
            self.request(Api.categories)
                .responseArray(completionHandler: { (response: DataResponse<[CategoryResponse]>) in
                    switch response.result {
                    case .success(let categoryList):
                        var categories: [Category] = []
                        categoryList.forEach {
                            let category = Category(id: $0.id, category: $0.category)
                            categories.append(category)
                        }
                        observer(.success(categories))
                    case .failure(let error):
                        observer(.error(error))
                    }
                })
            return Disposables.create()
        }
    }

}
