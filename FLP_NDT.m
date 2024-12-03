clc;
clear;

%% Parameters for Enhanced Geometry
length = 50;                % Length of the material (in arbitrary units)
width = 30;                 % Width of the material (in arbitrary units)
crack_length = 10;          % Length of the crack (in arbitrary units)
crack_width = 3;            % Width of the crack (in arbitrary units)
crack_intensity = 150;      % Fluorescence intensity in the crack region
base_intensity = 100;       % Base fluorescence intensity

% Material Properties for Titanium Alloy
sigma = 2.38e6;             % Electrical conductivity (S/m)
mu = 4*pi*1e-7;             % Magnetic permeability (H/m)
density = 4420;             % Density (kg/m^3)

%% Create Enhanced Curved Surface Geometry
[X, Y] = meshgrid(1:width, 1:length);  % Create a grid for the surface

% Create a simple curvature for the surface
Z = sin(pi*X/width) .* cos(pi*Y/length) * 5; % A curved surface for better aesthetics

%% Fluorescence Intensity Simulation (Add Crack Region)
% Create a baseline fluorescence intensity
fluorescence_intensity = base_intensity * ones(size(Z));

% Define crack region and simulate the fluorescence intensity increase
crack_start_x = 20;        % Start position of the crack along length
crack_start_y = 8;         % Start position of the crack along width
crack_end_x = crack_start_x + crack_length - 1;
crack_end_y = crack_start_y + crack_width - 1;

% Increase the fluorescence intensity in the crack region
fluorescence_intensity(crack_start_x:crack_end_x, crack_start_y:crack_end_y) = crack_intensity;

%% 3D Visualization of Surface and Fluorescence Intensity
figure;
surf(X, Y, Z, fluorescence_intensity, 'EdgeColor', 'none'); % Plot surface with fluorescence intensity
colormap('jet');
colorbar;
shading interp; % Smooth shading
title('3D VISUALISATION OF CURVED SURFACE WITH CRACK FLUORESCENCE INTENSITY');
xlabel('WIDTH (ARBITRARY UNITS)');
ylabel('LENGTH (ARBITRARY UNITS)');
zlabel('SURFACE HEIGHT');
light; % Add a light source for better visualization
camlight('headlight'); % Adjust light to focus on the plot
lighting gouraud; % Smooth lighting
view(45, 30); % Adjust the view angle

%% Zoom into the Crack Region for Detailed Visualization
% Zoom into the crack region for better inspection
focus_surface = fluorescence_intensity(crack_start_x-5:crack_end_x+5, crack_start_y-5:crack_end_y+5);
[X_focus, Y_focus] = meshgrid(1:size(focus_surface, 2), 1:size(focus_surface, 1));
Z_focus = Z(crack_start_x-5:crack_end_x+5, crack_start_y-5:crack_end_y+5);

figure;
surf(X_focus, Y_focus, Z_focus, focus_surface, 'EdgeColor', 'none'); % Crack region surface
colormap('hot');
colorbar;
shading interp;
title('ZOOMED-IN VIEW OF CRACK REGION');
xlabel('WIDTH (ARBITRARY UNITS)');
ylabel('LENGTH (ARBITRARY UNITS)');
zlabel('FLUORESCENCE INTENSITY');
light;
camlight('headlight');
lighting phong;
view(60, 40); % Adjust view angle for clarity

% Add contour to highlight crack region
hold on;
contour3(X_focus, Y_focus, Z_focus, 10, 'k', 'LineWidth', 1.5); % Crack contours
hold off;

%% Fluorescence Intensity Profile
% Plot a profile of fluorescence intensity along a line passing through the crack
crack_profile = fluorescence_intensity(crack_start_x:crack_end_x, crack_start_y + round(crack_width/2));
figure;
plot(crack_start_x:crack_end_x, crack_profile);
title('FLUORESCENCE INTENSITY PROFILE ALONG CRACK');
xlabel('LENGTH (ARBITRARY UNITS)');
ylabel('FLUORESCENCE INTENSITY');
grid on;

%% Fluorescence Intensity Distribution Across the Surface
% Plot the fluorescence intensity distribution across the entire surface
figure;
imagesc(fluorescence_intensity);
colormap('jet');
colorbar;
title('FLUORESCENCE INTENSITY DISTRIBUTION ACROSS THE SURFACE');
xlabel('WIDTH (ARBITRARY UNITS)');
ylabel('LENGTH (ARBITRARY UNITS)');

%% Save the Results
save('Enhanced_Geometry_with_Crack_Fluorescence.mat', 'Z', 'fluorescence_intensity', 'focus_surface');
disp('Enhanced geometry visualization complete. Results saved.');
