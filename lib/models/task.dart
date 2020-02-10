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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          subtitle == other.subtitle &&
          done == other.done;

  //New
  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ subtitle.hashCode ^ done.hashCode;
}
