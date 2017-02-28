include "console.iol"
include "string_utils.iol"

constants {
    A: int,
    B: string,
    C: string,
    NON_EXTERNAL_CONSTANT = 10,
    ANOTHER_CONSTANT = 42 {
        .test[0] = 10,
        .test[1] = 11,
        .test[2] = 12,
        .test[3] = 13,
        .more = 42
    },
    CONSTANT_LOCATION = "socket://localhost:12345",
    SELF_CONFIG = {
        .LOCATION = "as"
    },
    SELF_PROTOCOL = sodep
}

interface IBogus {
    RequestResponse:
        foo(void)(void)
}

outputPort TestOutputPort {
    Location: C
    Protocol: sodep
    Interfaces: IBogus
}

inputPort Self {
    Location: COMMAND_LINE_ARGUMENT
    Protocol: COMMAND_LINE_PROTOCOL
    Interfaces: IBogus
}

/*
define DontAllowLinkToConstant {
    link -> A;
    link++
}

define DontAllowOperatorAssign {
    A++;
    A--;
    ++A;
    --A;
    A += 1;
    A -= 1;
    A /= 1;
    A *= 1
}

define DontAllowUndef {
    undef(A)
}

define DontAllowLinkToConstantInternal {
    link -> NON_EXTERNAL_CONSTANT;
    link++
}

define DontAllowOperatorAssignInternal {
    NON_EXTERNAL_CONSTANT++;
    NON_EXTERNAL_CONSTANT--;
    ++NON_EXTERNAL_CONSTANT;
    --NON_EXTERNAL_CONSTANT;
    NON_EXTERNAL_CONSTANT += 1;
    NON_EXTERNAL_CONSTANT -= 1;
    NON_EXTERNAL_CONSTANT /= 1;
    NON_EXTERNAL_CONSTANT *= 1
}

define DontAllowUndefInternal {
    undef(NON_EXTERNAL_CONSTANT)
}
*/

define DoAllowDeepCopyAndAssign {
    copy << A;
    copy++;
    --copy;
    copy += 1;
    copy -= 1;
    copy /= 1;
    copy *= 1;
    copy.a = 0;
    copy = 10;
    undef(copy)
}

define DoAllowCopyAndAssign {
    copy = A;
    copy++;
    --copy;
    copy += 1;
    copy -= 1;
    copy /= 1;
    copy *= 1;
    copy.a = 0;
    copy = 10;
    undef(copy)
}

define TestConstantInDefine {
    println@Console(A)()
}

define TestValueOfCopy {
    copy = A;
    copy++;
    println@Console(copy)()
}

define TestValueOfDeepCopy {
    copy << A;
    println@Console(copy)();
    copy++;
    println@Console(copy)()
}

init {
    someValue = 42
}

main {
    //DontAllowUndef;
    //DontAllowOperatorAssign;
    //DontAllowLinkToConstant;
    //DontAllowUndefInternal;
    //DontAllowOperatorAssignInternal;
    //DontAllowLinkToConstantInternal;
    DoAllowCopyAndAssign;
    DoAllowDeepCopyAndAssign;
    TestConstantInDefine;
    TestValueOfCopy;
    TestValueOfDeepCopy;

    println@Console(TestOutputPort.location)();
    println@Console(NON_EXTERNAL_CONSTANT)();
    valueToPrettyString@StringUtils(ANOTHER_CONSTANT)(pretty);
    println@Console(pretty)();

    nullProcess
}
