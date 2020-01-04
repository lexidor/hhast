/*
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAST;

use namespace HH\Lib\{C, Dict, Regex, Str, Vec};

final class ShoutCaseEnumMembersLinter extends AutoFixingASTLinter {
  const type TContext = EnumDeclaration;
  const type TNode = Enumerator;

  <<__Override>>
  public function getLintErrorForNode(
    self::TContext $enum,
    self::TNode $member,
  ): ?ASTLintError {
    $original_name = self::memberToName($member);
    if (self::isShoutCase($original_name)) {
      return null;
    }

    $transformed_names = self::prepareAllNewNamesFor($enum);

    // If we can't find the shout name, we bail, because the enum
    // member names would not be unique after the fix.
    if (!C\contains_key($transformed_names, $original_name)) {
      return new ASTLintError(
        $this,
        Str\format(
          'Member {%s} is not in SHOUT_CASE,
but the autogenerated name collides or your enum contains duplicate names,
so no autofix is suggested.',
          $original_name,
        ),
        $member,
        null,
      );
    }

    return new ASTLintError(
      $this,
      Str\format('Member {%s} is not in SHOUT_CASE', $original_name),
      $member,
      () ==> self::getFixedNode($member),
    );
  }

  <<__Memoize>>
  private static function isShoutCase(string $member_name): bool {
    return Regex\matches($member_name, re"/^[A-Z0-9_]+$/");
  }

  private static function memberToName(Enumerator $member): string {
    return $member->getName()->getLastTokenx()->getText();
  }

  /**
   * @return dict<originalName, ORIGINAL_NAME>
   */
  <<__Memoize>>
  private static function prepareAllNewNamesFor(
    EnumDeclaration $enum,
  ): dict<string, string> {
    $old_names = Vec\map(
      $enum->getChildren()['enumerators']->toVec(),
      $member ==> self::memberToName($member as Enumerator),
    );

    // Put all non-shout case names in front.
    // This way they will be overwritten if there is a shout case member
    // that has the same name as the suggested fix.
    $old_names = Vec\partition($old_names, $name ==> self::isShoutCase($name))
      |> Vec\concat($$[1], $$[0]);

    return Dict\from_values(
      $old_names,
      $name ==> self::transformToShoutCase($name),
    )
      |> Dict\flip($$);
  }

  private static function transformToShoutCase(string $name): string {
    invariant(!Str\is_empty($name), 'Name must be at least one character');
    if (Str\contains($name, '_')) {
      // snake_case
      return Str\uppercase($name);
    } else {
      // camelCase
      return camel_case_to_snake_case($name)
        |> Str\uppercase($$);
    }
  }

  public static function getFixedNode(self::TNode $node): ?Node {
    return $node->withName(
      $node->getName()
        ->withText(self::transformToShoutCase(self::memberToName($node))),
    );
  }

  <<__Override>>
  protected function getTitleForFix(LintError $_): string {
    return 'Use shout case for enum members';
  }
}
