@license{
  Copyright (c) 2009-2015 CWI
  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html
}
@contributor{Jurgen J. Vinju - Jurgen.Vinju@cwi.nl - CWI}
@contributor{Jeroen van den Bos - Jeroen.van.den.Bos@cwi.nl (CWI)}
@contributor{Paul Klint - Paul.Klint@cwi.nl - CWI}
@contributor{Arnold Lankamp - Arnold.Lankamp@cwi.nl}
//START
@doc{
.Synopsis
Exceptions thrown by the Rascal run-time.
}
module Exception

/*
 * This data type declares all exceptions that are thrown by the
 * Rascal run-time environment which can be caught by a Rascal program.
 */

@doc{
.Synopsis
The `Exception` datatype used in all Rascal exceptions.

.Description
Since declarations for ADTs are extensible, the user can add new exceptions when needed.

Exceptions are either generated by the Rascal run-time (e.g., `IndexOutOfBounds`) or they
are generated by a link:/Rascal#Statements-Throw[throw].
Exceptions can be caught with a link:/Rascal#Statements-TryCatch[try catch].

.Examples

Import relevant libraries:
[source,rascal-shell,continue,error]
----
import Exception;
import IO;
----
Define the map `weekend` and do a subscription with a non-existing key:
[source,rascal-shell,continue,error]
----
weekend = ("saturday": 1, "sunday": 2);
weekend["monday"];
----
Repeat this, but catch the exception. We use variable `N` to track what happened:
[source,rascal-shell,continue,error]
----
N = 1;
try {
   N = weekend["monday"];
} catch NoSuchKey(v):
  N = 100;
println(N);
----

}

data RuntimeException = 
       Ambiguity(loc location, str nonterminal, str sentence)
     | ArithmeticException(str message)
     | AssertionFailed() 
     | AssertionFailed(str label)
     | EmptyList()
     | EmptyMap() 
     | EmptySet()
     | IllegalArgument()
     | IllegalArgument(value v)
     | IllegalArgument(value v, str message)
     | IndexOutOfBounds(int index)
     | IO(str message)
     | Java(str class, str message)
     | Java(str class, str message, RuntimeException cause)
     | ModuleNotFound(str name)
     | NoSuchAnnotation(str label)
     | NoMainFunction()
     | NoSuchKey(value key)
     | MultipleKey(value key)
     | ParseError(loc location)
     | PathNotFound(loc l)
     | PathNotFound(set[loc] locs)
     | StackOverflow()
     
// Status to be determined:     
     
//   | AccessDenied(loc l)
//   | FileNotFound(str file)
//   | IllegalIdentifier(str name)
//   | SchemeNotSupported(loc l)
//   | HostNotFound(loc l)
     | ImplodeError(str message)
//   | MissingCase(value x)
     | NoSuchElement(value v)
     | PermissionDenied()
     | PermissionDenied(str message)
//   | Subversion(str message)
     | Timeout()

   
	 ;