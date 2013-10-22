module experiments::Compiler::Tests::AllRascalTests

import IO;
import experiments::Compiler::Execute;

loc base1 = |project:///rascal-test/tests/functionality|;
list[str] functionalityTests = [
//"AccumulatingTests"		// r2mu: Compiling testClosuresHaveAccessToLexicalScopeForAppend
							// |rascal://experiments::Compiler::Rascal2muRascal::RascalExpression|(30962,10,<762,63>,<762,73>): Uninitialized variable: statements
//"AnnotationTests"			// 3 failing tests
							// 1 || commented out.

//"AssignmentTests"			// 3 failing tests


//"BackTrackingTests"		//  15 tests fail 

//"CallTests"					// Checking function incr
							// |rascal://lang::rascal::types::CheckTypes|(137644,17,<2715,18>,<2715,35>): The called signature: checkExp(sort("Expression"), Configuration),
							// does not match the declared signature:	CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  

//"ComprehensionTests"		// error("Cannot match an expression of type: void() against a pattern of type tuple([int(),int()])",|project://rascal-test/src/tests/functionality/ComprehensionTests.rsc|(19292,14,<352,61>,<352,75>))
							// error("Name Y is not in scope",|project://rascal-test/src/tests/functionality/ComprehensionTests.rsc|(19287,1,<352,56>,<352,57>))
							// error("Name X is not in scope",|project://rascal-test/src/tests/functionality/ComprehensionTests.rsc|(19131,1,<348,54>,<348,55>))
							// error("Name X is not in scope",|project://rascal-test/src/tests/functionality/ComprehensionTests.rsc|(19285,1,<352,54>,<352,55>))
							// error("Name Y is not in scope",|project://rascal-test/src/tests/functionality/ComprehensionTests.rsc|(19133,1,<348,56>,<348,57>))
							// error("Remainder not defined on TREE i : (int N) and int",|project://rascal-test/src/tests/functionality/ComprehensionTests.rsc|(7937,5,<163,51>,<163,56>))
							// error("Remainder not defined on TREE i : (int N) and int",|project://rascal-test/src/tests/functionality/ComprehensionTests.rsc|(7951,5,<163,65>,<163,70>))
							// error("Cannot match an expression of type: int() against a pattern of type cons(adt(\"TREE\",[]),\"i\",[label(\"N\",int())])",|project://rascal-test/src/tests/functionality/ComprehensionTests.rsc|(7922,1,<163,36>,<163,37>))
							// error("Cannot match an expression of type: void() against a pattern of type tuple([int(),int()])",|project://rascal-test/src/tests/functionality/ComprehensionTests.rsc|(19138,14,<348,61>,<348,75>))
//"DataDeclarationTests"		// Checking function parameterized3
							// |rascal://Type|(19740,49,<357,81>,<357,130>): "Length of symbol list and label list much match"
							// at addParamLabels(|rascal://Type|(16896,2,<325,125>,<325,127>))
							// at lub(|rascal://Type|(16771,201,<325,0>,<325,201>))

"DataTypeTests"			// 16 tests fail
							
//"DeclarationTests"		// error("Cannot re-declare name that is already declared in the current function or closure",|project://rascal-test/src/tests/functionality/DeclarationTests.rsc|(985,1,<31,18>,<31,19>))
							// error("Cannot re-declare name that is already declared in the current function or closure",|project://rascal-test/src/tests/functionality/DeclarationTests.rsc|(1071,1,<35,14>,<35,15>))
							// error("Cannot re-declare name that is already declared in the current function or closure",|project://rascal-test/src/tests/functionality/DeclarationTests.rsc|(1167,1,<39,24>,<39,25>))

//"PatternTests"				// Checking function matchADTwithKeywords4
							// |rascal://lang::rascal::types::CheckTypes|(140533,19,<2772,21>,<2772,40>): The called signature: checkExp(sort("Expression"), Configuration),
							// does not match the declared signature:	CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  

//"RangeTests"				// OK
							// I6 tests fail ; In three tests the result is (on purpose) different regarding type.

// "ReducerTests"			// OK

//"StatementTests"			// |rascal://experiments::Compiler::RVM::Run|(217,264,<12,0>,<14,153>): Java("RuntimeException","PANIC: undefined label FAIL_loop")
						
//"SubscriptTests"			// Checking function WrongMapIndex
							// |rascal://lang::rascal::types::AbstractType|(22449,2,<471,78>,<471,80>): "getMapFieldsAsTuple called with unexpected type fail"
];


