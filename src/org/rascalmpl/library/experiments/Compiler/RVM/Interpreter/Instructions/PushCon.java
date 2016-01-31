package org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.Instructions;

import org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.CodeBlock;
import org.rascalmpl.library.experiments.Compiler.RVM.ToJVM.BytecodeGenerator;
import org.rascalmpl.value.IValue;

public class PushCon extends Instruction {

	int constant;

	public PushCon(CodeBlock cb, int constant) {
		super(cb, Opcode.PUSHCON);
		this.constant = constant;
	}

	public String toString() {
		return "PUSHCON " + constant + "[" + codeblock.getConstantValue(constant) + "]";
	}

	public void generate() {
		codeblock.addCode1(opcode.getOpcode(), constant);
	}

	public void generateByteCode(BytecodeGenerator codeEmittor, boolean debug) {
		if (debug) {
			codeEmittor.emitDebugCall(opcode.name());
			codeEmittor.emitCallWithArgsSSFI("insnPUSHCON", constant, debug);
		}

		IValue val = codeblock.getConstantValue(constant);
		codeEmittor.emitInlinePushConOrType(constant,true,debug);
	}
}