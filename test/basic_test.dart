import 'package:unittest/unittest.dart';
import 'package:cargo/cargo_server.dart';
import 'package:bountyhunter/bountyhunter.dart';

void main() {
  // First tests!
  Cargo storage = new Cargo(MODE: CargoMode.MEMORY);

  storage.start().then((_) {
    // create a new instance of Hunter 
    Hunter hunter = new Hunter( storage );
    test('test basic search', () {
        hunter.feedDoc("hello world", "A 'Hello world' program is a computer program that outputs 'Hello, World!' (or some variant thereof) on a display device. Because it is typically one of the simplest programs possible in most programming languages, it is by tradition often used to illustrate to beginners the most basic syntax of a programming language. It is also used to verify that a language or system is operating correctly.");
        hunter.feedDoc("computer program", "A computer program, or just a program, is a sequence of instructions, written to perform a specified task with a computer.[1] A computer requires programs to function, typically executing the program's instructions in a central processor.[2] The program has an executable form that the computer can use directly to execute the instructions. The same program in its human-readable source code form, from which executable programs are derived (e.g., compiled), enables a programmer to study and develop its algorithms. A collection of computer programs and related data is referred to as the software.");
        hunter.feedDoc("instruction set", "An instruction set, or instruction set architecture (ISA), is the part of the computer architecture related to programming, including the native data types, instructions, registers, addressing modes, memory architecture, interrupt and exception handling, and external I/O. An ISA includes a specification of the set of opcodes (machine language), and the native commands implemented by a particular processor.");
        hunter.feedDoc("data types", "In computer science and computer programming, a data type or simply type is a classification identifying one of various types of data, such as real, integer or Boolean, that determines the possible values for that type; the operations that can be done on values of that type; the meaning of the data; and the way values of that type can be stored.");
        hunter.feedDoc("dartlang", "Dart is an open-source Web programming language developed by Google. It was unveiled at the GOTO conference in Aarhus, October 10–12, 2011. The goal of Dart is 'ultimately to replace JavaScript as the lingua franca of web development on the open web platform'. Until then, in order to run in mainstream browsers, Dart relies on a source-to-source compiler to JavaScript. To attempt performance gains, Google engineers have evolved Dart as well as extended JavaScript, since 'pursuing either strategy in isolation [would be] likely to fail.' However, Dart has had mixed reception and the Dart initiative has been criticized by industry leaders for fragmenting the web, in much the same way as VBScript. According to the project site, Dart was 'designed to be easy to write development tools for, well-suited to modern app development, and capable of high-performance implementations.'");
    
        List<Bounty> results = hunter.search("set architecture");
        
        expect(results.length, 1);
        expect(results.first.name, "instruction set");
    });
  });
}
