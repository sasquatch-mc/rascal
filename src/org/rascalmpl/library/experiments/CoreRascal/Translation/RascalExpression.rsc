@bootstrapParser
module experiments::CoreRascal::Translation::RascalExpression

import Prelude;

import lang::rascal::\syntax::Rascal;

import lang::rascal::types::TestChecker;
import lang::rascal::types::CheckTypes;
import lang::rascal::types::AbstractName;

import experiments::CoreRascal::Translation::RascalPattern;

import experiments::CoreRascal::muRascal::AST;

public Configuration config = newConfiguration();
public map[int,tuple[int,int]] uid2addr = ();
public map[loc,int] loc2uid = ();

// Get the type of an expression
Symbol getType(loc l) = config.locationTypes[l];

str getType(Expression e) = "<getType(e@\loc)>";

// Get the outermost type constructor of an expression
str getOuterType(Expression e) {
 tp = "<getName(getType(e@\loc))>";
 if(tp in {"int", "real", "rat"})
 	tp = "num";
 return tp;
}

// Get the type of a declared function
set[Symbol] getFunctionType(str name) { 
   r = config.store[config.fcvEnv[RSimpleName(name)]].rtype; 
   return overloaded(alts) := r ? alts : {r};
}

int getFunctionScope(str name) = config.fcvEnv[RSimpleName(name)];

int getScopeSize(int scope){
  int n = 0;
  for(<scope, int pos> <- range(uid2addr))
    n += 1;
  return n;
}

// Get the type of a declared function
tuple[int,int] getVariableScope(str name) = uid2addr[config.fcvEnv[RSimpleName(name)]];

MuExp mkVar(str name, loc l) {
  //println("mkVar: <name>");
  //println("l = <l>,\nloc2uid = <loc2uid>");
  addr = uid2addr[loc2uid[l]];
  res = "<name>::<addr[0]>::<addr[1]>";
  //println("mkVar: <name> =\> <res>");
  return muVar(name, addr[0], addr[1]);
}


/* */

MuExp mkAssign(str name, loc l, MuExp exp) {
  println("mkVar: <name>");
  println("l = <l>,\nloc2uid = <loc2uid>");
  addr = uid2addr[loc2uid[l]];
  res = "<name>::<addr[0]>::<addr[1]>";
  //println("mkVar: <name> =\> <res>");
  return muAssign(name, addr[0], addr[1], exp);
}

void extractScopes(){
   set[int] functionScopes = {};
   rel[int,int] containment = {};
   rel[int,int] declares = {};
   uid2addr = ();
   loc2uid = ();
   for(uid <- config.store){
      item = config.store[uid];
      switch(item){
        case function(_,_,_,inScope,_,src): { functionScopes += {uid}; 
                                              declares += {<inScope, uid>}; 
                                              containment += {<inScope, uid>}; 
                                              loc2uid[src] = uid;
                                              for(l <- config.uses[uid])
                                                  loc2uid[l] = uid;
                                            }
        case variable(_,_,_,inScope,src):   { declares += {<inScope, uid>}; 
        									  loc2uid[src] = uid;
                                              for(l <- config.uses[uid])
                                                  loc2uid[l] = uid;
                                            }
        case blockScope(containedIn,src):   { containment += {<containedIn, uid>}; loc2uid[src] = uid;}
        case booleanScope(containedIn,src): { containment += {<containedIn, uid>}; loc2uid[src] = uid;}
      }
    }
    //println("containment = <containment>");
    //println("functionScopes = <functionScopes>");
    //println("declares = <declares>");
   
    containmentPlus = containment+;
    //println("containmentPlus = <containmentPlus>");
    
    topdecls = toList(declares[0]);
    //println("topdecls = <topdecls>");
    for(i <- index(topdecls)){
            uid2addr[topdecls[i]] = <0, i>;
    }
    for(fuid <- functionScopes){
        innerScopes = {fuid} + containmentPlus[fuid];
        decls = toList(declares[innerScopes]);
        //println("Scope <fuid> has inner scopes = <innerScopes>");
        //println("Scope <fuid> declares <decls>");
        for(i <- index(decls)){
            uid2addr[decls[i]] = <fuid, i>;
        }
    }
    println("uid2addr");
   for(uid <- uid2addr){
      println("<config.store[uid]> :  <uid2addr[uid]>");
   }
   
   println("loc2uid");
   for(l <- loc2uid)
       println("<l> : <loc2uid[l]>");
}



