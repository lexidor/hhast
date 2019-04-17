/**
 * This file is generated. Do not modify it manually!
 *
 * @generated SignedSource<<fdcc502a7e35196de08b5a68380028b9>>
 */
namespace Facebook\HHAST;
use namespace Facebook\TypeAssert;

<<__ConsistentConstruct>>
final class PocketAtomExpression extends EditableNode {

  private EditableNode $_glyph;
  private EditableNode $_expression;

  public function __construct(EditableNode $glyph, EditableNode $expression) {
    parent::__construct('pocket_atom_expression');
    $this->_glyph = $glyph;
    $this->_expression = $expression;
  }

  <<__Override>>
  public static function fromJSON(
    dict<string, mixed> $json,
    string $file,
    int $offset,
    string $source,
  ): this {
    $glyph = EditableNode::fromJSON(
      /* UNSAFE_EXPR */ $json['pocket_atom_glyph'],
      $file,
      $offset,
      $source,
    );
    $offset += $glyph->getWidth();
    $expression = EditableNode::fromJSON(
      /* UNSAFE_EXPR */ $json['pocket_atom_expression'],
      $file,
      $offset,
      $source,
    );
    $offset += $expression->getWidth();
    return new static($glyph, $expression);
  }

  <<__Override>>
  public function getChildren(): dict<string, EditableNode> {
    return dict[
      'glyph' => $this->_glyph,
      'expression' => $this->_expression,
    ];
  }

  <<__Override>>
  public function rewriteDescendants(
    self::TRewriter $rewriter,
    ?vec<EditableNode> $parents = null,
  ): this {
    $parents = $parents === null ? vec[] : vec($parents);
    $parents[] = $this;
    $glyph = $this->_glyph->rewrite($rewriter, $parents);
    $expression = $this->_expression->rewrite($rewriter, $parents);
    if ($glyph === $this->_glyph && $expression === $this->_expression) {
      return $this;
    }
    return new static($glyph, $expression);
  }

  public function getGlyphUNTYPED(): EditableNode {
    return $this->_glyph;
  }

  public function withGlyph(EditableNode $value): this {
    if ($value === $this->_glyph) {
      return $this;
    }
    return new static($value, $this->_expression);
  }

  public function hasGlyph(): bool {
    return !$this->_glyph->isMissing();
  }

  /**
   * @return unknown
   */
  public function getGlyph(): EditableNode {
    return TypeAssert\instance_of(EditableNode::class, $this->_glyph);
  }

  /**
   * @return unknown
   */
  public function getGlyphx(): EditableNode {
    return $this->getGlyph();
  }

  public function getExpressionUNTYPED(): EditableNode {
    return $this->_expression;
  }

  public function withExpression(EditableNode $value): this {
    if ($value === $this->_expression) {
      return $this;
    }
    return new static($this->_glyph, $value);
  }

  public function hasExpression(): bool {
    return !$this->_expression->isMissing();
  }

  /**
   * @return unknown
   */
  public function getExpression(): EditableNode {
    return TypeAssert\instance_of(EditableNode::class, $this->_expression);
  }

  /**
   * @return unknown
   */
  public function getExpressionx(): EditableNode {
    return $this->getExpression();
  }
}