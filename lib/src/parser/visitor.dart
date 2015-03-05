part of badger.parser;

abstract class AstVisitorBase {
  void visitDeclaration(Declaration declaration);
  void visitImportDeclaration(ImportDeclaration declaration);
  void visitFeatureDeclaration(FeatureDeclaration declaration);

  void visitStatement(Statement statement);
  void visitIfStatement(IfStatement statement);
  void visitForInStatement(ForInStatement statement);
  void visitWhileStatement(WhileStatement statement);
  void visitReturnStatement(ReturnStatement statement);
  void visitBreakStatement(BreakStatement statement);
  void visitAssignment(Assignment assignment);
  void visitFunctionDefinition(FunctionDefinition definition);

  void visitMethodCall(MethodCall call);

  void visitExpression(Expression expression);
  void visitStringLiteral(StringLiteral literal);
  void visitIntegerLiteral(IntegerLiteral literal);
  void visitDoubleLiteral(DoubleLiteral literal);
  void visitRangeLiteral(RangeLiteral literal);
  void visitVariableReference(VariableReference reference);
  void visitListDefinition(ListDefinition definition);
  void visitMapDefinition(MapDefinition definition);
  void visitNegate(Negate negate);
  void visitBooleanLiteral(BooleanLiteral literal);
  void visitHexadecimalLiteral(HexadecimalLiteral literal);
  void visitOperator(Operator operator);
  void visitAccess(Access access);
  void visitBracketAccess(BracketAccess access);
  void visitTernaryOperator(TernaryOperator operator);
  void visitAnonymousFunction(AnonymousFunction function);
}


abstract class AstVisitor extends AstVisitorBase {
  void visit(Program program) {
    for (var declaration in program.declarations) {
      visitDeclaration(declaration);
    }

    for (var statement in program.statements) {
      if (statement is Statement) {
        visitStatement(statement);
      } else {
        visitExpression(statement);
      }
    }
  }

  @override
  void visitDeclaration(Declaration declaration) {
    if (declaration is FeatureDeclaration) {
      visitFeatureDeclaration(declaration);
    } else if (declaration is ImportDeclaration) {
      visitImportDeclaration(declaration);
    } else {
      throw new Exception("Unknown Declaration Type: ${declaration}");
    }
  }

  @override
  void visitStatement(Statement statement) {
    if (statement is IfStatement) {
      visitIfStatement(statement);
    } else if (statement is WhileStatement) {
      visitWhileStatement(statement);
    } else if (statement is ForInStatement) {
      visitForInStatement(statement);
    } else if (statement is ReturnStatement) {
      visitReturnStatement(statement);
    } else if (statement is BreakStatement) {
      visitBreakStatement(statement);
    } else if (statement is FunctionDefinition) {
      visitFunctionDefinition(statement);
    } else if (statement is Assignment) {
      visitAssignment(statement);
    }
  }

  @override
  void visitExpression(Expression expression) {
    if (expression is StringLiteral) {
      visitStringLiteral(expression);
    } else if (expression is IntegerLiteral) {
      visitIntegerLiteral(expression);
    } else if (expression is DoubleLiteral) {
      visitDoubleLiteral(expression);
    } else if (expression is BooleanLiteral) {
      visitBooleanLiteral(expression);
    } else if (expression is RangeLiteral) {
      visitRangeLiteral(expression);
    } else if (expression is HexadecimalLiteral) {
      visitHexadecimalLiteral(expression);
    } else if (expression is Operator) {
      visitOperator(expression);
    } else if (expression is BracketAccess) {
      visitBracketAccess(expression);
    } else if (expression is AnonymousFunction) {
      visitAnonymousFunction(expression);
    } else if (expression is ListDefinition) {
      visitListDefinition(expression);
    } else if (expression is MapDefinition) {
      visitMapDefinition(expression);
    } else if (expression is VariableReference) {
      visitVariableReference(expression);
    } else if (expression is Negate) {
      visitNegate(expression);
    } else if (expression is TernaryOperator) {
      visitTernaryOperator(expression);
    } else {
      throw new Exception("Unknown Expression Type: ${expression}");
    }
  }
}