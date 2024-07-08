import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unidwell_finder/features/rooms/data/rooms_model.dart';
import 'package:unidwell_finder/features/rooms/services/rooms_services.dart';

final roomsStreamProvider =
    StreamProvider.autoDispose<List<RoomsModel>>((ref) async* {
  final data = RoomsServices.getAllRooms();
  await for (final value in data) {
    ref.read(roomsFilterProvider.notifier).setRooms(value);
    yield value;
  }
});

class RoomsFiterObject {
  List<RoomsModel> items;
  List<RoomsModel> filteredItems;
  RoomsFiterObject({this.items = const [], this.filteredItems = const []});
}

final roomsFilterProvider =
    StateNotifierProvider<RoomsFilter, RoomsFiterObject>(
        (ref) => RoomsFilter());

class RoomsFilter extends StateNotifier<RoomsFiterObject> {
  RoomsFilter() : super(RoomsFiterObject());

  void filterRooms(String query) {
    state = RoomsFiterObject(
        items: state.items,
        filteredItems: state.items
            .where((element) =>
                element.title.toLowerCase().contains(query.toLowerCase()) ||
                element.institution.toLowerCase().contains(query.toLowerCase()) ||
                element.hostelName.toLowerCase().contains(query.toLowerCase()))
            .toList());
  }

  void setRooms(List<RoomsModel> rooms) {
    state = RoomsFiterObject(items: rooms, filteredItems: rooms);
  }
}


final isSearchingProvider = StateProvider<bool>((ref) => false);