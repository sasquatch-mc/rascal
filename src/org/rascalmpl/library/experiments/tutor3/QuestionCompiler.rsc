module experiments::tutor3::QuestionCompiler

import IO;
import String;
import util::Math;
import List;
import Set;
import String;
import experiments::Compiler::Compile;
import experiments::Compiler::Execute;
import util::SystemAPI;
import IO;
import util::Reflective;
import DateTime;
import ParseTree;

import experiments::tutor3::Questions;
import experiments::tutor3::ParseQuestions;
import experiments::tutor3::ValueGenerator;
 
int countGenAndUse((Cmd) `<EvalCmd c>`){
    n = 0;
    visit(c){ case GenCmd gen: n += 1; 
              case UseCmd use: n += 1;
             }
    return n;
}

str holeMarkup(int n) = "+++\<div class=\"hole\" id=\"hole<n>\"/\>+++";
str clickMarkup(int n, str text) = "+++\<span class=\"clickable\" id=\"clickable<n>\" clicked=\"false\" onclick=\"handleClick(\'clickable<n>\')\"\><text>\</span\>+++";

tuple[str quoted, str execute, bool hasHoles, map[str,str] bindings] preprocessCode(int questionId, 
                                                                                TokenOrCmdList q, 
                                                                                str setup, 
                                                                                map[str,str] initialEnv, 
                                                                                PathConfig pcfg){
    nholes = 0;
    map[str,str] env = initialEnv;
    
    println("preprocessCode: <questionId>, <q>, <setup>, <initialEnv>");
    
    tuple[str quote, str execute] handleCmd((Cmd) `<GenCmd gen>`){
        println("handleCmd: <gen>");
        switch(gen){  
            case (GenCmd) `$gen(<Type tp>,<Name name>)`: {
                str v = generateValue(generateType(tp));
                if(env["<name>"]?){
                    throw "Double declaration for <name> in <gen>";
                }
                env["<name>"] = v;
                println("added <name> : <v>");
                return <v, v>;
            }
            case (GenCmd) `$gen(<Type tp>)`: {
                Type tp1 = generateType(tp);
                v = generateValue(generateType(tp));
                return <v, v>;
            }
            default:
                throw "Unhandled $gen <gen>";
        }
    }
    
    tuple[str quote, str execute] handleCmd((Cmd) `<UseCmd use>`){
        if(!env["<use.name>"]?){
           throw "Undeclared <use.name> used in <use>";
        }
        v = env["<use.name>"];
        return <v, v>;
    }
    
    tuple[str quote, str execute] handleCmd((Cmd) `<EvalCmd c>`){
        println("handleCmd: <c>");
        <qt, expr> = handle(c.elements);
        println("Eval: <expr>");
        v = "<eval(questionId, expr, setup, pcfg)>";
        return <v, v>;
    }
    
    tuple[str quote, str execute] handleCmd((Cmd) `<AnswerCmd ans>`){
            println("visit AnswerCmd: <ans>");
            nholes += 1;
            txt = "<ans.elements>";
            qt = holeMarkup(nholes);
            try {
                gen = [Cmd] "$gen(<txt>)";
                <qt1, ex> = handleCmd(gen);
                println("answer: AnswerCmd: <qt>, <ex>");
                return <qt, ex>;
            } catch: {
                try {
                    c = [Cmd] "$eval(<txt>)";
                    if(countGenAndUse(c) == 0) throw "";
                    <qt1, ex1> = handleCmd(c);
                    println("hole: EvalCmd: <qt> <ex1>");
                    return <qt, ex1>;
                } catch : {
                    v = "<txt>";
                    println("hole: plain: <qt>, <v>");
                    return <qt, v>;
                }
            }
    }
    
    tuple[str quote, str execute] handle(TokenOrCmd toc){
        println("handle: <toc>");
        if(toc is aCmd){
          return handleCmd(toc.aCmd);
        } else {
          v = "<toc>";
          return <v, v>;
        }
    }
    
    tuple[str quote, str execute] handle(TokenOrCmdList tocList){
        if(appl(_,list[Tree] args) := tocList) {
            qt = "";
            ex = "";
            if(tocList is parens){
               qt += "(<args[1]>"; ex += "(<args[1]>";
               <qt1, ex1> = handle(tocList.tocList);
               qt += "<qt1><args[3]>)"; ex += "<ex1><args[3]>)";
               if(TokenOrCmdList toc2 <- tocList.optTocList){
                  qt += "<args[5]>"; ex += "<args[5]>"; 
                  <qt2, ex2> = handle(toc2);
                  qt += qt2; ex += ex2;
               }
            } else {
              <qt, ex> = handle(tocList.toc);
              if(TokenOrCmdList toc2 <- tocList.optTocList){
                  qt += "<args[1]>"; ex += "<args[1]>"; 
                  <qt1, ex1> = handle(toc2);
                  qt += qt1; ex += ex1;
               }
            }
            println("handle toc: <tocList> =\> <qt>, <ex>");
            return <qt, ex>;
        } else {
          throw "Cannot match parse tree: <tocList>";
        }
    }
    
    <qt, ex> = handle(q);
    return <qt, ex, nholes > 0, env>;
}

