import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/state_providers.dart';

class PriceSliderFilter extends ConsumerStatefulWidget {
  const PriceSliderFilter({super.key});

  @override
  ConsumerState<PriceSliderFilter> createState() => _PriceSliderFilterState();
}

class _PriceSliderFilterState extends ConsumerState<PriceSliderFilter> {
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(filterProvider);
    _currentRangeValues = RangeValues(filter.minPrice, filter.maxPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Price Range: \$${_currentRangeValues.start.round()} - \$${_currentRangeValues.end.round()}'),
        RangeSlider(
          values: _currentRangeValues,
          min: 0,
          max: 2000,
          divisions: 20,
          labels: RangeLabels(
            '\$${_currentRangeValues.start.round()}',
            '\$${_currentRangeValues.end.round()}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values; // Ephemeral local state update
            });
          },
          onChangeEnd: (RangeValues values) {
            // Commit to global state and trigger Supabase query
            ref.read(filterProvider.notifier).updatePriceRange(values.start, values.end);
          },
        ),
      ],
    );
  }
}