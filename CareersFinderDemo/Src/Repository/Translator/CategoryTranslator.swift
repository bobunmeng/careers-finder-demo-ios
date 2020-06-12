import Foundation

class CategoryTranslator: Translator {

    typealias Input = CategoryEntity
    typealias Output = Category

    func translate(entity: CategoryEntity) -> Category {
        return Category(id: entity.id, category: entity.category)
    }

}
