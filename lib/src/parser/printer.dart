part of badger.parser;

class BadgerAstPrinter extends AstVisitor {
  final Program program;

  IndentedStringBuffer buff = new IndentedStringBuffer();

  BadgerAstPrinter(this.program);

  String print() {
    visit(program);
    return buff.toString();
  }

  @override
  void visitAccess(Access access) {
    visitExpression(access.reference);
    buff.write(".");
    var i = 0;
    for (var x in access.parts) {
      if (x is String) {
        buff.write(x);
      } else {
        visitExpression(x);
      }
      if (i != access.parts.length - 1) {
        buff.write(".");
      }
      i++;
    }
  }

  @override
  void visitAnonymousFunction(AnonymousFunction function) {
    if (function.block.statements.length == 1 && function.block.statements.first is Expression) {
      buff.write("(${function.args.join(", ")}) => ");
      visitStatement(function.block.statements.first);
    } else {
      buff.write("(${function.args.join(", ")}) -> {");
      buff.writeln();
      buff.increment();
      visitStatements(function.block.statements);
      buff.decrement();
      buff.writeln();
      buff.write("}");
    }
  }

  @override
  void visitAssignment(Assignment assignment) {
    if (assignment.isInitialDefine) {
      if (assignment.immutable) {
        buff.write("let");
      } else {
        buff.write("var");
      }

      if (assignment.isNullable == true) {
        buff.write("?");
      }

      buff.write(" ");
    }

    if (assignment.reference is String) {
      buff.write(assignment.reference);
    } else {
      visitExpression(assignment.reference);
    }

    buff.write(" = ");

    visitExpression(assignment.value);
  }

  @override
  void visitBooleanLiteral(BooleanLiteral literal) {
    buff.write(literal.value);
  }

  @override
  void visitBracketAccess(BracketAccess access) {
    visitExpression(access.reference);
    buff.write("[");
    visitExpression(access.index);
    buff.write("]");
  }

  @override
  void visitBreakStatement(BreakStatement statement) {
    buff.write("break");
  }

  @override
  void visitDefined(Defined defined) {
    buff.write("${defined.identifier}?");
  }

  @override
  void visitDoubleLiteral(DoubleLiteral literal) {
    buff.write(literal.value);
  }

  @override
  void visitFeatureDeclaration(FeatureDeclaration declaration) {
    buff.write('using feature "${declaration.feature.components.join()}"');
  }

  @override
  void visitForInStatement(ForInStatement statement) {
    buff.write("for ${statement.identifier} in ");
    visitExpression(statement.value);
    buff.writeln(" {");
    buff.increment();
    visitStatements(statement.block.statements);
    buff.decrement();
    buff.writeln();
    buff.writeIndent();
    buff.write("}");
  }

  @override
  void visitStatements(List statements) {
    var i = 0;
    for (var statement in statements) {
      buff.writeIndent();
      if (statement is Statement) {
        visitStatement(statement);
      } else {
        visitExpression(statement);
      }
      if (i != statements.length - 1) {
        buff.writeln();
      }
      i++;
    }
  }

  @override
  void visitFunctionDefinition(FunctionDefinition definition) {
    buff.write("func ${definition.name}(${definition.args.join(", ")}) {");
    buff.increment();
    buff.writeln();
    visitStatements(definition.block.statements);
    buff.decrement();
    buff.writeln();
    buff.writeIndent();
    buff.write("}");
  }

  @override
  void visitHexadecimalLiteral(HexadecimalLiteral literal) {
    buff.write("0x" + literal.value.toRadixString(16));
  }

  @override
  void visitIfStatement(IfStatement statement) {
    buff.write("if ");
    visitExpression(statement.condition);
    buff.writeln(" {");
    buff.increment();
    visitStatements(statement.block.statements);
    buff.decrement();
    buff.writeln();
    buff.writeIndent();
    buff.write("}");

    if (statement.elseBlock == null) {
      buff.writeln();
    } else {
      buff.increment();
      buff.writeln(" else {");
      visitStatements(statement.elseBlock.statements);
      buff.decrement();
      buff.writeln();
      buff.writeIndent();
      buff.write("}");
    }
  }

  @override
  void visitImportDeclaration(ImportDeclaration declaration) {
    buff.write('import "');
    buff.write(declaration.location.components.join());
    buff.writeln('"');

    if (declaration.id != null) {
      buff.write(" ");
      buff.write("as ");
      buff.write(declaration.id);
    }
  }

  @override
  void visitIntegerLiteral(IntegerLiteral literal) {
    buff.write(literal.value);
  }

  @override
  void visitListDefinition(ListDefinition definition) {
    buff.write("[");
    if (definition.elements.isNotEmpty) {
      buff.increment();
      var i = 0;
      for (var e in definition.elements) {
        buff.writeln();
        buff.writeIndent();
        visitExpression(e);
        if (i != definition.elements.length - 1) {
          buff.write(",");
        } else {
          buff.writeln();
        }
        i++;
      }

      buff.decrement();
    }
    buff.write("]");
  }