// Generate code for completely type-resolved operators



list[MuExp] infix(str op, Expression e) = [muCallPrim("<op>_<getOuterType(e.lhs)>_<getOuterType(e.rhs)>", translate(e.lhs)[0], translate(e.rhs)[0])];
list[MuExp] prefix(str op, Expression arg) = [muCallPrim("<op>_<getOuterType(arg)>", translate(arg)[0])];
list[MuExp] postfix(str op, Expression arg) = [muCallPrim("<op>_<getOuterType(arg)>", translate(arg)[0])];

/*********************************************************************/
/*                  Expessions                                       */
/*********************************************************************/

list[MuExp] translate(e:(Expression) `{ <Statement+ statements> }`)  { throw("nonEmptyBlock"); }

list[MuExp] translate(e:(Expression) `(<Expression expression>)`)   = translate(expression);

list[MuExp] translate (e:(Expression) `<Type \type> <Parameters parameters> { <Statement+ statements> }`)  { throw("closure"); }

list[MuExp] translate (e:(Expression) `[ <Expression first> , <Expression second> .. <Expression last> ]`) { throw("stepRange"); }

list[MuExp] translate (e:(Expression) `<Parameters parameters> { <Statement* statements> }`) { throw("voidClosure"); }

list[MuExp] translate (e:(Expression) `<Label label> <Visit \visit>`) { throw("visit"); }

list[MuExp] translate (e:(Expression) `( <Expression init> | <Expression result> | <{Expression ","}+ generators> )`) { throw("reducer"); }

list[MuExp] translate (e:(Expression) `type ( <Expression symbol> , <Expression definitions >)`) { throw("reifiedType"); }

list[MuExp] translate(e:(Expression) `<Expression expression> ( <{Expression ","}* arguments> <KeywordArguments keywordArguments>)`){
  // ignore kw arguments for the moment
   return [muCall(translate(expression)[0], [*translate(a) | a <- arguments])];
}

// literals
list[MuExp] translate((BooleanLiteral) `<BooleanLiteral b>`) = [ "<b>" == "true" ? muConstant(true) : muConstant(false) ];
list[MuExp] translate((Expression) `<BooleanLiteral b>`) = translate(b);
 
list[MuExp] translate((IntegerLiteral) `<IntegerLiteral n>`) = [muConstant(toInt("<n>"))];
list[MuExp] translate((Expression) `<IntegerLiteral n>`) = translate(n);
 
list[MuExp] translate((StringLiteral) `<StringLiteral s>`) = [ muConstant(s) ];
list[MuExp] translate((Expression) `<StringLiteral s>`) = translate(s);

list[MuExp] translate (e:(Expression) `any ( <{Expression ","}+ generators> )`) { throw("any"); }

list[MuExp] translate (e:(Expression) `all ( <{Expression ","}+ generators> )`) { throw("all"); }

list[MuExp] translate (e:(Expression) `<Comprehension comprehension>`) { throw("comprehension"); }

list[MuExp] translate(Expression e:(Expression)`{ <{Expression ","}* es> }`) {
    return [ callprim("make_set", [ translate(elem) | elem <- es ]) ];
}

list[MuExp] translate(Expression e:(Expression)`[ <{Expression ","}* es> ]`) {
    return [ callprim("make_list", [ translate(elem) | elem <- es ]) ];
}

list[MuExp] translate (e:(Expression) `# <Type \type>`) { throw("reifyType"); }

