class site{
  late final Map<String,dynamic> jsonData;
  late final String baseUrl;
  late final String siteIcon;
  late final String bookName;
  late final String bookUrl;
  late final String bookStatus;
  late final String bookAuthor;
  late final String bookPublisher;
  late final String bookArtist;
  late final int bookListLength;
  late final List<Map<String,dynamic>> bookIssuesList;

  site({required jsonData}){
    this.jsonData = jsonData;
    baseUrl = jsonData['base_url'];
    siteIcon = jsonData['site_icon'];
    bookName = jsonData['properties']['book_name'];
    bookUrl = jsonData['properties']['book_url'];
    bookStatus = jsonData['properties']['status'];
    bookAuthor = jsonData['properties']['author'];
    bookPublisher = jsonData['properties']['publisher'];
    bookArtist = jsonData['properties']['artist'];
    bookListLength = jsonData['properties'].length;
    bookIssuesList = jsonData['properties']['issues'];

  }

}