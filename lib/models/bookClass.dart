class WebDataModel {
  String? baseUrl;
  String? siteIcon;
  List<Properties>? properties;

  WebDataModel({required this.baseUrl,required this.siteIcon, this.properties});

  WebDataModel.fromJson(Map<String, dynamic> json) {
    baseUrl = json['base_url'];
    siteIcon = json['site_icon'];
    if (json['properties'] != null) {
      properties = <Properties>[];
      json['properties'].forEach((v) {
        properties!.add(new Properties.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base_url'] = this.baseUrl;
    data['site_icon'] = this.siteIcon;
    if (this.properties != null) {
      data['properties'] = this.properties!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Properties {
  String? bookName;
  String? bookUrl;
  String? status;
  String? author;
  String? publisher;
  String? artist;
  List<Issues>? issues;

  Properties(
      {this.bookName,
        this.bookUrl,
        this.status,
        this.author,
        this.publisher,
        this.artist,
        this.issues});

  Properties.fromJson(Map<String, dynamic> json) {
    bookName = json['book_name'];
    bookUrl = json['book_url'];
    status = json['status'];
    author = json['author'];
    publisher = json['publisher'];
    artist = json['artist'];
    if (json['issues'] != null) {
      issues = <Issues>[];
      json['issues'].forEach((v) {
        issues!.add(new Issues.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_name'] = this.bookName;
    data['book_url'] = this.bookUrl;
    data['status'] = this.status;
    data['author'] = this.author;
    data['publisher'] = this.publisher;
    data['artist'] = this.artist;
    if (this.issues != null) {
      data['issues'] = this.issues!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Issues {
  String? issueName;
  String? issueLink;
  List<String>? issuePages;

  Issues({this.issueName, this.issueLink, this.issuePages});

  Issues.fromJson(Map<String, dynamic> json) {
    issueName = json['issue_name'];
    issueLink = json['issue_link'];
    issuePages = json['issue_pages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['issue_name'] = this.issueName;
    data['issue_link'] = this.issueLink;
    data['issue_pages'] = this.issuePages;
    return data;
  }
}