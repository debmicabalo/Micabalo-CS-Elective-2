import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

// 2. Filter & Pagination State Management
final filterProvider = StateNotifierProvider<FilterNotifier, ProductFilter>((ref) => FilterNotifier());

class FilterNotifier extends StateNotifier<ProductFilter> {
  FilterNotifier() : super(ProductFilter());
  
  void updatePriceRange(double min, double max) {
    state = state.copyWith(minPrice: min, maxPrice: max, pageIndex: 0); // Reset page on filter change
  }
  
  void nextPage() => state = state.copyWith(pageIndex: state.pageIndex + 1);
  void prevPage() {
    if (state.pageIndex > 0) state = state.copyWith(pageIndex: state.pageIndex - 1);
  }
}

// 3. Supabase Data Fetching (Filtering & Pagination)
final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final filter = ref.watch(filterProvider);
  final supabase = Supabase.instance.client;
  
  // Pagination logic: 6 items per page
  const itemsPerPage = 6;
  final from = filter.pageIndex * itemsPerPage;
  final to = from + itemsPerPage - 1;

  final response = await supabase
      .from('products')
      .select()
      .gte('price', filter.minPrice)
      .lte('price', filter.maxPrice)
      .order('price', ascending: true)
      .range(from, to);

  return (response as List).map((e) => Product.fromMap(e)).toList();
});