str preprocessClick(int questionId, TokenOrCmdList q){
    nholes = 0;
    
    println("preprocessClick: <questionId>, <q>");
    
    tuple[str quote, str execute] handleCmd((Cmd) `<ClickCmd cc>`){
            println("visit ClickCmd: <cc>");
            nholes += 1;
            txt = "<cc.elements>";
            qt = clickMarkup(nholes, txt);
            return <qt, qt>;
    }
    
    tuple[str quote, str execute] handle(TokenOrCmd toc){
        println("handle: <toc>");
        if(toc is aCmd){
          return handleCmd(toc.aCmd);
        } else {
          v = "<toc>";
          return <v, v>;
        }
    }
    
    tuple[str quote, str execute] handle(TokenOrCmdList tocList){
        if(appl(_,list[Tree] args) := tocList) {
            qt = "";
            ex = "";
            if(tocList is parens){
               qt += "(<args[1]>"; ex += "(<args[1]>";
               <qt1, ex1> = handle(tocList.tocList);
               qt += "<qt1><args[3]>)"; ex += "<ex1><args[3]>)";
               if(TokenOrCmdList toc2 <- tocList.optTocList){
                  qt += "<args[5]>"; ex += "<args[5]>"; 
                  <qt2, ex2> = handle(toc2);
                  qt += qt2; ex += ex2;
               }
            } else {
              <qt, ex> = handle(tocList.toc);
              if(TokenOrCmdList toc2 <- tocList.optTocList){
                  qt += "<args[1]>"; ex += "<args[1]>"; 
                  <qt1, ex1> = handle(toc2);
                  qt += qt1; ex += ex1;
               }
            }
            println("handle toc: <tocList> =\> <qt>, <ex>");
            return <qt, ex>;
        } else {
          throw "Cannot match parse tree: <tocList>";
        }
    }
    
    <qt, ex> = handle(q);
    return qt;
}

int questionId = 0;

//void process(loc qloc, loc aloc, str questions){
//    qs = parse(questions);
//    questionId = 0;
//    for(q <- qs.questions){
//        println(process(q));
//    }
//}

str removeComments(Intro? intro){
   res = "";
   for(line <- split("\n", "<intro>")){
       if(!startsWith(line, "//")){
          res += line + "\n";
       }
   }
   //println("removeComments: intro = @<intro>@ =\> <res>");
   return res;
}

