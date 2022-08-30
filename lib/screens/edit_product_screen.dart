import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    price: 0.0,
  );
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments.toString();

      if (productId != 'null') {
        final product = Provider.of<Products>(context).findById(productId!);
        _editedProduct = product;

        _initValues = {
          'title': product.title,
          'description': product.description,
          'price': product.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = product.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValidate = _form.currentState!.validate();
    if (!isValidate) {
      return;
    }
    _form.currentState?.save();
    if (_editedProduct.id != '') {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(
        _editedProduct,
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                initialValue: _initValues['title'],
                onSaved: (value) => _editedProduct = Product(
                  id: _editedProduct.id,
                  title: value ?? '',
                  description: _editedProduct.description,
                  imageUrl: _editedProduct.imageUrl,
                  price: _editedProduct.price,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a title';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) => _editedProduct = Product(
                  id: _editedProduct.id,
                  title: _editedProduct.title,
                  description: _editedProduct.description,
                  imageUrl: _editedProduct.imageUrl,
                  price: double.parse(value!),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a price!';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number!';
                  }
                  if (double.tryParse(value)! <= 0) {
                    return 'Please enter a number greater than zero!';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) => _editedProduct = Product(
                  id: _editedProduct.id,
                  title: _editedProduct.title,
                  description: value ?? '',
                  imageUrl: _editedProduct.imageUrl,
                  price: _editedProduct.price,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a description!';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters!';
                  }

                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? const Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onSaved: (value) => _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        imageUrl: value ?? '',
                        price: _editedProduct.price,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a Url!';
                        }
                        if (!value.startsWith('https') &&
                            !value.endsWith('jpg') &&
                            !value.endsWith('jpeg') &&
                            !value.endsWith('png')) {
                          return 'Should be image Url!';
                        }

                        return null;
                      },
                      onFieldSubmitted: (_) => _saveForm(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
