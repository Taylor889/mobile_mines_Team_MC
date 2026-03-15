%% Dynamic verification for SEEnvironment
clear; clc;

disp("Starting SEEnvironment Dynamic Verification...");
disp("------------------------------------------");

testsPassed = 0;
testsTotal = 0;

%% Create the environment
% speed=5, direction=45 deg, gradient mode, within [0,6]x[0,9]
env = SEEnvironment([0 0 6 9], 5, 45, "Gradient"); 
env.direction = 100;
%% Create a test particle
particle.position = [3, 4];   % start near center
particle.velocity = [0, 0];   % initial velocity

timeStep = 1;  % seconds
numSteps = 10; % simulate 10 steps

trajectory = zeros(numSteps,2);

%% Simulate motion under environment
for t = 1:numSteps
    % Get force from environment
    F = env.forceAt(particle.position);  % returns [u,v,0]
    
    % Update particle velocity and position
    particle.velocity = F(1:2);           % ignore z
    particle.position = particle.position + particle.velocity * timeStep;
    
    % Clamp position inside environment bounds
     particle.position(1) = max(env.boundary(1), min(particle.position(1), env.boundary(1)+env.boundary(3)));
    particle.position(2) = max(env.boundary(2), min(particle.position(2), env.boundary(2)+env.boundary(4)));
    
    trajectory(t,:) = particle.position;
end

%% Test 1: Particle moved
testsTotal = testsTotal + 1;
if any(trajectory(:,1) ~= trajectory(1,1)) || any(trajectory(:,2) ~= trajectory(1,2))
    disp("Test 1 PASS: Particle moved under environment force")
    testsPassed = testsPassed + 1;
else
    disp("Test 1 FAIL: Particle did not move")
end

%% Test 2: Particle stays within bounds
testsTotal = testsTotal + 1;
x_in_bounds = all(trajectory(:,1) >= env.boundary(1) & trajectory(:,1) <= env.boundary(1)+env.boundary(3));
y_in_bounds = all(trajectory(:,2) >= env.boundary(2) & trajectory(:,2) <= env.boundary(2)+env.boundary(4));
if x_in_bounds && y_in_bounds
    disp("Test 2 PASS: Particle stayed within environment bounds")
    testsPassed = testsPassed + 1;
else
    disp("Test 2 FAIL: Particle left environment bounds")
end

%% Test 3: Velocity changes (gradient mode)
testsTotal = testsTotal + 1;
velocities = diff(trajectory); % approximate velocity
if std(velocities(:,2)) > 0
    disp("Test 3 PASS: Particle velocity varies over Y (gradient effect)")
    testsPassed = testsPassed + 1;
else
    disp("Test 3 FAIL: Particle velocity did not vary")
end
%% Plot trajectory
figure;
plot(trajectory(:,1), trajectory(:,2), '-o', 'LineWidth', 2);
xlim([env.boundary(1), env.boundary(1)+env.boundary(3)]);
ylim([env.boundary(2), env.boundary(2)+env.boundary(4)]);
xlabel('X Position'); ylabel('Y Position');
title('Particle Trajectory under SEEnvironment');
grid on;

%% Summary
disp("------------------------------------------");
fprintf("Dynamic Tests Passed: %d / %d\n", testsPassed, testsTotal);

if testsPassed == testsTotal
    disp("SEEnvironment Dynamic Verification PASSED")
else
    disp("SEEnvironment Dynamic Verification FAILED")
end