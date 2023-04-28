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

  Map<String, String> _initValues= {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){

      var p = ModalRoute.of(context)?.settings.arguments;
      print('p: ${p}');

     // final productId = ModalRoute.of(context)?.settings.arguments as String;
      var productId = ModalRoute.of(context)?.settings.arguments;

      if (productId != null){
        productId = productId as String;
        final product = Provider.of<ProductsProvider>(context, listen: false).findById(productId);
        _editedProduct = product;

        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }

    }
    _isInit = false;
    super.didChangeDependencies();
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

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid =  _form.currentState?.validate();
    if(!isValid!){
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });

   /* print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.price);
    print(_editedProduct.imageUrl);
    print(_editedProduct.id);*/

    //обновить существующий товар, а не добавлять новый такой же
    if(_editedProduct.id.isNotEmpty){
      /*await*/ Provider
          .of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
    else{
      try{
        await Provider
            .of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct); //return Future<void>
      }
      catch(error){
         await showDialog<Null>(
            context: context,
            builder: (builderContext) => AlertDialog(
              title: Text('Произошла ошибка'),
              content: Text('Что-то пошло не так :( '),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(builderContext).pop(),
                  child: Text('Ок'),),
              ],
            )
        );
      }
      finally{
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
      // await Provider
      //     .of<ProductsProvider>(context, listen: false)
      //     .addProduct(_editedProduct) //return Future<void>
      //     .catchError((onError){ //перехватываем возможное исключений из ProductProvider
      //     return showDialog<Null>(
      //           context: context,
      //           builder: (builderContext) => AlertDialog(
      //             title: Text('Произошла ошибка'),
      //             content: Text('Что-то пошло не так :( ${onError.toString()}'),
      //             actions: [
      //               TextButton(
      //                   onPressed: () => Navigator.of(builderContext).pop(),
      //                   child: Text('Ок'),),
      //             ],
      //           )
      //       );
      // })
       //   .then((_){
       //  setState(() {
       //    _isLoading = false;
       //  });
       //  Navigator.of(context).pop();
      // }
      // );
    }
    // setState(() {
    //   _isLoading = false;
    // });
    // Navigator.of(context).pop();
    // Navigator.of(context).pop();
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator(),)
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
            child: ListView(
          children: [
            TextFormField(
              initialValue: _initValues['title'],
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
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: value ?? 'нет названия',
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl);
              },
            ),
            TextFormField(
              initialValue: _initValues['price'],
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
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value ?? '-100.0'),
                    imageUrl: _editedProduct.imageUrl);
              },
            ),
            TextFormField(
              initialValue: _initValues['description'],
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
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
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
                  // initialValue: _initValues['imageUrl'],
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
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
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
