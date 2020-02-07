class Task {
  DateTime id = new DateTime.now();
  String title;
  String subtitle;
  bool done;

  Task({this.title, this.subtitle = "", this.done});
}
