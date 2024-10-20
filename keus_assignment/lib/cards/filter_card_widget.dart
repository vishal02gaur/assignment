import 'package:flutter/material.dart';

import '../bloc/home/home_state_bloc.dart';
import '../theme/colors.dart';

class FilterCardWidget extends StatelessWidget {
  final FilterCard card;
  final Function(Filter filter) onFilter;

  const FilterCardWidget(
      {super.key, required this.card, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(child: Icon(Icons.filter_list))),
              );
            }
            final item = card.filters[index - 1];
            return InkWell(
              onTap: () => onFilter(item),
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color:
                          item.isSelected ? AppColors.button : AppColors.grey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    item.name,
                    style: TextStyle(
                        color:
                            item.isSelected ? Colors.white : AppColors.button),
                  ))),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 16,
            );
          },
          itemCount: card.filters.length + 1),
    );
  }
}