list[MuExp] translate (e:(Expression) `[ <Expression first> .. <Expression last> ]`) { throw("range"); }

list[MuExp] translate (e:(Expression) `\< <{Expression ","}+ elements> \>`) { throw("tuple"); }

list[MuExp] translate (e:(Expression) `( <{Mapping[Expression] ","}* mappings> )`) { throw("map"); }

list[MuExp] translate (e:(Expression) `it`) { throw("it"); }
 
list[MuExp] translate((QualifiedName) `<QualifiedName v>`) = [ mkVar("<v>", v@\loc) ];

list[MuExp] translate((Expression) `<QualifiedName v>`) = translate(v);

list[MuExp] translate(Expression e:(Expression) `<Expression exp> [ <{Expression ","}+ subscripts> ]`){
    op = "subscript_<getOuterType(exp)>_<intercalate("-", [getOuterType(s) | s <- subscripts])>";
    return [ callprim(op, [translate(s) | s <- subscripts]) ];
}

list[MuExp] translate (e:(Expression) `<Expression expression> [ <OptionalExpression optFirst> .. <OptionalExpression optLast> ]`) { throw("slice"); }

list[MuExp] translate (e:(Expression) `<Expression expression> [ <OptionalExpression optFirst> , <Expression second> .. <OptionalExpression optLast> ]`) { throw("sliceStep"); }

list[MuExp] translate (e:(Expression) `<Expression expression> . <Name field>`) { throw("fieldAccess"); }

list[MuExp] translate (e:(Expression) `<Expression expression> [ <Name key> = <Expression replacement> ]`) { throw("fieldUpdate"); }

list[MuExp] translate (e:(Expression) `<Expression expression> \< <{Field ","}+ fields> \>`) { throw("fieldProject"); }

list[MuExp] translate (e:(Expression) `<Expression expression> [ @ <Name name> = <Expression \value> ]`) { throw("setAnnotation"); }

list[MuExp] translate (e:(Expression) `<Expression expression> @ <Name name>`) { throw("getAnnotation"); }

list[MuExp] translate (e:(Expression) `<Expression expression> is <Name name>`) { throw("is"); }

list[MuExp] translate (e:(Expression) `<Expression expression> has <Name name>`) { throw("has"); }

list[MuExp] translate(e:(Expression) `<Expression argument> +`)   = postfix("transitiveClosure", argument);

list[MuExp] translate(e:(Expression) `<Expression argument> *`)   = postfix("transitiveReflexiveClosure", argument);

list[MuExp] translate(e:(Expression) `<Expression argument> ?`)   { throw("isDefined"); }

list[MuExp] translate(e:(Expression) `!<Expression argument>`)    = prefix("negation", argument);

list[MuExp] translate(e:(Expression) `-<Expression argument>`)    = prefix("negative", argument);

list[MuExp] translate(e:(Expression) `*<Expression argument>`)    { throw("splice"); }

list[MuExp] translate(e:(Expression) `[ <Type \type> ] <Expression argument>`)  { throw("asType"); }

list[MuExp] translate(e:(Expression) `<Expression lhs> o <Expression rhs>`)   = infix("composition", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> * <Expression rhs>`)   = infix("product", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> join <Expression rhs>`)   = infix("join", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> % <Expression rhs>`)   = infix("remainder", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> / <Expression rhs>`)   = infix("division", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> & <Expression rhs>`)   = infix("intersection", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> + <Expression rhs>`)   = infix("addition", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> - <Expression rhs>`)   = infix("subtraction", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> \>\> <Expression rhs>`)   = infix("appendAfter", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> \<\< <Expression rhs>`)   = infix("insertBefore", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> mod <Expression rhs>`)   = infix("modulo", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> notin <Expression rhs>`)   = infix("notIn", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> in <Expression rhs>`)   = infix("in", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> \>= <Expression rhs>`) = infix("greater_equal", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> \<= <Expression rhs>`) = infix("less_equal", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> \< <Expression rhs>`)  = infix("less", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> \> <Expression rhs>`)  = infix("greater", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> == <Expression rhs>`)  = infix("equals", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> != <Expression rhs>`)  = infix("nonEquals", e);

