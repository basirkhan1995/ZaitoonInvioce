part of 'estimate_bloc.dart';

sealed class EstimateEvent extends Equatable {
  const EstimateEvent();

  @override
  List<Object> get props => [];
}

class AddItemEvent extends EstimateEvent {
  final List<EstimateItemsModel> items;
  const AddItemEvent(this.items);
}

class RemoveItemEvent extends EstimateEvent {
  final int index;
  const RemoveItemEvent(this.index);
}

class LoadItemsEvent extends EstimateEvent {}

class ResetItemsEvent extends EstimateEvent {}

class UpdateItemEvent extends EstimateEvent {
  final int index;
  final EstimateItemsModel updatedInvoice;

  const UpdateItemEvent(this.index, this.updatedInvoice);
}
