# 📂 Feature 08: سجل التحميلات

> صفحة شاملة تعرض جميع التحميلات السابقة مع إمكانية البحث والتصفية حسب المنصة والتاريخ، وخيارات إعادة التحميل والمشاركة والحذف.

---

## 📋 ملخص الميزة

| العنصر | التفاصيل |
|---|---|
| **الأولوية** | 🟡 متوسطة |
| **التبعيات** | Feature 01, 05 (محرك التحميل) |
| **المدة المتوقعة** | 3-4 أيام |
| **التعقيد** | متوسط |

---

## 🎯 الأهداف

1. حفظ جميع التحميلات في قاعدة بيانات محلية (Hive)
2. صفحة سجل تعرض التحميلات مع صورة مصغرة ومعلومات
3. البحث في السجل بالعنوان
4. التصفية حسب المنصة (أيقونات فلترة)
5. التصفية حسب التاريخ (اليوم، هذا الأسبوع، هذا الشهر)
6. خيارات: إعادة تحميل / مشاركة / حذف
7. سحب للحذف (Swipe to delete)
8. مسح السجل بالكامل

---

## 🖼️ تصور الواجهة

```
╔══════════════════════════════════════╗
║  📂 سجل التحميلات                    ║
╠══════════════════════════════════════╣
║                                      ║
║  🔍 [  بحث عن فيديو...            ]  ║
║                                      ║
║  فلترة:                              ║
║  [الكل] [🔴YT] [📸IG] [🎵TT] [🐦X]  ║
║                                      ║
║  📅 اليوم                            ║
║  ┌────────────────────────────────┐  ║
║  │ 🖼️│ عنوان الفيديو 1           │  ║
║  │    │ YouTube • 720p • 35 MB   │  ║
║  │    │ ✅ مكتمل • منذ 2 ساعة     │  ║
║  └────────────────────────────────┘  ║
║                                      ║
║  ← سحب للحذف                         ║
║  ┌────────────────────────────────┐  ║
║  │ 🖼️│ عنوان الفيديو 2           │  ║
║  │    │ TikTok • 1080p • 12 MB   │  ║
║  │    │ ✅ مكتمل • منذ 5 ساعات    │  ║
║  └────────────────────────────────┘  ║
║                                      ║
║  📅 أمس                              ║
║  ┌────────────────────────────────┐  ║
║  │ 🖼️│ عنوان الفيديو 3           │  ║
║  │    │ Instagram • 720p • 8 MB  │  ║
║  │    │ ❌ فشل • [إعادة المحاولة]  │  ║
║  └────────────────────────────────┘  ║
║                                      ║
║  ← لا توجد تحميلات أخرى →            ║
║                                      ║
╠══════════════════════════════════════╣
║  🏠 الرئيسية │ 📂 السجل │ ⚙️ إعدادات ║
╚══════════════════════════════════════╝
```

---

## 📄 الملفات المطلوبة

```
lib/features/history/
├── data/
│   ├── models/
│   │   └── history_item_model.dart         # Hive Model
│   └── repositories/
│       └── history_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── history_item.dart               # Entity
│   ├── repositories/
│   │   └── history_repository.dart         # Abstract
│   └── usecases/
│       ├── get_history.dart
│       ├── search_history.dart
│       ├── delete_history_item.dart
│       ├── clear_all_history.dart
│       └── filter_by_platform.dart
└── presentation/
    ├── pages/
    │   └── history_page.dart
    ├── widgets/
    │   ├── history_list_item.dart           # بطاقة العنصر
    │   ├── history_search_bar.dart          # شريط البحث
    │   ├── platform_filter_chips.dart       # أزرار فلترة المنصات
    │   ├── date_group_header.dart           # عنوان مجموعة التاريخ
    │   ├── empty_history_view.dart          # حالة السجل فارغ
    │   └── history_item_actions.dart        # أزرار الإجراءات
    └── bloc/
        ├── history_bloc.dart
        ├── history_event.dart
        └── history_state.dart
```

---

## 📄 التنفيذ التفصيلي

### 1. كيان السجل

