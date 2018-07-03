%% 2D-array case, spectrum in linear scale in UV-space

% Position of sensors and weighting of 2D array
% Create circular array
nElements = 20;
radius = 0.6;

[xPos, yPos] = pol2cart((0:1/nElements:1-1/nElements)*2*pi, ones(1,nElements)*radius);
zPos = zeros(1, numel(xPos));
elementWeights = ones(1,numel(xPos))/numel(xPos);

% Define arriving angles of input signals
thetaArrivalAngles = [30 20 30];
phiArrivalAngles = [10 70 210];

% Define array scanning angles
thetaScanAngles = -90:0.5:90;
phiScanAngles = 0:1:180;

% Create input signal
inputSignal = createSignal(xPos, yPos, zPos, f, c, fs, thetaArrivalAngles, phiArrivalAngles);

% Update steering vector and also save UV-space coordinates
[e, u, v] = steeringVector(xPos, yPos, zPos, f, c, thetaScanAngles, phiScanAngles);

% Update cross spectral matrix
R = crossSpectralMatrix(inputSignal);

% Calculate delay-and-sum steered response
S = steeredResponseDelayAndSum(R, e, elementWeights);

%Normalise spectrum
spectrumNormalized = abs(S)/max(max(abs(S)));


%Plot array
fig3 = figure;
fig3.Color = 'w';
ax = axes('Parent', fig3);
scatter(ax, xPos, yPos, 20, 'filled')
axis(ax, 'square')
ax.XLim = [-1 1];
ax.YLim = [-1 1];
grid(ax, 'on')
title(ax, 'Microphone positions')

%Plot steered response in UV-space
fig4 = figure;
ax = axes('Parent', fig4);
surf(ax, u, v, spectrumNormalized, 'edgecolor', 'none', 'FaceAlpha', 0.8)

%Do some magic to make the figure look nice (black theme)
fig4.Color = 'k';
ax.Color = 'k';
cmap = colormap;
cmap(1,:) = [1 1 1]*0.2;
colormap(ax, cmap);
view(ax, 0, 90)
axis(ax, 'square')
ax.XColor = 'w';
ax.YColor = 'w';
ax.ZColor = 'w';
ax.XTickLabel = [];
ax.YTickLabel = [];
ax.ZTickLabel = [];
ax.XMinorGrid = 'on';
ax.YMinorGrid = 'on';
ax.ZMinorGrid = 'on';
ax.MinorGridColor = 'w';
ax.MinorGridLineStyle = '-';
xlabel(ax, 'u = sin(\theta)cos(\phi)')
ylabel(ax, 'v = sin(\theta)sin(\phi)')