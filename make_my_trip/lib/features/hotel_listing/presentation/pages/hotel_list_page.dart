import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:make_my_trip/core/theme/make_my_trip_colors.dart';
import 'package:make_my_trip/core/theme/text_styles.dart';
import 'package:make_my_trip/features/splash/presentation/widgets/hotel_list_view_widget.dart';
import 'package:make_my_trip/utils/constants/string_constants.dart';
import '../../hotel_list_injection_container.dart' as di;
import '../cubits/hotel_list_cubit.dart';

class HotelListPage extends StatelessWidget {
  const HotelListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: MakeMyTripColors.color30gray,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                          // const Spacer(),
                          Text(
                            StringConstants.hotelListPageTitle,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.unselectedLabelStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.search,
                    color: MakeMyTripColors.accentColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.edit_note_rounded),
                  ),
                ),
              ],
            ),
            Container(
              height: 40,
              width: double.infinity,
              color: MakeMyTripColors.color0gray,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    StringConstants.recommendedText,
                    style: AppTextStyles.unselectedLabelStyle,
                  ),
                ),
              ),
            ),
            Expanded(
                child: BlocProvider(
              create: (context) => di.sl<HotelListCubit>(),
              child: const HotelListViewWidget(),
            ))
          ],
        ),
      ),
    );
  }
}
