class Task {
  DateTime id = new DateTime.now();
  String title;
  String subtitle;
  bool done;

  Task({this.title, this.subtitle = "", this.done});

  Task.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'done': done,
      };
}
