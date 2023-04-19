import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products_provider.dart';


class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
      id: '',
      title: '',
      description: '',
      price: 0.0,
      imageUrl: '');

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      String v = _imageUrlController.text ?? '';
      if(/*v.isEmpty ||*/
          !v.startsWith('http') && !v.startsWith('https') ||
          !v.endsWith('.png') && !v.endsWith('.jpg') && !v.endsWith('.jpeg')
      ){
        return ;
      }

      setState(() {

      });
    }
  }

  void _saveForm(){
    final isValid =  _form.currentState?.validate();
    if(!isValid!){
      return;
    }
    _form.currentState?.save();
   /* print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.price);
    print(_editedProduct.imageUrl);
    print(_editedProduct.id);*/
    Provider.of<ProductsProvider>(context, listen: false).addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать товар'),
        actions: [
          IconButton(
              onPressed: _saveForm,
              icon: Icon(Icons.save,),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
            child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Название'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              validator: (value){
                String v = value ?? '';
                if(v.isEmpty){
                  return 'Введите название';
                }
                return null;
              } ,
              onSaved: (value){
                _editedProduct = Product(
                    id: '',
                    title: value ?? 'нет названия',
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Цена'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
              validator: (value){
                String v = value ?? '';
                if(v.isEmpty){
                  return 'Введите цену';
                }
                if(double.tryParse(v) == null){
                  return 'Введите корректное число';
                }
                if(double.tryParse(v)! <= 0){
                  return 'Цена не может быть нулём или меньше';
                }
                return null;
              },
              onSaved: (value){
                _editedProduct = Product(
                    id: '',
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value ?? '-100.0'),
                    imageUrl: _editedProduct.imageUrl);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Описание'),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              focusNode: _descriptionFocusNode,
              validator: (value){
                String v = value ?? '';
                if(v.isEmpty){
                  return 'должно быть описание';
                }
                if(v.length < 10){
                  return 'Описание меньше 10 символов';
                }
                return null;
              },
              onSaved: (value){
                _editedProduct = Product(
                    id: '',
                    title: _editedProduct.title,
                    description: value ?? 'нет описания',
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl);
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(top: 8, right: 10,),
                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                child: _imageUrlController.text.isEmpty
                    ? Text('Нужен URL')
                    : FittedBox(child: Image.network(_imageUrlController.text, fit: BoxFit.cover,),),


              ),
              Expanded(

                child: TextFormField(
                  decoration: InputDecoration( labelText: 'URL картинки'),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  controller: _imageUrlController,
                  focusNode: _imageUrlFocusNode,
                  onFieldSubmitted: (_) => _saveForm(),
                  onEditingComplete: () {
                    setState(() {});
                  },
                  validator: (value){
                    String v = value ?? '';
                    if(v.isEmpty){
                      return 'должен быть URL';
                    }
                    if(!v.startsWith('http') && !v.startsWith('https')){
                      return 'Некорректный URL';
                    }
                    if(!v.endsWith('.png') && !v.endsWith('.jpg') && !v.endsWith('.jpeg')){
                      return 'Некорректный формат изображения';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _editedProduct = Product(
                        id: '',
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: value ?? 'Нет URL');
                  },
                ),
              ),
            ],),
          ],
        ),
        ),
      ),
    );
  }
}
