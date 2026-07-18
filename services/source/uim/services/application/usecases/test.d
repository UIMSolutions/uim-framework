/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.application.usecases.test;

import uim.services;

mixin(ShowModule!());

@safe:

struct TestResult {
    bool success;
    UsecaseResult result;
    string message;

    this(UsecaseResult result) {
        this.result = result;
        this.success = result.success;
        this.message = result.message;
    }
}

TestResult testUseCase(Usecase usecase, Json input) {
    auto result = usecase.execute(input);
    return TestResult(result);
}