```dart
@HiveType(typeId: 0)
class HistoryItem {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String originalUrl;
  @HiveField(3)
  final String thumbnailUrl;
  @HiveField(4)
  final String platform;        // youtube, instagram...
  @HiveField(5)
  final String quality;
  @HiveField(6)
  final String format;           // mp4, mp3
  @HiveField(7)
  final int fileSizeBytes;
  @HiveField(8)
  final String savePath;
  @HiveField(9)
  final String status;           // completed, failed
  @HiveField(10)
  final DateTime downloadDate;
  @HiveField(11)
  final String? errorMessage;
  
  PlatformType get platformType => PlatformType.values
    .firstWhere((p) => p.name == platform, orElse: () => PlatformType.unknown);
  
  String get fileSizeMB => (fileSizeBytes / 1024 / 1024).toStringAsFixed(1);
  
  String get timeAgo {
    final diff = DateTime.now().difference(downloadDate);
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
    return DateFormat('yyyy-MM-dd').format(downloadDate);
  }
  
  bool get fileExists => File(savePath).existsSync();
}
```

### 2. Repository

```dart
class HistoryRepositoryImpl implements HistoryRepository {
  final Box<HistoryItem> _box;
  
  @override
  Future<List<HistoryItem>> getAll() async {
    return _box.values.toList()
      ..sort((a, b) => b.downloadDate.compareTo(a.downloadDate));
  }
  
  @override
  Future<List<HistoryItem>> search(String query) async {
    return _box.values
      .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
      .toList();
  }
  
  @override
  Future<List<HistoryItem>> filterByPlatform(PlatformType platform) async {
    return _box.values
      .where((item) => item.platformType == platform)
      .toList();
  }
  
  @override
  Future<void> addItem(HistoryItem item) async {
    await _box.put(item.id, item);
  }
  
  @override
  Future<void> deleteItem(String id) async {
    await _box.delete(id);
  }
  
  @override
  Future<void> clearAll() async {
    await _box.clear();
  }
  
  @override
  Future<Map<String, List<HistoryItem>>> getGroupedByDate() async {
    final items = await getAll();
    final groups = <String, List<HistoryItem>>{};
    
    for (final item in items) {
      final key = _dateGroupKey(item.downloadDate);
      groups.putIfAbsent(key, () => []).add(item);
    }
    
    return groups;
  }
  
  String _dateGroupKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDate = DateTime(date.year, date.month, date.day);
    
    if (itemDate == today) return 'اليوم';
    if (itemDate == today.subtract(const Duration(days: 1))) return 'أمس';
    if (date.isAfter(today.subtract(const Duration(days: 7)))) return 'هذا الأسبوع';
    if (date.month == now.month && date.year == now.year) return 'هذا الشهر';
    return DateFormat('MMMM yyyy', 'ar').format(date);
  }
}
```

### 3. History BLoC

#### Events
```dart
abstract class HistoryEvent extends Equatable {}

class LoadHistory extends HistoryEvent {}

class SearchHistory extends HistoryEvent {
  final String query;
  SearchHistory(this.query);
}

class FilterByPlatform extends HistoryEvent {
  final PlatformType? platform;  // null = الكل
  FilterByPlatform(this.platform);
}

class DeleteHistoryItem extends HistoryEvent {
  final String id;
  final bool deleteFile;  // هل يحذف الملف أيضاً؟
  DeleteHistoryItem(this.id, {this.deleteFile = false});
}

class ClearAllHistory extends HistoryEvent {}

class RedownloadItem extends HistoryEvent {
  final HistoryItem item;
  RedownloadItem(this.item);
}

class ShareItem extends HistoryEvent {
  final HistoryItem item;
  ShareItem(this.item);
}

class OpenItem extends HistoryEvent {
  final HistoryItem item;
  OpenItem(this.item);
}
```

#### State
```dart
class HistoryState extends Equatable {
  final Map<String, List<HistoryItem>> groupedItems;
  final bool isLoading;
  final String searchQuery;
  final PlatformType? selectedPlatform;
  final String? error;
  
  int get totalItems => groupedItems.values
    .fold(0, (sum, list) => sum + list.length);
  
  bool get isEmpty => totalItems == 0;
}
```

### 4. بطاقة عنصر السجل

