import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/productlist.dart';
import 'package:shopping/providers/productmodel.dart';

class EditProducts extends StatefulWidget {
  static const routename = '/edit';
  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageTextController = TextEditingController();
  final _imageFocusNode = FocusNode();
  var _form = GlobalKey<FormState>();
  bool _isInit = true;
  bool isLoading = false;
  Product _editedProduct = Product(
      description: '',
      id: null,
      imageUrl: '',
      price: null,
      title: '',
      isFavourite: false);
  var initialValues = {'imageUrl': '', 'price': '', 'desc': '', 'title': ''};
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageTextController.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);
    _imageFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      String id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        _editedProduct = Provider.of<ProductList>(context).findByID(id);
        initialValues = {
          'imageUrl': '',
          'price': _editedProduct.price.toString(),
          'desc': _editedProduct.description,
          'title': _editedProduct.title
        };
        _imageTextController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    bool isValid = _form.currentState
        .validate(); //or set autovalidate key to true in form widget
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      _form.currentState.save();
      if (_editedProduct.id != null) {
        try {
          await Provider.of<ProductList>(context, listen: false)
              .update(_editedProduct.id, _editedProduct);
        } catch (err) {
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    content: Text("Could not edit product"),
                    title: Text("ERROR"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      )
                    ],
                  ));
        }
      } else {
        try {
          await Provider.of<ProductList>(context, listen: false)
              .addNewProduct(_editedProduct);
        } catch (err) {
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    content: Text("Could not add product"),
                    title: Text("ERROR"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      )
                    ],
                  ));
        }
      }
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EDIT PRODUCT"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: initialValues['title'],
                        validator: (val) {
                          if (val.isEmpty)
                            return 'Enter title';
                          else
                            return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction
                            .next, //sets the value of key present in the keyboard whivh usually displays next line or enter
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            title: value,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: initialValues['price'],
                        validator: (val) {
                          if (val.isEmpty)
                            return 'Enter Price';
                          else if (double.tryParse(val) == null)
                            return 'Enter a valid price';
                          else if (double.parse(val) <= 0)
                            return 'Price must be greater than zero';
                          else
                            return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              description: _editedProduct.description,
                              id: _editedProduct.id,
                              imageUrl: _editedProduct.imageUrl,
                              price: double.parse(value),
                              title: _editedProduct.title,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                      TextFormField(
                        initialValue: initialValues['desc'],
                        validator: (val) {
                          if (val.isEmpty)
                            return 'Enter title';
                          else if (val.length < 10)
                            return 'Too short';
                          else
                            return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType
                            .multiline, //gives the text input action key the value of next line
                        focusNode: _descFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                            description: value,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            title: _editedProduct.title,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 5, 0),
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            )),
                            height: 100,
                            width: 100,
                            child: _imageTextController.text.isEmpty
                                ? null
                                : Image.network(
                                    _imageTextController.text,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: (val) {
                                if (val.isEmpty)
                                  return 'Enter Image url ';
                                else if (!val.startsWith('http') &&
                                        !val.startsWith('https') ||
                                    !val.endsWith('jpeg') &&
                                        !val.endsWith('jpg') &&
                                        !val.endsWith('png'))
                                  return 'Enter a valig image url';
                                else
                                  return null;
                              },
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              textInputAction: TextInputAction
                                  .done, //important so that clicking done shows the image
                              controller: _imageTextController,
                              focusNode: _imageFocusNode,
                              onSaved: (value) {
                                _editedProduct = Product(
                                    description: _editedProduct.description,
                                    id: _editedProduct.id,
                                    imageUrl: value,
                                    price: _editedProduct.price,
                                    title: _editedProduct.title,
                                    isFavourite: _editedProduct.isFavourite);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
