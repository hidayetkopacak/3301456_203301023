import 'package:flutter/material.dart';
import 'package:my_digital_library/constants/constants.dart';
import 'package:my_digital_library/pages/details/widgets/bookDetailIssueList.dart';

class bookDetailSingle extends StatelessWidget {
  final Map comicData;
  const bookDetailSingle({required this.comicData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        //padding: EdgeInsets.all(tabBarAndGridViewMarginPaddin.tabBarMargin),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: _buildHead(),
            ),
            Expanded(flex:1,child: _buildExpandedActionIcons(),), // icon'lar ve fav'a ekleme çıkarma burdan olacak
            Expanded(flex:1,child: _buildDescriptions()), // kitabın description'ı olacak
            Expanded(flex: 5,child: _buildIssues()), // kitabın bölümleri burada olacak. ListView şeklinde aşağı kaydırılacak


          ],
        ));
  }

  Container _buildHead() {
    return Container(



        decoration: BoxDecoration(



          image: DecorationImage(

            //Background Image'daki her ayarı buradan yapabilirsin.
            image: NetworkImage('${dataProperties.baseUrl}${comicData['book_url']}',),
            fit: BoxFit.cover,
          ),

        ),
        child: Padding(

          padding: const EdgeInsets.all(10.0),
          child: Row(

            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,

            children: [
              Expanded(
                  flex: 1,
                  child: Image.network('${dataProperties.baseUrl}${comicData['book_url']}')),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(

                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 4,
                          child: SizedBox(width: 0,)),
                      Expanded(

                          flex: 2,
                          child: Text('${comicData['book_name']}',
                            style: _buildHeaderTextStyle(),
                          )),
                      Expanded(

                          flex: 1,
                          child: Text('${comicData['publisher']} - ${comicData['status']} - ${comicData['artist']} ',
                            style: _buildSubtitleTextStyle(),
                          )),


                    ],
                  ),
                ),
              )


            ],
          ),
        )
    );
  }

  Container _buildIssues() {
    return Container(
        padding: EdgeInsets.all(5),
        color: mainScreenProperties.backgroundColorSecond,width: double.infinity, //comicData['issues']

        child: bookDetailIssueList(issueNameLinkList: comicData['issues']).buildIssueList());
  }

  Container _buildDescriptions() {
    return Container(
      

      padding: EdgeInsets.all(10),
      color: mainScreenProperties.backgroundColor,width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Text('"Berserk" is a dark fantasy manga series that follows the story of Guts, a skilled warrior who is seeking revenge against his former best friend, Griffith. Along the way, Guts must navigate a world filled with demons, magic, and political intrigue as he struggles to control his own inner demons and uncover the truth about his past. The series explores themes of power, betrayal, morality, and the consequences of unchecked ambition."',


          style: TextStyle(),),
      ),

    );
  }

  Container _buildExpandedActionIcons() {
    // Butonlar Burada
    return Container(color: mainScreenProperties.backgroundColorSecond,width: double.infinity,
      child: Row(
        children: [
          Expanded(child: IconButton(onPressed: (){}, icon: Icon(Icons.add))),
          Expanded(child: IconButton(onPressed: (){}, icon: Icon(Icons.favorite))),
          Expanded(child: IconButton(onPressed: (){}, icon: Icon(Icons.add_alert_outlined))),

        ],

      ),


    );
  }

  TextStyle _buildHeaderTextStyle() => TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: mainScreenProperties.fontColorWhite,
  backgroundColor: mainScreenProperties.backgroundColorThird

  );

  TextStyle _buildSubtitleTextStyle() => TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: mainScreenProperties.fontColorWhite,
      backgroundColor: mainScreenProperties.backgroundColorThird

  );



}
