module uim.services.domain.mixins.enumerations;

import uim.services;

mixin(ShowModule!());

@safe:

string EnumSwitch(string enumType, string defaultvalue, bool ignoreCase = true) {
    return `
    switch (`
        ~ (ignoreCase ? "value.toLower()" : "value") ~ `) {
        static foreach (member; __traits(allMembers, `
        ~ enumType ~ `)) {
    case `
        ~ (ignoreCase ? "member.toLower()" : "member") ~ `:
            return __traits(getMember, `
        ~ enumType ~ `, member);
        }
    default:
        return `
        ~ enumType ~ `.` ~ defaultvalue ~ `;
    }`;
}
///
unittest {
    enum TestEnum {
        one,
        two,
        three
    }

    // Example usage of EnumSwitch mixin
    {
        TestEnum toTestEnum(string value) {
            mixin(EnumSwitch("TestEnum", "one"));
        }

        assert(toTestEnum("two") == TestEnum.two);
        assert(toTestEnum("TWO") == TestEnum.two);
        assert(toTestEnum("FOUR") == TestEnum.one);
    }

    // Case-sensitive example
    {
        TestEnum toTestEnum(string value) {
            mixin(EnumSwitch("TestEnum", "one", false));
        }

        assert(toTestEnum("two") == TestEnum.two);
        assert(toTestEnum("TWO") == TestEnum.one);
        assert(toTestEnum("FOUR") == TestEnum.one);
    }
}
