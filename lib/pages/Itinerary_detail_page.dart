import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/http/API.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/util/screen_utl.dart';
import 'package:mobile/widgets/icons.dart';

class ItineraryPage extends StatefulWidget {
  ItineraryPage(this.itineraryId, {Key key}) : super(key: key);

  final String itineraryId;

  @override
  _ItineraryPageState createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  Itinerary itinerary;

  @override
  void initState() {
    super.initState();
    getItineraryDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            "套餐详情",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 4,
          centerTitle: true,
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Container(
              child: Icon(Icons.favorite_border),
              margin: EdgeInsets.only(right: 20),
            )
          ],
        ),
        body: itinerary == null
            ? Container()
            : Column(
                children: [
                  ItinerarySummaryWidget(
                    itinerary: itinerary,
                  ),
                  ItineraryHighlightWidget(
                    itinerary: itinerary,
                  )
                ],
              ));
  }

  void getItineraryDetail() async {
    var iti = await API().getItineraryDetail(widget.itineraryId);
    setState(() {
      itinerary = iti;
    });
  }
}

class ItinerarySummaryWidget extends StatelessWidget {
  final Itinerary itinerary;

  const ItinerarySummaryWidget({Key key, this.itinerary})
      : assert(itinerary != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(children: [
        Container(
          child: FittedBox(
            child: Image.network(
              itinerary.image,
            ),
            fit: BoxFit.cover,
          ),
          height: 350,
          margin: EdgeInsets.only(bottom: 20),
        ),
        Container(
          child: Column(children: [
            Text(
              itinerary.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              child: Text(
                itinerary.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: ColorConstants.TEXT_SECONDARY),
              ),
              width: ScreenUtils.screenWidth(context) * (2 / 3),
            ),
            Container(
              child: Row(
                children: [
                  SquareIcon(
                    color: ColorConstants.TEXT_PRIMARY,
                    width: 10,
                    margin: EdgeInsets.only(right: 10, top: 5),
                  ),
                  Expanded(
                    child: Text(
                      itinerary.cities.join(' / '),
                      style: TextStyle(color: ColorConstants.TEXT_PRIMARY),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            Row(
              children: [],
            )
          ], crossAxisAlignment: CrossAxisAlignment.start),
          padding: EdgeInsets.symmetric(horizontal: 10),
        )
      ], crossAxisAlignment: CrossAxisAlignment.start),
      width: ScreenUtils.screenWidth(context),
    );
  }
}

class ItineraryHighlightWidget extends StatelessWidget {
  final Itinerary itinerary;

  const ItineraryHighlightWidget({Key key, this.itinerary})
      : assert(itinerary != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            '行程亮点',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '世界那么大，我想去看看',
            style: TextStyle(color: ColorConstants.TEXT_SECONDARY),
          ),
          Container(
            child: Text(
              itinerary.description,
              textAlign: TextAlign.justify,
            ),
            margin: EdgeInsets.all(10),
          )
        ],
      ),
      width: ScreenUtils.screenWidth(context),
      margin: EdgeInsets.symmetric(vertical: 20),
    );
  }
}

class DayTrips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
