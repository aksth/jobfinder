// Create a MockClient using the Mock class provided by the Mockito package.
// Create new instances of this class in each test.
import 'package:jobfinder/http_service.dart';
import 'package:jobfinder/placesapi/place_model/place_model.dart';
import 'package:jobfinder/placesapi/place_model/placesapi_response_model.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

class MockClient extends Mock implements http.Client {}

main() {



  // Tests go here

  group('getPlaces', (){
    test('returns list of 5 places matching the given input from Google Places API', () async {

      final client = MockClient();
      final HttpService httpService = HttpService();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get('https://maps.googleapis.com/maps/api/place/autocomplete/json?'
          'key=&input=nepal'))
          .thenAnswer((_) async => http.Response('{"predictions":[{"description"'
          ':"Nepal","place_id":"ChIJz2gufcfolTkR3obM0LyaojQ"},{"description":'
          '"Nepalgunj, Nepal","place_id":"ChIJdeH4MFpnmDkRkZiMghNAwJM"},{'
          '"description":"Nepal India Border Marking Pillar, Belraya, Uttar '
          'Pradesh, India","place_id":"ChIJNxOwcroDojkRg-oa-_XV87w"},{'
          '"description":"Nepal border central office, Sahyoginagar Marga, '
          'Kathmandu, Nepal","place_id":"ChIJSayHvuwZ6zkR8ByndTkFyyI"},{'
          '"description":"Nepal, Punjab, India","place_id":"ChIJHzkcvTJCGTkR-'
          'DjLXmD7Eq8"}],"status":"OK"}', 200));

      expect(await httpService.getPlacesAutoComplete(client, "nepal"), const TypeMatcher<List<Place>>());
    });
  });
}