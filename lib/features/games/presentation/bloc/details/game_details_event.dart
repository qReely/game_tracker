abstract class GameDetailsEvent {}

class FetchGameDetails extends GameDetailsEvent {
  int id;
  FetchGameDetails(this.id);
}