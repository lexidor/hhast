<?hh // strict
/*
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAST\__Private\LSPLib;

<<__ConsistentConstruct>>
abstract class ClientNotification {
  abstract const string METHOD;
  abstract const type TParams;

  abstract public function executeAsync(this::TParams $in): Awaitable<void>;
}
