class ResTopic{
  int pageCount;
  int page;
  String id;
  List<ResEntry> entries;
  ResTopic(this.pageCount, this.page, this.id, this.entries);
}

class ResEntry {
  String id;
  int favCount;
  String content;
  List<String> images;
  ResUser author;
  ResEntry(this.id, this.favCount, this.content, this.images, this.author);
}

class ResUser {
  String id;
  String userName;
  String photoUrl;
  ResUser(this.id, this.userName, this.photoUrl);
}
