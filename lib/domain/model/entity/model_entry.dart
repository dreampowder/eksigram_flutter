import 'package:eksigram/domain/model/entity/model_user.dart';

class ModelEntry{
  String id;
  String body;
  List<String> images;
  int favCount;
  ModelUser author;

  ModelEntry({required this.id,required  this.body,required  this.images,required  this.author,required  this.favCount});
}