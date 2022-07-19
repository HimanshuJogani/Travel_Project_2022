import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:make_my_trip/core/base/base_state.dart';
import 'package:make_my_trip/core/theme/text_styles.dart';
import 'package:make_my_trip/features/hotel_detail/data/model/hotel_detail_model.dart';
import 'package:make_my_trip/features/hotel_detail/presentation/cubit/hotel_detail_cubit.dart';
import 'package:make_my_trip/utils/constants/string_constants.dart';
import 'package:make_my_trip/utils/extensions/sizedbox/sizedbox_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/make_my_trip_colors.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/features_item_widget.dart';
import '../widgets/loaction_widget.dart';
import '../widgets/review_container.dart';

class HotelDetailPage extends StatelessWidget {
  HotelDetailPage({Key? key}) : super(key: key);

  bool isLiked = false;
  bool isReadMore = false;
  int imgIndex = 0;
  HotelDetailModel? hotelDetailModel;

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return BlocBuilder<HotelDetailCubit, BaseState>(
      builder: (context, state) {
        if (state is StateOnKnownToSuccess) {
          hotelDetailModel = state.response;
        } else if (state is StateSearchResult) {
          isLiked = state.response;
        } else if (state is StateOnResponseSuccess) {
          imgIndex = state.response;
        } else if (state is StateOnSuccess) {
          isReadMore = state.response;
        }
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  final scrolled =
                      constraints.scrollOffset > screen.width * .55;
                  return SliverAppBar(
                    backgroundColor: MakeMyTripColors.colorWhite,
                    expandedHeight: screen.width * .7,
                    elevation: 0,
                    excludeHeaderSemantics: true,
                    floating: true,
                    pinned: true,
                    leading: IconButton(
                      onPressed: () {
                        debugPrint("back");
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: scrolled
                            ? MakeMyTripColors.colorBlack
                            : MakeMyTripColors.colorWhite,
                      ),
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<HotelDetailCubit>(context)
                              .onLikeTap(isLiked);
                        },
                        child: Icon(
                          (isLiked) ? Icons.favorite : Icons.favorite_border,
                          color: (isLiked)
                              ? MakeMyTripColors.colorRed
                              : (scrolled && !isLiked)
                                  ? MakeMyTripColors.colorBlack
                                  : MakeMyTripColors.colorWhite,
                          size: 28,
                        ),
                      ),
                      12.horizontalSpace,
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background: Stack(fit: StackFit.expand, children: [
                        PageView.builder(
                          itemCount: 4,
                          onPageChanged: (index) {
                            BlocProvider.of<HotelDetailCubit>(context)
                                .onSwipeIndicator(index);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(
                              hotelDetailModel?.images![index].imageUrl ??
                                  "https://raw.githubusercontent.com/Nik7508/radixlearning/main/makemytrip/makemytrip/assets/images/hotel_img.png",
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              bottom: 10, right: 10, left: 10),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DotsIndicator(
                                dotsCount: 4,
                                position: imgIndex.toDouble(),
                                decorator: DotsDecorator(
                                  activeSize: const Size(9.0, 9.0),
                                  activeColor: MakeMyTripColors.accentColor,
                                  color: MakeMyTripColors.colorBlack,
                                  activeShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: MakeMyTripColors.colorWhite,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "${hotelDetailModel?.images?.length} ${StringConstants.photos}",
                                      style: AppTextStyles.infoContentStyle,
                                    ),
                                    8.horizontalSpace,
                                    const Icon(Icons.image)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ]),
                    ),
                  );
                },
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                    delegate: SliverChildListDelegate(
                  [
                    RatingBar.builder(
                      ignoreGestures: true,
                      itemSize: 20,
                      initialRating: hotelDetailModel?.rating?.toDouble() ?? 3,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: MakeMyTripColors.accentColor,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    12.verticalSpace,
                    Text(hotelDetailModel?.hotelName ?? "Hotel name",
                        style: AppTextStyles.labelStyle),
                    Row(
                      children: [
                        Text("₹ ${hotelDetailModel?.price?.toString()} /night"),
                        const Spacer(),
                        CircleIconButton(
                          isRotete: false,
                          iconData: Icons.call,
                          iconBtn: () async {
                            var url = Uri.parse(
                                "tel:${hotelDetailModel?.phoneNumber}");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        )
                      ],
                    ),
                    12.verticalSpace,
                    Column(
                      children: [
                        Text(
                          hotelDetailModel?.description ?? "hotel description",
                          maxLines: (isReadMore) ? 10 : 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        ),
                        (hotelDetailModel?.description == null)
                            ? SizedBox()
                            : Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<HotelDetailCubit>(context)
                                        .onReadMoreTap(isReadMore);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      (isReadMore)
                                          ? StringConstants.readLess
                                          : StringConstants.readMore,
                                      style: const TextStyle(
                                          color: MakeMyTripColors.accentColor,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                    12.verticalSpace,
                    Wrap(
                      children: [
                        FeaturesItemWidget(
                            text:
                                hotelDetailModel?.features![0] ?? "feature 1"),
                        FeaturesItemWidget(
                            text:
                                hotelDetailModel?.features![1] ?? "feature 2"),
                        FeaturesItemWidget(
                            text:
                                hotelDetailModel?.features![2] ?? "feature 3"),
                        FeaturesItemWidget(
                            text:
                                hotelDetailModel?.features![3] ?? "feature 4"),
                      ],
                    ),
                    18.verticalSpace,
                    ReviewContainer(
                      icon: Icons.star_rounded,
                      leadingText: hotelDetailModel?.rating?.toString() ?? "3",
                      tralingText: StringConstants.seeAllReview,
                    ),
                    18.verticalSpace,
                    ReviewContainer(
                      leadingText: StringConstants.gallery,
                      tralingText: StringConstants.seeAllPhoto,
                    ),
                    18.verticalSpace,
                    Text(
                      StringConstants.location,
                      style: AppTextStyles.unselectedLabelStyle,
                    ),
                    12.verticalSpace,
                    Text(
                      hotelDetailModel?.address!.addressLine ??
                          "Hotel location",
                      maxLines: 2,
                      style: const TextStyle(
                        color: MakeMyTripColors.color70gray,
                      ),
                    ),
                    12.verticalSpace,
                    LocationViewWidet(
                      log:
                          hotelDetailModel?.address?.location?.latitude ?? 10.0,
                      lat: hotelDetailModel?.address?.location?.longitude ??
                          10.0,
                      titleName: hotelDetailModel?.hotelName! ?? "Hotel",
                      mapHeight: 200,
                    ),
                  ],
                )),
              )
            ],
          ),
          bottomNavigationBar: SafeArea(
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  StringConstants.selectRoom,
                  style: AppTextStyles.confirmButtonTextStyle,
                ),
                style: ElevatedButton.styleFrom(
                  primary: MakeMyTripColors.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}