  @override
  void visitMapDefinition(MapDefinition definition) {
    buff.writeln("{");
    buff.increment();
    var i = 0;
    for (var x in definition.entries) {
      buff.writeIndent();
      visitExpression(x.key);
      buff.write(": ");
      visitExpression(x.value);

      if (i != definition.entries.length - 1) {
        buff.writeln(",");
      }
      i++;
    }
    buff.decrement();
    buff.writeln();
    buff.writeIndent();
    buff.write("}");
  }

  @override
  void visitMethodCall(MethodCall call) {
    if (call.reference is String) {
      buff.write("${call.reference}");
    } else {
      visitExpression(call.reference);
    }

    buff.write("(");
    var i = 0;
    for (var x in call.args) {
      visitExpression(x);
      if (i != call.args.length - 1) {
        buff.write(", ");
      }
      i++;
    }
    buff.write(")");
  }

  @override
  void visitNativeCode(NativeCode code) {
    buff.write("```");
    buff.write(code.code);
    buff.write("```");
  }

  @override
  void visitNegate(Negate negate) {
    buff.write("!");
    visitExpression(negate.expression);
  }

  @override
  void visitNullLiteral(NullLiteral literal) {
    buff.write("null");
  }

  @override
  void visitOperator(Operator operator) {
    visitExpression(operator.left);
    buff.write(" ${operator.op} ");
    visitExpression(operator.right);
  }

  @override
  void visitParentheses(Parentheses parens) {
    buff.write("(");
    visitExpression(parens.expression);
    buff.write(")");
  }

  @override
  void visitRangeLiteral(RangeLiteral literal) {
    visitExpression(literal.left);
    buff.write("..");
    if (literal.exclusive) {
      buff.write("<");
    }

    visitExpression(literal.right);

    if (literal.step != null) {
      buff.write(":");
      visitExpression(literal.step);
    }
  }

  @override
  void visitReturnStatement(ReturnStatement statement) {
    buff.write("return");

    if (statement.expression != null) {
      buff.write(" ");
      visitExpression(statement.expression);
    }
  }

  @override
  void visitStringLiteral(StringLiteral literal) {
    buff.write('"');
    for (var x in literal.components) {
      if (x is String) {
        buff.write(x);
      } else {
        buff.write("\$(");
        visitExpression(x);
        buff.write(")");
      }
    }
    buff.write('"');
  }

  @override
  void visitSwitchStatement(SwitchStatement statement) {
    buff.write("switch ");
    visitExpression(statement.expression);
    buff.write(" {");
    if (statement.cases.isNotEmpty) {
      buff.increment();
      for (var c in statement.cases) {
        buff.writeln();
        buff.writeIndent();
        buff.write("case ");
        visitExpression(c.expression);
        buff.write(":");
        buff.increment();
        visitStatements(c.block.statements);
        buff.decrement();
      }
      buff.decrement();
    }
  }

  @override
  void visitTernaryOperator(TernaryOperator operator) {
    visitExpression(operator.condition);
    buff.write(" ? ");
    visitExpression(operator.whenTrue);
    buff.write(" : ");
    visitExpression(operator.whenFalse);
  }

  @override
  void visitVariableReference(VariableReference reference) {
    buff.write(reference.identifier);
  }

  @override
  void visitWhileStatement(WhileStatement statement) {
    buff.write("while ");
    visitExpression(statement.condition);
    buff.writeln(" {");
    buff.increment();
    visitStatements(statement.block.statements);
    buff.decrement();
    buff.writeln();
    buff.writeIndent();
    buff.write("}");
  }

  @override
  void visitMultiAssignment(MultiAssignment assignment) {
    if (assignment.isInitialDefine) {
      buff.write(assignment.immutable ? "let" : "var");

      if (assignment.isNullable) {
        buff.write("?");
      }

      buff.write(" ");
    }
    buff.write("{" + assignment.ids.join(", ") + "}");
    buff.write(" = ");
    visitExpression(assignment.value);
  }

  @override
  void visitNamespaceBlock(NamespaceBlock block) {
    buff.write("namespace ${block.name} {");
    buff.increment();
    buff.writeln();
    visitStatements(block.block.statements);
    buff.decrement();
    buff.writeln();
    buff.writeIndent();
    buff.write("}");
  }

  @override
  void visitTypeBlock(TypeBlock block) {
    buff.write("type ${block.name}");

    if (block.args.isNotEmpty) {
      buff.write("(");
      buff.write(block.args.join(", "));
      buff.write(")");
    }

    buff.write(" {");
    if (block.block.statements.isNotEmpty) {
      buff.increment();
      buff.writeln();
      visitStatements(block.block.statements);
      buff.decrement();
      buff.writeln();
      buff.writeIndent();
    }
    buff.write("}");
  }

  @override
  void visitReferenceCreation(ReferenceCreation creation) {
    buff.write("&");
    visitVariableReference(creation.variable);
  }

  @override
  void visitTryCatchStatement(TryCatchStatement statement) {
    buff.writeln("try {");
    buff.increment();
    visitStatements(statement.tryBlock.statements);
    buff.decrement();
    buff.writeln();
    buff.writeIndent();
    buff.write("}");

    buff.write(" catch (");
    buff.write(statement.identifier);
    buff.writeln(") {");
    buff.increment();
    visitStatements(statement.catchBlock.statements);
    buff.decrement();
    buff.writeln();
    buff.writeIndent();
    buff.write("}");
  }
}
