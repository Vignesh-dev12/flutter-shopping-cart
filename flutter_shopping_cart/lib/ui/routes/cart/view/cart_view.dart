import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/core/model/base_model.dart';
import 'package:flutter_shopping_cart/core/shared_preference_helper.dart';
import 'package:flutter_shopping_cart/route_setup.dart';
import 'package:flutter_shopping_cart/ui/routes/cart/model/products_model.dart';
import 'package:flutter_shopping_cart/ui/routes/cart/view_model/cart_view_model.dart';
import 'package:flutter_shopping_cart/ui/themes/app_colors.dart';
import 'package:flutter_shopping_cart/ui/widgets/base_widget.dart';
import 'package:flutter_shopping_cart/ui/widgets/loading_view.dart';
import 'package:google_fonts/google_fonts.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<CartViewModel>(
      model: CartViewModel(),
      onModelReady: (model) => model.getCategories(),
      builder: (context, model, _) {
        return model.state == ViewState.BUSY
            ? Scaffold(body: Loading())
            : DefaultTabController(
                length: model.productsModel!.categories!.length,
                child: Scaffold(
                  appBar: AppBar(
                    bottom: TabBar(
                      indicatorColor: accentColor,
                      isScrollable: true,
                      indicatorWeight: 3.5,
                      tabs: model.productsModel!.categories!.keys
                          .map((categoryName) => Tab(text: categoryName))
                          .toList(),
                    ),
                    title: Text(
                      'Cart',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w700),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: InkWell(
                          onTap: () => _showPopupMenu(),
                          child: CircleAvatar(
                            radius: 22.0,
                            backgroundImage: NetworkImage(
                                "https://alicepropertymanagement.com/images/temp-profile.jpg"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: TabBarView(
                    children:
                        model.productsModel!.categories!.values.map((products) {
                      return Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: ProductsListView(
                            key: ObjectKey(products), products: products),
                      );
                    }).toList(),
                  ),
                ),
              );
      },
    );
  }

  void _showPopupMenu() async {
    var selectedItem = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width, 80, 0, 0),
      items: [
        PopupMenuItem<String>(
          height: 37,
          child: const Text('Logout'),
          value: 'logout',
        ),
      ],
      elevation: 8.0,
    );
    if (selectedItem == 'logout') {
      PreferenceHelper.setBool(PreferenceConst.isUserLogin, false);
      Navigator.pop(context);
      Navigator.pushNamed(context, RoutePaths.LoginView);
    }
  }

}

class ProductsListView extends StatefulWidget {
  final List<Product> products;

  ProductsListView({
    required Key key,
    required this.products,
  }); //: super(key: key);

  @override
  _ProductsListViewState createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView> {
  List<ValueNotifier<bool>> showSpecificationsNotifier = [];

  @override
  void initState() {
    super.initState();
    widget.products.forEach((element) {
      showSpecificationsNotifier.add(ValueNotifier(false));
    });
  }

  @override
  void dispose() {
    super.dispose();
    showSpecificationsNotifier.forEach((element) {
      element.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: primaryColor,
        label: Text(
          'Add item',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ReorderableListView.builder(
        itemCount: widget.products.length,
        onReorder: (int oldIndex, int newIndex) {
          var item = widget.products[oldIndex];
          widget.products.removeAt(oldIndex);
          widget.products.insert(newIndex, item);
          setState(() {});
        },
        itemBuilder: (context, index) {
          return _cartItem(widget.products[index], index);
        },
      ),
    );
  }

  Widget _cartItem(Product product, int index) {
    return Dismissible(
      key: ObjectKey(product),
      onDismissed: (direction) {
        widget.products.remove(product);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product.name} removed from cart')));
      },
      background: _cartItemBackground(true),
      secondaryBackground: _cartItemBackground(false),
      child: Container(
        padding:
            const EdgeInsets.only(top: 18.0, left: 5.0, right: 5.0, bottom: 0),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    showSpecificationsNotifier[index].value =
                        !showSpecificationsNotifier[index].value;
                  },
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Container(
                            width: 103,
                            height: 103,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                product.image!,
                                width: 103,
                                height: 103,
                                //fit: BoxFit.cover,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 2.0,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: Text(
                                    product.name!,
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Model Number: ${product.modelNumber}',
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 9.0),
                                  child: Text(
                                    '‎₹' + product.price.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                QuantityButton()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _specificationView(product, index),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                  child: Container(
                    height: 0.4,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _specificationView(Product product, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ValueListenableBuilder<bool>(
        valueListenable: showSpecificationsNotifier[index],
        child: Container(
          color: lightGreyColor,
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: product.specifications!.length,
            padding: EdgeInsets.only(bottom: 10),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 0.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        product.specifications!.keys.toList()[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          product.specifications!.values
                              .toList()[index]
                              .toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        builder: (context, value, child) {
          return AnimatedCrossFade(
            firstChild: child!,
            secondChild: Container(),
            crossFadeState:
                value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 500),
          );
        },
      ),
    );
  }

  Widget _cartItemBackground(bool isBackground) {
    return Container(
      color: accentColor.withOpacity(0.2),
      child: Align(
        alignment: isBackground ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: isBackground
              ? EdgeInsets.only(left: 30.0)
              : EdgeInsets.only(right: 30.0),
          child: Icon(
            Icons.delete_outline_outlined,
            size: 40,
          ),
        ),
      ),
    );
  }
}

class QuantityButton extends StatefulWidget {
  @override
  _QuantityButtonState createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<QuantityButton> {
  TextEditingController textEditingController =
      TextEditingController(text: '1');

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _quantityButton();
  }

  Widget _quantityButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          onTap: () {},
          child: Container(
            width: 30,
            height: 30,
            child: Icon(
              Icons.remove,
              color: Colors.black,
            ),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: 42,
          height: 31,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400]!,
                offset: Offset(1, 1),
                blurRadius: 3,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: textEditingController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(border: InputBorder.none),
              onChanged: (String value) {},
            ),
          ),
        ),
        SizedBox(width: 10),
        InkWell(
          onTap: () {},
          child: Container(
            width: 30,
            height: 30,
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
