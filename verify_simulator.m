%% ----------------- Launch & Verify Simulator -----------------

% 1. Set current folder to your project
projectFolder = 'C:\Users\vivian.taylor1\OneDrive - Naval Postgraduate School\Documents\MATLAB\Team Runtime Legends';
cd(projectFolder);

% 2. Add project subfolders to MATLAB path
addpath(genpath(projectFolder));

% 3. Launch the OceanUserInterface GUI
sim = OceanUserInterface();
pause(1);  % wait a moment to ensure GUI initializes

% 4. Safely enable ocean environment for verification
if isprop(sim, 'OceanEnabled')
    sim.OceanEnabled = true;
    if isprop(sim, 'simEngine') && ~isempty(sim.simEngine)
        sim.simEngine.logStatus('Ocean environment enabled for verification.');
    end
end

%% 5. Verification of SEFleet, SEMinefield, SEMine
fprintf('\n--- Verification Start ---\n');

% 5a. SEFleet
try
    fleet = sim.simEngine.fleet;
    fleet.reset();
    fprintf('SEFleet: %d ships initialized successfully.\n', fleet.numShips);
catch ME
    warning('SEFleet verification failed: %s', ME.message);
end
% 5b. SEMinefield
try
    minefield = sim.simEngine.minefield;
    minefield.reset();
    fprintf('SEMinefield: %d mines initialized successfully.\n', minefield.number_of_mines);
catch ME
    warning('SEMinefield verification failed: %s', ME.message);
end

% 5c. SEMine deletion (test first 3 mines)
try
    for i = 1:min(3, numel(minefield.mines))
        m = minefield.mines(i);
        if isvalid(m)
            delete(m);
        end
    end
    fprintf('SEMine: Sample mines deleted successfully.\n');
    catch ME
    warning('SEMine deletion test failed: %s', ME.message);
end

fprintf('--- Verification Complete ---\n');