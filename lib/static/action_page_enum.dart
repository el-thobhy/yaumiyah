enum ActionPageEnum {
  add,
  edit;

  bool get isEdit => this == ActionPageEnum.edit;
}