@deprecated
public str compileQuestions(str qmodule, list[loc] srcs, list[loc] libs, list[loc] courses, loc bin, loc boot) {
    println("compileQuestions: <qmodule>, <srcs>, <libs>, <courses>, <bin>, <boot>");
    pcfg = pathConfig(srcs=[|test-modules:///|]+srcs,libs=libs,bin=bin, boot=boot);
    bn = split("/", qmodule)[-1];
    qloc = courses[0] + ("/" + qmodule + "/" + bn + ".questions");
    println("compileQuestions: qloc=<qloc>");
    return compileQuestions(qloc, pcfg);
}

public str compileQuestions(str qmodule, PathConfig pcfg) {
    println("compileQuestions: <qmodule>, <pcfg>");
    pcfg = pathConfig(srcs=[|test-modules:///|]+pcfg.srcs,libs=pcfg.libs,bin=pcfg.bin, boot=pcfg.boot,courses=pcfg.courses);
    bn = split("/", qmodule)[-1];
    qloc = pcfg.courses[0] + ("/" + qmodule + "/" + bn + ".questions");
    println("compileQuestions: qloc=<qloc>");
    return compileQuestions(qloc, pcfg);
}

public str compileQuestions(loc qloc, PathConfig pcfg){
   println("compileQuestions: <qloc>");
   return process(qloc, pcfg);
}

str process(loc qloc, PathConfig pcfg){
    iqs = parse(qloc);
    questionId = 0;
    
    bn = qloc.file;
    if(/^<b:.*>\..*$/ := qloc.file) bn = b;
    
    res = "# <bn>
          '
          '++++
          '\<script src=\"http:///code.jquery.com/jquery-3.1.1.js\"\>\</script\>
          '\<script type=\"text/javascript\" src=\"https://code.jquery.com/ui/1.11.4/jquery-ui.min.js\"\>\</script\>
          '++++
          '";
    for(iq <- iqs.introAndQuestions){
        println("process: <iq>");
        intro = removeComments(iq.intro);
        res += (intro + "\n" + process("<iq.description>", iq.question, pcfg) +"\n");
    }
    res += "
           '++++
           '\<script src=\"tutor-prelude.js\"\>\</script\>
           '++++
           '";
    return res;
}

// ---- CodeQuestion

str process(str text, (Question) `<CodeQuestion q>`, PathConfig pcfg){
    prep_quoted = prep_executed = "";
    prep_holes = false;
    env1 = ();
    questionId += 1;
  
    if(Prep p <- q.prep){
        <prep_quoted, prep_executed, prep_holes, env1> = preprocessCode(questionId, p.text, "", (), pcfg);
        println("prep_quoted: <prep_quoted>, prep_executed: <prep_executed>, prep_holes: <prep_holes>");
    }
    
    expr_quoted = expr_executed = "";
    expr_holes = false;
    env2 = env1;
    if(Expr e <- q.expr){
        <expr_quoted, expr_executed, expr_holes, env2> = preprocessCode(questionId, e.text, prep_executed, env1, pcfg);
        println("expr_quoted: <expr_quoted>, expr_executed: <expr_executed> expr_holes: <expr_holes>");
        return codeQuestionMarkup(questionId, text, 
                                    "module Question<questionId>
                                    '<prep_quoted><"<prep_quoted>" == "" ? "" : "\n">
                                    'test bool <e.name>() = 
                                    '     <expr_quoted> == <expr_holes ? eval(questionId, expr_executed, prep_executed, pcfg) : holeMarkup(1)>;
                                    '");
    }
    if(prep_holes){
        println("prep_holes: <prep_executed>");
        
        runTests(questionId, prep_executed, pcfg);
        return codeQuestionMarkup(questionId, text, "module Question<questionId>
                                    '<prep_quoted>
                                    ");
    }
    throw "Incorrect question: no expr given and no holes in prep code";
}

str replaceHoles(str code){
    return replaceAll(visit(code){
        case /^\+\+\+[^\+]+\+\+\+/ => "_"
    }, "\n", "\\n");
}

str escape(str code){
    return replaceAll(code, "\"", "&quot;");
}

str removeSpacesAroundHoles(str code){
    return visit(code){
        case /^[ ]+\+\+\+/ => " +++"
        case /^\+\+\+[ ]+/ => "+++ "
    };
}

str codeQuestionMarkup(int n, str text, str code){
    return ".Question <n>
           '<text>
           '++++
           '\<div id=\"Question<n>\" 
           '    class=\"code-question\"
           '    listing=\"<escape(replaceHoles(code))>\"\>
           '++++
           '[source,rascal,subs=\"normal\"]
           '----
           '<removeSpacesAroundHoles(code)>
           '----
           '++++
           '\</div\>
           '++++";
}

// ---- ChoiceQuestion

str process(str text, (Question) `<ChoiceQuestion q>`, PathConfig pcfg){
    questionId += 1;
    return choiceQuestionMarkup(questionId, text, q.choices);
}

str choiceQuestionMarkup(int n, str explanation, Choice* choices){
    return ".Question <n>
           '<explanation>
           '++++
           '\<div id=\"Question<n>\"
           '      class=\"choice-question\"\>
           '<for(ch <- choices){>
           '    \<input type=\"radio\" class=\"choice-input\" name=\"Question<n>\" value=\"<ch.correct>\" feedback=\"<trim("<ch.feedback>")>\"\>
           '        \<div class=\"choice-description\"\> <ch.description>\</div\>
           '<}>
           '\</div\>
            '++++
           '";
}

// ---- ClickQuestion

str process(str explanation, (Question) `<ClickQuestion q>`, PathConfig pcfg){
    questionId += 1;
    qt = preprocessClick(questionId, q.text);
    
    return clickQuestionMarkup(questionId, explanation, qt);
}

str clickQuestionMarkup(int n, str explanation, str code){
 return ".Question <n>
           '<explanation>
           '++++
           '\<div id=\"Question<n>\"
           '      class=\"click-question\"\>
           '++++
           '[source,rascal,subs=\"normal\"]
           '----
           '<code>
           '----
           '++++
           '\</div\>
            '++++
           '";
}

// ---- MoveQuestion

str process(str explanation, (Question) `<MoveQuestion q>`, PathConfig pcfg){
    println("process: <q>");
    questionId += 1;
    if(Decoy d <- q.decoy){
        return moveQuestionMarkup(questionId, explanation, "<q.text>", "<d.text>");
    } else {
        return moveQuestionMarkup(questionId, explanation, "<q.text>", "");
    }
}

data Fragment = fragment(int index, list[str] lines, int pre, int post);

int indent(str s) = /^<a:[ ]*>/ := s ? size(a) : 0;

list[list[str]] makeSegments(list[str] lines){
   list[list[str]] segments = [];
   if(any(str line <- lines, startsWith(line, "---"))){
        cur = [];
        for(str line <- lines){
            if(startsWith(line, "---")){
                segments += [cur];
                cur = [];
            } else {
                cur += [line];
            }
        }
        if(size(cur) > 0){
            segments += [cur];
        }
    } else {
      for(int i <- index(lines)){
          if(i + 2 < size(lines)){
            segments += [lines[i .. i + 2]];
          } else {
            segments += [lines[i ..]];
          }
      }
   }
   return segments;
}

str moveQuestionMarkup(int n, str explanation, str code, str decoy){
    println("code: <code>");
    println("decoy: <decoy>");
    code_lines = split("\n", code);
    segments = makeSegments(code_lines);
    fragments = [fragment(i, segments[i], indent(segments[i][0]), indent(segments[i][-1])) | i <- index(segments)];
    
    decoy_fragments = [];
    decoy_lines = split("\n", decoy);
    if(size(decoy) > 0){
        decoy_segments = makeSegments(decoy_lines);
        decoy_fragments = [fragment(-1, decoy_segments[i], 0, 0) | i <- index(decoy_segments)];
    }

    gcode = "";
    ftop = -260;
    initialIndent = fragments[0].pre;
    
    for(f <- shuffle(fragments + decoy_fragments)){
        
        minIndent = min(f.pre, f.post);
        flines = "";
        for(line <- f.lines){
           flines += line[minIndent..] + "\n";
        }
        gcode += "\<div id=\"box-<f.index>\" class=\"movable-code\" index=\"<f.index>\" indent=\"<(f.pre - initialIndent)/2>\" style=\"position:relative;top:<ftop>px;\"\>
                  '\<pre\>\<code\>"
                  +
                  "<flines>\</code\>\</pre\>\</div\>\n";
        ftop += size(f.lines) * 9;
    }
    id = "Question<n>";
    return 
    ".Question <n>
           '<explanation>
           '++++
           '\<div id=\"<id>\"
           '      class=\"move-question\"\>
           '\<div id=\"movable-code-src-<id>\" class=\"movable-code-src\" \"lines=\"<size(code_lines + decoy_lines)>\"\>
           '\<div id=\"movable-code-target-<id>\" class=\"movable-code-target\"\>
           '\</div\>
            "
            + gcode
            +
           "\</div\>
           '\</div\>
            '++++
           '";
           
           // '\<form id=\"movable-code-form-<id>\" class=\"movable-code-form\"\>
           //'\<input type=\"submit\" value=\"Submit Answer\"\>
           // '\</form\>
}

// ---- FactQuestion
str process(str explanation, (Question) `<FactQuestion q>`, PathConfig pcfg){
    questionId += 1;
    return factQuestionMarkup(questionId, explanation, q.facts);
}

str factQuestionMarkup(int n, str explanation, Fact+ facts){
    s1 = [];
    s2 = [];
    
    afacts = [f | f <- facts];
    
    for(int i <- index(afacts)){
        fact = afacts[i];
        s1 += ["\<li index=\"<i>\" class=\"fact-item\"\>\<tt\><trim("<fact.leftText>")>\</tt\>\</li\>\n"];
        s2 += ["\<li index=\"<i>\" class=\"fact-item\"\>\<tt\><trim("<fact.rightText>")>\</tt\>\</li\>\n"];
    }
    
    id = "Question<n>";
    return 
           ".Question <n>
           '<explanation>
           '++++
           '\<div id=\"<id>\" class=\"fact-question\"\>
           '\<ul id=\"sortable1-<id>\" class=\"sortableLeft\"\>
           '<intercalate("\n", shuffle(s1))>
           '\</ul\>
           '\<ul id=\"sortable2-<id>\" class=\"sortableRight\"\>
           '<intercalate("\n", shuffle(s2))>
           '\</ul\>
           '\</div\>
           '++++
           '";
}

// ----


loc makeQuestion(int questionId, PathConfig pcfg){
    for(f <- pcfg.bin.ls){
        if(/Question/ := "<f>"){
        //println("remove: <f>");
           remove(f);
        }
    }
    mloc = |test-modules:///| + "Question<questionId>.rsc";
    return mloc;
}

value eval(int questionId, str exp, str setup, PathConfig pcfg) {
    println("eval: <exp>, <setup>");
    Q = makeQuestion(questionId, pcfg);
    msrc = "module Question<questionId> <setup> value main() {<exp>;}";
    writeFile(Q, msrc);
    try {
       compileAndLink("Question<questionId>", pcfg); 
       return execute(Q, pcfg);
    } catch e:{
       println("*** While evaluating <exp> in
               '    <msrc> 
               '*** the following error occurred: 
               '    <e>");
       throw "Error while evaluating expression <exp>";
    }
}

void runTests(int questionId, str mbody, PathConfig pcfg){
    Q = makeQuestion(questionId, pcfg);
    msrc = "module Question<questionId> <mbody>";
    println(msrc);
    writeFile(Q, msrc);
    try {
       //compileAndLink("Question<questionId>", pcfg); 
       //res = execute(Q, pcfg, testsuite=true);
       //if(!printTestReport(res, [])){
       if(true !:= rascalTests(["Question<questionId>"], pcfg, recompile=true)){
          throw "Errors while executing testsuite for question";
       }
    } catch e: {
       println("*** While running tests for 
               '    <msrc> 
               '*** the following error occurred: 
               '    <e>");
       throw "Error while running tests";
    }
} 

value main(){
    println("In main");
    PathConfig pcfg = 
    pathConfig(srcs=[|test-modules:///|, |file:///Users/paulklint/git/rascal/src/org/rascalmpl/library|], 
               bin=|file:///Users/paulklint/git/rascal/bootstrap/phase2|, 
               boot=|file:///Users/paulklint/git/rascal/bootstrap/phase2|,
               libs=[|home:///git/rascal/bootstrap/phase2/org/rascal/mpl/library|]);
    res = compileQuestions("ADocTest/Questions", pcfg.srcs, pcfg.libs, [|home:///git/rascal/src/org/rascalmpl/courses|], pcfg.bin, pcfg.boot);
    println(res);
    writeFile(|file:///Users/paulklint/git/rascal/bootstrap/phase2/courses/AdocTest/Questions/Questions.adoc|, res);
    return true;
}