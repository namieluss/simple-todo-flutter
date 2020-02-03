class TodoModel {
  int _id;
  String _title;
  String _description;
  int _status;

  TodoModel(this._title, this._status, [this._description]);

  TodoModel.withId(this._id, this._title, this._status, [this._description]);

  int get id => _id;

  String get title => _title;

  String get description => _description;

  int get status => _status;

  bool get statusBool => _status == 1 ? true : false;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set status(int status) {
    this._status = status;
  }

  set statusBool(bool status) {
    this._status = status ? 1 : 0;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['status'] = _status;

    return map;
  }

  // Extract a Note object from a Map object
  TodoModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._status = map['status'];
  }
}
