import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:get/get.dart';

class ProductDetails extends StatefulWidget {
  final dynamic data;
  const ProductDetails({Key? key, this.data}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  double? averageRating;

  void updateFirestore(double ratingValue, String docId) async {
    String collectionName = 'products';

    // Get the Firestore document reference
    DocumentReference docRef =
        FirebaseFirestore.instance.collection(collectionName).doc(docId);

    // Update the document in Firestore
    await docRef.update({
      'p_rating': FieldValue.arrayUnion([ratingValue.toString()])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: darkGrey,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: boldText(
              text: "${widget.data['p_name']}", color: fontGrey, size: 16.0),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            VxSwiper.builder(
                autoPlay: true,
                itemCount: widget.data['p_imgs'].length,
                aspectRatio: 16 / 9,
                viewportFraction: 1.8,
                height: 350,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.data['p_imgs'][index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                }),
            10.heightBox,
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title and detail screen
                  boldText(
                      text: "${widget.data['p_name']}",
                      color: fontGrey,
                      size: 16.0),
                  10.heightBox,

                  Row(
                    children: [
                      boldText(
                          text: "${widget.data['p_category']}",
                          color: fontGrey,
                          size: 16.0),
                      10.widthBox,
                      normalText(
                          text: "${widget.data['p_subcategory']}",
                          color: fontGrey,
                          size: 16.0)
                    ],
                  ),
                  15.heightBox,

                  // rating

                  10.heightBox,

                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .doc(widget.data.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // Get the data from the snapshot
                        Map<String, dynamic>? data =
                            snapshot.data?.data() as Map<String, dynamic>?;
                        // Convert the list of strings to a list of doubles
                        List<double> doubleRatingValues =
                            (data?['p_rating'] as List<dynamic>)
                                .map((value) => double.parse(value.toString()))
                                .toList();
                        // Calculate the average
                        double average =
                            doubleRatingValues.reduce((a, b) => a + b) /
                                doubleRatingValues.length;
                        // Return the rating widget with the average value
                        return VxRating(
                          value: average,
                          onRatingUpdate: (value) {
                            updateFirestore(
                                double.parse(value), widget.data.id);
                          },
                          normalColor: textfieldGrey,
                          selectionColor: golden,
                          isSelectable: true,
                          count: 5,
                          maxRating: 5,
                          size: 24,
                          stepInt: false,
                        );
                      } else if (snapshot.hasError) {
                        // Return an error widget if there is an error
                        return Text('Something went wrong');
                      } else {
                        // Return a loading widget if there is no data yet
                        return CircularProgressIndicator();
                      }
                    },
                  ),

                  boldText(
                      text: "\$${widget.data['p_price']}",
                      color: red,
                      size: 18.0),
                  20.heightBox,
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                              width: 100,
                              child: boldText(text: "Color", color: fontGrey)),
                          Row(
                            children: List.generate(
                              widget.data['p_colors'].length,
                              (index) => VxBox()
                                  .size(40, 40)
                                  .roundedFull
                                  .color(Color(widget.data['p_colors'][index]))
                                  .margin(EdgeInsets.symmetric(horizontal: 4))
                                  .make()
                                  .onTap(() {}),
                            ),
                          ),
                        ],
                      ),
                      10.heightBox,
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: boldText(text: "Quantity", color: darkGrey),
                          ),
                          normalText(
                              text: "${widget.data['p_quantity']} items",
                              color: fontGrey)
                        ],
                      )
                    ],
                  ).box.white.padding(EdgeInsets.all(8.0)).make(),
                  Divider(),
                  20.heightBox,
                  // descripton Section
                  boldText(text: "Description", color: fontGrey),
                  10.heightBox,
                  normalText(text: "${widget.data['p_desc']}", color: fontGrey)
                ],
              ),
            ),
          ],
        )));
  }
}