list[MuExp] translate(e:(Expression) `<Expression lhs> ? <Expression rhs>`)  { throw("ifDefinedOtherwise"); }

list[MuExp] translate(e:(Expression) `<Pattern pat> !:= <Expression rhs>`)  { throw("noMatch"); }

list[MuExp] translate(e:(Expression) `<Pattern pat> := <Expression exp>`)     = translateBool(e)  + ".start().resume()";

list[MuExp] translate(e:(Expression) `<Pattern pat> \<- <Expression exp>`)     { throw("enumerator"); }

list[MuExp] translate(e:(Expression) `<Expression lhs> ==\> <Expression rhs>`)  = translateBool(e) + ".start().resume()";

list[MuExp] translate(e:(Expression) `<Expression lhs> \<==\> <Expression rhs>`)  = translateBool(e) + ".start().resume()";

list[MuExp] translate(e:(Expression) `<Expression lhs> && <Expression rhs>`)  = translateBool(e);  //+ ".start().resume()";
 
list[MuExp] translate(e:(Expression) `<Expression condition> ? <Expression thenExp> : <Expression elseExp>`) = 
    backtrackFree(condition) ?  [ muIfelse(translate(condition)[0],
    								   translate(thenExp)[0],
    								   translate(elseExp)[0]) ]
    					     :  [ muIfelse(next(init(translateBool(condition))),
    					     		   translate(thenExp)[0],
    								   translate(elseExp)[0]) ];  

default list[MuExp] translate(Expression e) = "\<\<MISSING CASE FOR EXPRESSION: <e>";


/*********************************************************************/
/*                  End of Expessions                                */
/*********************************************************************/

// Utilities for boolean operators
 
// Is an expression free of backtracking? 
bool backtrackFree(e:(Expression) `<Pattern pat> := <Expression exp>`) = false;
default bool backtrackFree(Expression e) = true;

// Get all variables that are introduced by a pattern.
tuple[set[tuple[str,str]],set[str]] getVars(Pattern p) {
  defs = {};
  uses = {};
  visit(p){
    case (Pattern) `<Type tp> <Name name>`: defs += <"<tp>", "<name>">;
    case (Pattern) `<QualifiedName name>`: uses += "<name>";
    case (Pattern) `*<QualifiedName name>`: uses += "<name>";
  };
  return <defs, uses>;
}

list[MuExp] translateBool(str fun, Expression lhs, Expression rhs){
  blhs = backtrackFree(lhs) ? "n" : "b";
  brhs = backtrackFree(rhs) ? "n" : "b";
  return [ muCall("<fun>_<blhs>_<brhs>", [*translate(lhs), *translate(rhs)]) ];
}

list[MuExp] translateBool(e:(Expression) `<Expression lhs> && <Expression rhs>`) = translateBool("and", lhs, rhs);

list[MuExp] translateBool(e:(Expression) `<Expression lhs> || <Expression rhs>`) = translateBool("or", lhs, rhs);

list[MuExp] translateBool(e:(Expression) `<Expression lhs> ==\> <Expression rhs>`) = translateBool("implies", lhs, rhs);

list[MuExp] translateBool(e:(Expression) `<Expression lhs> \<==\> <Expression rhs>`) = translateBool("equivalent", lhs, rhs);


 // similar for or, and, not and other Boolean operators
 
 // Translate match operator
 list[MuExp] translateBool(e:(Expression) `<Pattern pat> := <Expression exp>`)  = [call("match", translatePat(pat), translate(exp))];
 /*
    "coroutine () resume bool(){
    '  matcher = <translatePat(pat)>;
    '  subject = <translate(exp)>;
    '  matcher.start(subject);
    '  while(matcher.hasMore()){
    '    if(matcher.resume())
    '       yield true;
    '    else
    '       return false;
    '  }
    '}";  
 */
 
 