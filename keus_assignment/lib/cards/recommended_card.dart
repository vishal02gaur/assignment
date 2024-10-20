import 'package:flutter/material.dart';
import 'package:keus_assignment/utils.dart';

import '../bloc/home/home_state_bloc.dart';
import '../images.dart';
import '../models/food_item.dart';
import '../theme/colors.dart';

class RecommendedCard extends StatefulWidget {
  final List<RecommendedCardData> foodList;
  final Function(FoodItem item) onClick;

  const RecommendedCard({super.key, required this.foodList, required this.onClick});

  @override
  State<RecommendedCard> createState() => _RecommendedCardState();
}

class _RecommendedCardState extends State<RecommendedCard>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.foodList.isEmpty) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            "Hits of the Week",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
          ),
        ),
        SizedBox(
          height: 225,
          child: PageView(
            controller: _pageController,
            children: widget.foodList
                .map((item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: () => widget.onClick(item.item),
                child: _RecommendedCardItem(
                  item: item,
                ),
              ),
            ))
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const hPadding = 4.0;
              final barWidth = (constraints.maxWidth / widget.foodList.length) -
                  hPadding * 2;
              return Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        widget.foodList.length,
                            (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: hPadding),
                          child: SizedBox(
                              width: barWidth,
                              child: buildInactiveDot(index)),
                        )),
                  ),
                  AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double page = _pageController.hasClients
                          ? _pageController.page ?? _currentPage.toDouble()
                          : _currentPage.toDouble();
                      return Transform.translate(
                        offset: Offset(page * (barWidth + hPadding * 2), 0),
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: hPadding),
                          child: SizedBox(
                              width: barWidth, child: buildActiveDot()),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildActiveDot() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 4.0,
      decoration: BoxDecoration(
        color: AppColors.button,
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }

  Widget buildInactiveDot(int index) {
    return Container(
      height: 4.0,
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }
}

class _RecommendedCardItem extends StatelessWidget {
  final RecommendedCardData item;

  const _RecommendedCardItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 15,
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      item.color,
                      item.color.withOpacity(0.3),
                      item.color.withOpacity(0.0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                AppImages.foodPlaceHolder,
                height: 140,
                width: 140,
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        maxLines: 2,
                        item.item.description,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(item.item.price.toCurrency(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
