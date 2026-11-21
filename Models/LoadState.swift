//
//  LoadState.swift
//  Describes where a network request is. Views switch on this to decide whether to
//  show a spinner, the content, or an error.
//
import Foundation

enum LoadState<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(String)
}
