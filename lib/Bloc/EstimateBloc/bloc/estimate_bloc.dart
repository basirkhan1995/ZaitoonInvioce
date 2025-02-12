import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zaitoon_invoice/Json/estimate.dart';

part 'estimate_event.dart';
part 'estimate_state.dart';

class EstimateBloc extends Bloc<EstimateEvent, EstimateState> {
  final List<EstimateItemsModel> items = [];
  EstimateBloc() : super(EstimateInitial()) {
    on<LoadItemsEvent>((event, emit) {
      try {
        if (items.isEmpty) {
          items.add(EstimateItemsModel(
            controller: TextEditingController(),
            quantity: 1,
          ));
        }
        emit(InvoiceItemsLoadedState(List.from(items)));
      } catch (e) {
        emit(InvoiceItemError(e.toString()));
      }
    });

    on<AddItemEvent>((event, emit) {
      if (event.items.isNotEmpty) {
        items.add(EstimateItemsModel(
            controller: TextEditingController(), quantity: 1));
        emit(InvoiceItemsLoadedState(List.from(items)));
      }
    });

    on<RemoveItemEvent>((event, emit) {
      if (event.index > 0 && event.index < items.length) {
        items.removeAt(event.index);
        emit(InvoiceItemsLoadedState(List.from(items)));
      }
    });

    on<UpdateItemEvent>((event, emit) {
      if (event.index >= 0 && event.index < items.length) {
        // Update the specific item
        items[event.index] = items[event.index].copyWith(
          quantity: event.updatedInvoice.quantity,
          amount: event.updatedInvoice.amount,
          discount: event.updatedInvoice.discount,
          tax: event.updatedInvoice.tax,
          total: event.updatedInvoice.total,
          itemName: event.updatedInvoice.itemName,
        );
        emit(InvoiceItemsLoadedState(List.from(items))); // Emit updated list
      }
    });
  }
}
