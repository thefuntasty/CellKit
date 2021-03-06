import UIKit

@available(iOS 13.0, tvOS 13.0, *)
public final class LazySupplementaryViewProvider {

    private var registeredIdentifiers: [String: Set<String>]
    private var provider: (SupplementaryElementKind, IndexPath) -> CollectionSupplementaryViewModel?

    public init(provider: @escaping (SupplementaryElementKind, IndexPath) -> CollectionSupplementaryViewModel?) {
        self.registeredIdentifiers = [:]
        self.provider = provider
    }

    public func provide(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        guard let item = provider(SupplementaryElementKind(rawValue: kind), indexPath) else {
            return nil
        }
        if !(registeredIdentifiers[kind]?.contains(item.reuseIdentifier) ?? false) {
            collectionView.register(item.cellClass, forSupplementaryViewOfKind: item.kind.rawValue, withReuseIdentifier: item.reuseIdentifier)
            registeredIdentifiers[kind, default: []].insert(item.reuseIdentifier)
        }

        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: item.kind.rawValue, withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell: cell)
        return cell
    }
}
