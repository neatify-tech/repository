let a = current_kind == kinds::ExprChain
               || current_kind == kinds::ExprCall
               || current_kind == kinds::ExprDotAccess
               || current_kind == kinds::ExprIndex
               || current_kind == kinds::ExprPath
               || current_kind == kinds::ExprIdent
               || current_kind == kinds::ExprParen;
