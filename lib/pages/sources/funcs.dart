import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;



Future<Map<dynamic, dynamic>> getSingleComicDatas(String comicLink, String bookName, String bookImage) async {

  var base_url = 'https://www.comicsmode.com';
  var comicDatas = <Map<String, dynamic>>[];

  var newOneComicRequest = await http.get(Uri.parse(comicLink));
  var newOneComicRequestDatas = parser.parse(newOneComicRequest.body);
  var newOneComicRequestDatasList = newOneComicRequestDatas.querySelectorAll("div.col-sm-5");
  var newOneComicRequestDatasString = newOneComicRequestDatasList.toString();

  var comics = newOneComicRequestDatas.querySelector("div.col-sm-5");
  var status = comics?.querySelector("li.badge-list")?.text?.trim();
  var comicDetailDatas = comics?.querySelectorAll("ul.detail-data") ?? [];

  for (var comicDetailData in comicDetailDatas) {
    var issueDatas = [];
    var author;
    var publisher;
    var artist;

    var comicDetailList = comicDetailData.querySelectorAll("li");

    for (var comicDetail in comicDetailList) {
      var controlKey = comicDetail.querySelectorAll("span")[0].text.toLowerCase().trim();
      var controlValue = comicDetail.querySelectorAll("span").last.text.trim();

      if (controlKey == 'author') {
        author = controlValue;
        print(author);
      }
      if (controlKey == 'publisher') {
        publisher = controlValue;
        print(publisher);
      }
      if (controlKey == 'artist') {
        artist = controlValue;
        print(artist);
      }
    }

    var issues = newOneComicRequestDatas.querySelector("ul.issue-list");
    var issuesList = issues?.querySelectorAll('li') ?? [];

    for (var issue in issuesList) {
      var pageList = [];
      var issueName = issue.querySelector('a')?.text ?? '';
      var issueLink = "https://www.comicsmode.com/comics/"+(issue.querySelector('a')?.attributes['href'] ?? '');

      issueLink = issueLink.replaceAll("multi-page", "full-chapter");

      //print(issueName);
      //print(issueLink);


      issueDatas.add({'issue_name': issueName, 'issue_link': issueLink});
    }

    comicDatas.add({
      'book_name': bookName,
      'book_image': bookImage,
      'status': status,
      'author': author,
      'publisher': publisher,
      'artist': artist,
      'issues': issueDatas,
      'book_url' : comicLink,
    });
  }

  return comicDatas.isNotEmpty ? comicDatas[0] : {};
}


