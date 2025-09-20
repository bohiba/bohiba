// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripModelAdapter extends TypeAdapter<TripModel> {
  @override
  final int typeId = 4;

  @override
  TripModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripModel(
      id: fields[0] as int?,
      tripCode: fields[1] as String?,
      tripStatus: fields[2] as String?,
      origin: fields[3] as String?,
      destination: fields[4] as String?,
      startDate: fields[5] as String?,
      endedDate: fields[6] as String?,
      loadDetail: fields[7] as LoadDetail?,
      finance: fields[8] as TripFinance?,
      truck: fields[9] as TripTruck?,
      driver: fields[10] as TripDriver?,
      owner: fields[11] as TripOwner?,
      reassignment: (fields[12] as List?)?.cast<Reassignment>(),
      expenses: (fields[13] as List?)?.cast<TripExpense>(),
      payments: (fields[14] as List?)?.cast<TripPayment>(),
      documents: (fields[15] as List?)?.cast<TripDocument>(),
      isFav: fields[18] as bool?,
      createdAt: fields[16] as String?,
      updatedAt: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TripModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tripCode)
      ..writeByte(2)
      ..write(obj.tripStatus)
      ..writeByte(3)
      ..write(obj.origin)
      ..writeByte(4)
      ..write(obj.destination)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.endedDate)
      ..writeByte(7)
      ..write(obj.loadDetail)
      ..writeByte(8)
      ..write(obj.finance)
      ..writeByte(9)
      ..write(obj.truck)
      ..writeByte(10)
      ..write(obj.driver)
      ..writeByte(11)
      ..write(obj.owner)
      ..writeByte(12)
      ..write(obj.reassignment)
      ..writeByte(13)
      ..write(obj.expenses)
      ..writeByte(14)
      ..write(obj.payments)
      ..writeByte(15)
      ..write(obj.documents)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt)
      ..writeByte(18)
      ..write(obj.isFav);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LoadDetailAdapter extends TypeAdapter<LoadDetail> {
  @override
  final int typeId = 5;

  @override
  LoadDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoadDetail(
      materialType: fields[0] as String?,
      loadWeight: fields[1] as double?,
      shortWeight: fields[2] as double?,
      rate: fields[3] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, LoadDetail obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.materialType)
      ..writeByte(1)
      ..write(obj.loadWeight)
      ..writeByte(2)
      ..write(obj.shortWeight)
      ..writeByte(3)
      ..write(obj.rate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TripFinanceAdapter extends TypeAdapter<TripFinance> {
  @override
  final int typeId = 6;

  @override
  TripFinance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripFinance(
      id: fields[0] as int?,
      amount: fields[1] as double?,
      tripPayment: fields[2] as double?,
      tripExpense: fields[3] as double?,
      tripProfit: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, TripFinance obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.tripPayment)
      ..writeByte(3)
      ..write(obj.tripExpense)
      ..writeByte(4)
      ..write(obj.tripProfit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripFinanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TripTruckAdapter extends TypeAdapter<TripTruck> {
  @override
  final int typeId = 7;

  @override
  TripTruck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripTruck(
      id: fields[0] as int?,
      regdNumber: fields[1] as String?,
      model: fields[2] as String?,
      rcVhClassDesc: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TripTruck obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.regdNumber)
      ..writeByte(2)
      ..write(obj.model)
      ..writeByte(3)
      ..write(obj.rcVhClassDesc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripTruckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TripDriverAdapter extends TypeAdapter<TripDriver> {
  @override
  final int typeId = 8;

  @override
  TripDriver read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripDriver(
      id: fields[0] as int?,
      uuid: fields[1] as String?,
      name: fields[2] as String?,
      mobile: fields[3] as String?,
      email: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TripDriver obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.mobile)
      ..writeByte(4)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripDriverAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TripOwnerAdapter extends TypeAdapter<TripOwner> {
  @override
  final int typeId = 9;

  @override
  TripOwner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripOwner(
      id: fields[0] as int?,
      uuid: fields[1] as String?,
      name: fields[2] as String?,
      mobile: fields[3] as String?,
      email: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TripOwner obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.mobile)
      ..writeByte(4)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripOwnerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReassignmentAdapter extends TypeAdapter<Reassignment> {
  @override
  final int typeId = 10;

  @override
  Reassignment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reassignment(
      id: fields[0] as int?,
      regdNumber: fields[1] as String?,
      reason: fields[2] as String?,
      date: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Reassignment obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.regdNumber)
      ..writeByte(2)
      ..write(obj.reason)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReassignmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TripExpenseAdapter extends TypeAdapter<TripExpense> {
  @override
  final int typeId = 11;

  @override
  TripExpense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripExpense(
      id: fields[0] as int?,
      expenseType: fields[1] as String?,
      addedByUuid: fields[2] as String?,
      paymentMode: fields[3] as String?,
      paid: fields[4] as double?,
      paidTo: fields[5] as String?,
      expenseDate: fields[6] as String?,
      remarks: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TripExpense obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.expenseType)
      ..writeByte(2)
      ..write(obj.addedByUuid)
      ..writeByte(3)
      ..write(obj.paymentMode)
      ..writeByte(4)
      ..write(obj.paid)
      ..writeByte(5)
      ..write(obj.paidTo)
      ..writeByte(6)
      ..write(obj.expenseDate)
      ..writeByte(7)
      ..write(obj.remarks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TripPaymentAdapter extends TypeAdapter<TripPayment> {
  @override
  final int typeId = 12;

  @override
  TripPayment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripPayment(
      id: fields[0] as int?,
      payerType: fields[1] as String?,
      paymentMode: fields[2] as String?,
      amount: fields[3] as double?,
      paidBy: fields[4] as String?,
      receivedBy: fields[5] as String?,
      paymentTime: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TripPayment obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.payerType)
      ..writeByte(2)
      ..write(obj.paymentMode)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.paidBy)
      ..writeByte(5)
      ..write(obj.receivedBy)
      ..writeByte(6)
      ..write(obj.paymentTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripPaymentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TripDocumentAdapter extends TypeAdapter<TripDocument> {
  @override
  final int typeId = 13;

  @override
  TripDocument read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripDocument(
      id: fields[0] as int?,
      docType: fields[1] as String?,
      image: fields[2] as String?,
      uploadedByUuid: fields[3] as String?,
      remarks: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TripDocument obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.docType)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.uploadedByUuid)
      ..writeByte(4)
      ..write(obj.remarks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripDocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
