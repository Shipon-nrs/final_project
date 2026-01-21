import 'package:uuid/uuid.dart';
import '../models/lost_item.dart';
import 'supabase_config.dart';

class DatabaseService {
  final supabase = SupabaseConfig.client;
  static const String tableName = 'lost_items';
  static const uuid = Uuid();

  Future<List<LostItem>> getAllItems() async {
    try {
      final response = await supabase
          .from(tableName)
          .select('id, name, place, time, category, image, description, phone, user_id, user_name, created_at, updated_at')
          .order('created_at', ascending: false);
      
      final items = (response as List)
          .map((json) => LostItem.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return items;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LostItem>> getUserItems(String userId) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      final items = (response as List)
          .map((json) => LostItem.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return items;
    } catch (e) {
      rethrow;
    }
  }

  Future<LostItem?> getItemById(String itemId) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('id', itemId)
          .single();
      
      return LostItem.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<LostItem> addItem(LostItem item) async {
    try {
      final newId = uuid.v4();
      final now = DateTime.now();
      
      final itemToSave = item.copyWith(
        id: newId,
        userId: SupabaseConfig.currentUser?.id,
        userName: SupabaseConfig.currentUser?.userMetadata?['name'] as String?,
        createdAt: now,
        updatedAt: now,
      );

      await supabase
          .from(tableName)
          .insert(itemToSave.toJson());

      return itemToSave;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateItem(LostItem item) async {
    try {
      final updatedItem = item.copyWith(
        updatedAt: DateTime.now(),
      );

      await supabase
          .from(tableName)
          .update(updatedItem.toJson())
          .eq('id', item.id ?? '');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteItem(String itemId) async {
    try {
      await supabase
          .from(tableName)
          .delete()
          .eq('id', itemId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LostItem>> searchItems(String query) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .or('name.ilike.%$query%,place.ilike.%$query%,category.ilike.%$query%')
          .order('created_at', ascending: false);
      
      final items = (response as List)
          .map((json) => LostItem.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return items;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LostItem>> getItemsByCategory(String category) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);
      
      final items = (response as List)
          .map((json) => LostItem.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return items;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<LostItem>> streamAllItems() {
    return supabase
        .from(tableName)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) {
          return (data as List)
              .map((json) => LostItem.fromJson(json as Map<String, dynamic>))
              .toList();
        });
  }
}