```dart
class HistoryListItem extends StatelessWidget {
  final HistoryItem item;
  
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => _showDeleteConfirmation(context),
      onDismissed: (_) => context
        .read<HistoryBloc>()
        .add(DeleteHistoryItem(item.id, deleteFile: false)),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: InkWell(
          onTap: () => _showActions(context),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // صورة مصغرة
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: item.thumbnailUrl,
                    width: 80, height: 60,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.video_library),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // المعلومات
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(item.platformType.emoji, style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Text(
                            '${item.platformType.displayName} • ${item.quality} • ${item.fileSizeMB} MB',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            item.status == 'completed' ? Icons.check_circle : Icons.error,
                            size: 14,
                            color: item.status == 'completed' ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.status == 'completed' ? 'مكتمل' : 'فشل'} • ${item.timeAgo}',
                            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                          ),
                          if (item.status == 'failed') ...[
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () => context
                                .read<HistoryBloc>()
                                .add(RedownloadItem(item)),
                              icon: const Icon(Icons.refresh, size: 14),
                              label: const Text('إعادة', style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // زر المزيد
                PopupMenuButton<String>(
                  onSelected: (action) => _handleAction(context, action),
                  itemBuilder: (_) => [
                    if (item.fileExists)
                      const PopupMenuItem(value: 'open', child: Text('🎬 فتح')),
                    const PopupMenuItem(value: 'share', child: Text('📤 مشاركة')),
                    const PopupMenuItem(value: 'redownload', child: Text('🔄 إعادة تحميل')),
                    const PopupMenuItem(value: 'copyUrl', child: Text('📋 نسخ الرابط')),
                    const PopupMenuItem(value: 'delete', child: Text('🗑️ حذف')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### 5. فلترة المنصات

```dart
class PlatformFilterChips extends StatelessWidget {
  final PlatformType? selected;
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: const Text('الكل'),
            selected: selected == null,
            onSelected: (_) => context
              .read<HistoryBloc>()
              .add(FilterByPlatform(null)),
          ),
          const SizedBox(width: 8),
          ...PlatformType.values
            .where((p) => p != PlatformType.unknown)
            .map((platform) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: Text(platform.emoji),
                label: Text(platform.displayName),
                selected: selected == platform,
                onSelected: (_) => context
                  .read<HistoryBloc>()
                  .add(FilterByPlatform(platform)),
              ),
            )),
        ],
      ),
    );
  }
}
```

### 6. حالة السجل الفارغ

```dart
class EmptyHistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/empty_box.json',
            width: 200,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.noHistory,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'قم بتحميل أول فيديو من الشاشة الرئيسية',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
```

---

## ✅ معايير القبول

- [ ] كل تحميل مكتمل/فاشل يُحفظ تلقائياً في السجل
- [ ] صفحة السجل تعرض التحميلات مع صورة مصغرة ومعلومات
- [ ] التحميلات مُجمعة حسب التاريخ (اليوم، أمس، هذا الأسبوع...)
- [ ] البحث بالعنوان يعمل
- [ ] التصفية حسب المنصة تعمل
- [ ] سحب للحذف يعمل مع تأكيد
- [ ] زر إعادة التحميل يعمل
- [ ] زر المشاركة يعمل (share_plus)
- [ ] زر فتح الفيديو يعمل (إذا الملف موجود)
- [ ] حالة السجل الفارغ تعرض أنيميشن مع رسالة
- [ ] مسح السجل بالكامل يعمل مع تأكيد
- [ ] الواجهة تعمل في RTL و LTR

---

## 🧪 خطة الاختبار

```dart
group('HistoryBloc', () {
  test('should load history grouped by date', () {
    bloc.add(LoadHistory());
    expect(bloc.state.groupedItems, isNotEmpty);
  });
  
  test('should filter by platform', () {
    bloc.add(FilterByPlatform(PlatformType.youtube));
    expect(
      bloc.state.groupedItems.values.expand((l) => l).every(
        (item) => item.platformType == PlatformType.youtube,
      ),
      true,
    );
  });
  
  test('should search by title', () {
    bloc.add(SearchHistory('music'));
    // verify filtered results
  });
  
  test('should delete item', () {
    bloc.add(DeleteHistoryItem('id-1'));
    // verify item removed
  });
  
  test('should clear all history', () {
    bloc.add(ClearAllHistory());
    expect(bloc.state.isEmpty, true);
  });
});

group('HistoryRepositoryImpl', () {
  test('should group items by date correctly', () async {
    // add items with different dates
    final grouped = await repo.getGroupedByDate();
    expect(grouped.containsKey('اليوم'), true);
  });
});
```
