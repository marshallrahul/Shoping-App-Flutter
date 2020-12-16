import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products_provider.dart';

class EditProducts extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageController = new TextEditingController();
  final _form = GlobalKey<FormState>();
  var _initialValue = {
    'id': '',
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _editProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  bool _isInit = true;

  // https://thumbs-prod.si-cdn.com/c0VP9nb5bbooVSqQEjHk3q9S35c=/800x600/filters:no_upscale()/https://public-media.si-cdn.com/filer/91/91/91910c23-cae4-46f8-b7c9-e2b22b8c1710/lostbook.jpg
  // https://images-na.ssl-images-amazon.com/images/I/81fcxY8naJL._SX425_.jpg

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);

    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final existingProductId =
          ModalRoute.of(context).settings.arguments as String;
      if (existingProductId != null) {
        _editProduct = Provider.of<Products>(context)
            .items
            .firstWhere((prod) => prod.id == existingProductId);
        _initialValue = {
          'id': _editProduct.id,
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'imageUrl': _editProduct.imageUrl,
        };
        _imageController.text = _editProduct.imageUrl;
      }
      print(existingProductId);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final _productId = ModalRoute.of(context).settings.arguments as String;
    if (_productId == null) {
      Provider.of<Products>(context, listen: false).addProdItems(_editProduct);
    } else {
      Provider.of<Products>(context, listen: false)
          .updateProducts(_editProduct, _productId);
    }
    Navigator.of(context).pop();
  }

  void _updateImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageController.text.startsWith('http') ||
              !_imageController.text.startsWith('https')) &&
          (!_imageController.text.endsWith('.png') ||
              !_imageController.text.endsWith('.jpg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                initialValue: _initialValue['title'],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a text';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editProduct = Product(
                    id: null,
                    title: value,
                    description: _editProduct.description,
                    price: _editProduct.price,
                    imageUrl: _editProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                initialValue: _initialValue['price'],
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a number';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editProduct = Product(
                    id: null,
                    title: _editProduct.title,
                    description: _editProduct.description,
                    price: double.parse(value),
                    imageUrl: _editProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.text,
                focusNode: _descriptionFocusNode,
                initialValue: _initialValue['description'],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a text';
                  }
                  if (value.length < 10) {
                    return 'Please provide more info';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editProduct = Product(
                    id: null,
                    title: _editProduct.title,
                    description: value,
                    price: _editProduct.price,
                    imageUrl: _editProduct.imageUrl,
                  );
                },
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100.0,
                      width: 100.0,
                      child: _imageController.text.isEmpty
                          ? Text('Enter a URL')
                          : Image.network(
                              _imageController.text,
                              fit: BoxFit.cover,
                            ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        controller: _imageController,
                        focusNode: _imageUrlFocusNode,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _saveForm(),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a url';
                          }
                          if ((!value.startsWith('http') ||
                                  !value.startsWith('https')) &&
                              (!value.endsWith('.png') ||
                                  !value.endsWith('.jpg'))) {
                            return 'Please provide a valid URL';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                            id: null,
                            title: _editProduct.title,
                            description: _editProduct.description,
                            price: _editProduct.price,
                            imageUrl: value,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