list[str] rascalTests = [
//"BacktrackingTests"	// |rascal://lang::rascal::types::CheckTypes|(286903,27,<5690,18>,<5690,45>): The called signature: checkKeywordFormals(sort("KeywordFormals"), Configuration),
						// does not match the declared signature:	CheckResult checkKeywordFormals(sort("KeywordFormals"), Configuration); (concrete pattern);  
//"Booleans"			// |rascal://experiments::Compiler::RVM::Run|(217,264,<12,0>,<14,153>): Java("RuntimeException","PANIC: undefined overloaded function name Boolean/fromString(str();)#0/use:IllegalArgument(str();str();)")
						// at org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.CodeBlock.getOverloadedFunctionIndex(|file:///CodeBlock.java|(0,0,<202,0>,<202,0>))

//"Equality"				// error("Unexpected type: type of body expression, value, must be a subtype of the function return type, bool",|project://rascal-test/src/tests/Equality.rsc|(4382,30,<84,47>,<84,77>))
						// error("Unexpected type: type of body expression, value, must be a subtype of the function return type, bool",|project://rascal-test/src/tests/Equality.rsc|(4304,29,<83,47>,<83,76>))

//"Functions"				// Checking function callKwp
						// |rascal://lang::rascal::types::CheckTypes|(206380,13,<4071,16>,<4071,29>): The called signature: checkExp(sort("Expression"), Configuration),
						// does not match the declared signature:	CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  CheckResult checkExp(sort("Expression"), Configuration); (concrete pattern);  

//"Integers"			// OK
//"IO"					// |rascal://experiments::Compiler::RVM::Run|(217,264,<12,0>,<14,153>): Java("RuntimeException","PANIC: undefined overloaded function name IO/touch(\\loc();)#0/use:appendToFile(\\loc();)")


//"ListRelations"
//"Lists"				// Checking function assignSlice
						// |rascal://lang::rascal::types::CheckTypes|(256708,31,<5086,19>,<5086,50>): The called signature: buildAssignableTree(sort("Assignable"), bool, Configuration),
						// does not match the declared signature:	ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  

//"Maps"
//"Matching"
//"Memoization"
// "Nodes"				// |rascal://lang::rascal::types::CheckTypes|(254842,31,<5055,19>,<5055,50>): The called signature: buildAssignableTree(sort("Assignable"), bool, Configuration),
						// does not match the declared signature:	ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  
//"Relations"			// error("Name a is not in scope",|rascal:///lang/rascal/tests/Relations.rsc|(438,1,<16,39>,<16,40>))
						// error("Function of type fun rel[&T1 \<: value, &T2 \<: value, &T3 \<: value](rel[&T0 \<: value, &T1 \<: value, &T2 \<: value, &T3 \<: value]) cannot be called with argument types (set[&A \<: value])",|rascal:///lang/rascal/tests/Relations.rsc|(229,8,<11,28>,<11,36>))
						// error("Name a is not in scope",|rascal:///lang/rascal/tests/Relations.rsc|(240,1,<11,39>,<11,40>))
						// error("Type EmptySet not declared",|project://rascal/src/org/rascalmpl/library/Set.rsc|(9472,8,<476,45>,<476,53>))

//"Sets"				// |rascal://lang::rascal::types::CheckTypes|(13598,1,<304,71>,<304,72>): NoSuchField("containedIn")
						 
//"SolvedIssues"		// errors due to imported List module.  
//"Strings"  			// Checking function assignSlice
						// |rascal://lang::rascal::types::CheckTypes|(258310,31,<5109,19>,<5109,50>): The called signature: buildAssignableTree(sort("Assignable"), bool, Configuration),
						// does not match the declared signature:	ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  ATResult buildAssignableTree(sort("Assignable"), bool, Configuration); (concrete pattern);  
						// ==> Issue

//"Tuples"				// OK
];

loc base = |rascal-test:///tests/library|;
int nsuccess = 0;
int nfail = 0;

void runTests(list[str] names, loc base){
 for(tst <- names){
      println("***** <tst> ***** <base>");
      if(<s, f> := execute(base + (tst + ".rsc"), [], recompile=true, testsuite=true)){
         nsuccess += s;
         nfail += f;
      } else {
         println("testsuite did not return a tuple");
      }
  }
}
  
value main(list[value] args){
  nsuccess = 0;
  nfail = 0;
  runTests(functionalityTests, |project://rascal-test/src/tests/functionality|);
  //runTests(rascalTests, |project://rascal-test/src/tests|);
  println("Overall summary: <nsuccess + nfail> tests executed, <nsuccess> succeeded, <nfail> failed");
  return nfail == 0;
}