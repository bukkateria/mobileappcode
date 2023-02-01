import 'package:bukateria/cubit/place_search_cubit/place_search_cubit.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class PlaceSearch extends StatelessWidget {
  Function onSelection;
  PlaceSearch({required this.onSelection, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocListener<PlaceSearchCubit, PlaceSearchState>(listener: (context, state) {

     /* if (state.status == PostStatus.save) {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vlog Successfully saved!")));
      }else if (state.status == PostStatus.publish) {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vlog Successfully published!")));
        Get.back();
      }else if (state.status == PostStatus.error) {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong!")));
      }else if(state.status == PostStatus.submitting){
        CommonViews.showProgressDialog(context);
      }*/
    }, child: BlocBuilder<PlaceSearchCubit, PlaceSearchState>(
        builder: (context, state)
    {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 80,
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                    child: CustomInput(
                      height: 70,
                      borderRadius: 10,
                      filled: true,
                      bgcolor: white,
                      labelText: "Search location",
                      suffixIcon: Icons.search,
                      onChanged: (text) {
                        context.read<PlaceSearchCubit>().searchPlace(text);
                      },
                    ))
              ],
            ),
          ),
        ),
        body: state.placesList == null || state.placesList!.isEmpty ?
        Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              child: Image.asset(
                "assets/images/location.png",
                width: 100,
                height: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                "Add a place of origin",
                style: title3.copyWith(color: Colors.black38),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              child: Text(
                "Indicate your country, state, town or region where your menu is originating from ",
                style: body3.copyWith(color: Colors.black38),
              ),
            )
          ],
        )
            : ListView.builder(
            itemCount: state.placesList!.length,
            itemBuilder: (context, index){
          return InkWell(
            onTap: (){
              onSelection(state.placesList![index]["description"].toString());
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.all(12),
              child: Text(
                state.placesList![index]["description"].toString(),
                style: body3,
              ),
            ),
          );
        }),
      );
    }),
    );
  }
}
