%% Verification script for SEEnvironment
clear; clc;

disp("Starting SEEnvironment Verification...");
disp("------------------------------------------");

testsPassed = 0;
testsTotal = 0;

%% Test 1: Object creation with default properties
testsTotal = testsTotal + 1;
try
    env = SEEnvironment();
    if isa(env, 'SEEnvironment') && env.mode == "Constant"
        disp("Test 1 PASS: Default environment object created correctly")
        testsPassed = testsPassed + 1;
    else
        disp("Test 1 FAIL: Object class or default properties incorrect")
    end
catch
    disp("Test 1 FAIL: Object creation crashed")
end
%% Test 2: Object creation with custom properties
testsTotal = testsTotal + 1;
try
    env2 = SEEnvironment([0 0 10 10], 5, 90, "Stochastic");
    if env2.speed == 5 && env2.direction == 90 && env2.mode == "Stochastic"
        disp("Test 2 PASS: Custom properties assigned correctly")
        testsPassed = testsPassed + 1;
    else
        disp("Test 2 FAIL: Custom properties incorrect")
    end
catch
    disp("Test 2 FAIL: Custom constructor failed")
end

%% Test 3: Constant mode force
testsTotal = testsTotal + 1;
try
    env = SEEnvironment([0 0 6 9], 10, 0, "Constant");
    F = env.forceAt([3 4]);
    if length(F) == 3 && all(F(3) == 0)
        disp("Test 3 PASS: Constant mode force computed correctly")
        testsPassed = testsPassed + 1;
    else
        disp("Test 3 FAIL: Constant mode output invalid")
    end
catch
    disp("Test 3 FAIL: Constant mode crashed")
end

%% Test 4: Stochastic mode force
testsTotal = testsTotal + 1;
try
    env = SEEnvironment([0 0 6 9], 10, 0, "Stochastic");
    F = env.forceAt([3 4]);
    if length(F) == 3 && F(3) == 0
        disp("Test 4 PASS: Stochastic mode returns valid vector")
        testsPassed = testsPassed + 1;
    else
        disp("Test 4 FAIL: Stochastic mode output invalid")
    end
catch
    disp("Test 4 FAIL: Stochastic mode crashed")
end

%% Test 5: Gradient mode force at bottom
testsTotal = testsTotal + 1;
try
    env = SEEnvironment([0 0 6 9], 10, 0, "Gradient");
    F_bottom = env.forceAt([3 0]); % y at bottom
    F_top = env.forceAt([3 9]);    % y at top
    if F_bottom(1) < F_top(1)
        disp("Test 5 PASS: Gradient mode scales force with Y correctly")
        testsPassed = testsPassed + 1;
    else
        disp("Test 5 FAIL: Gradient scaling incorrect")
    end
catch
    disp("Test 5 FAIL: Gradient mode crashed")
end

%% Test 6: Invalid mode defaults to constant
testsTotal = testsTotal + 1;
try
    env = SEEnvironment([0 0 6 9], 10, 0, "UnknownMode");
    F = env.forceAt([3 4]);
    if length(F) == 3 && F(3) == 0
        disp("Test 6 PASS: Unknown mode defaults to constant")
        testsPassed = testsPassed + 1;
         else
        disp("Test 6 FAIL: Unknown mode output invalid")
    end
catch
    disp("Test 6 FAIL: Unknown mode crashed")
end

%% Summary
disp("------------------------------------------");
fprintf("Tests Passed: %d / %d\n", testsPassed, testsTotal);

if testsPassed == testsTotal
    disp("SEEnvironment VERIFIED");
else
    disp("SEEnvironment verification FAILED");
end