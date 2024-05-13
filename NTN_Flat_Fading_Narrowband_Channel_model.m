commonParams = struct;
commonParams.CarrierFrequency = 2e9; % In Hz
commonParams.ElevationAngle = 50; % In degrees
commonParams.SatelliteAltitude = 600000; % In m
commonParams.SatelliteSpeed = 7562.2; % In m/s
commonParams.MobileSpeed = 3*1000/3600; % In m/s
commonParams.SampleRate = 15000000; % In Hz
% Set the random stream and seed, for reproducibility
commonParams.RandomStream = "mt19937ar with seed";
commonParams.Seed = 73;
% Set the number of sinusoids used in generation of
Doppler spread
commonParams.NumSinusoids = 48;
% Initialize the NTN flat fading narrowband channel
parameters in a
% structure
ntnNarrowbandParams = commonParams;
ntnNarrowbandParams.NTNChannelType = "Narrowband";
ntnNarrowbandParams.Environment = "Residential";
ntnNarrowbandParams.AzimuthOrientation = 0;
ntnNarrowbandParams.FadingTechnique = "Sum of
sinusoids";
% Set the below parameters when Environment is set to
Custom
ntnNarrowbandParams.StateDistribution = [3.0639
2.9108; 1.6980 1.2602];
ntnNarrowbandParams.MinStateDuration = [10 6];
ntnNarrowbandParams.DirectPathDistribution = [-1.8225
-15.4844; 1.1317 3.3245];
ntnNarrowbandParams.MultipathPowerCoefficients =
[-0.0481 0.9434; -14.7450 -1.7555];
ntnNarrowbandParams.StandardDeviationCoefficients =
[-0.4643 -0.0798; 0.3334 2.8101];
ntnNarrowbandParams.DirectPathCorrelationDistance =
[1.7910 1.7910];
ntnNarrowbandParams.TransitionLengthCoefficients =
[0.0744; 2.1423];
ntnNarrowbandParams.StateProbabilityRange = [0.05
0.1; 0.95 0.9];
% Setup NTN channel and get channel information
ntnNarrowbandChan =
HelperSetupNTNChannel(ntnNarrowbandParams);
p681ChannelInfo =
info(ntnNarrowbandChan.BaseChannel);
% Estimate Doppler shift
speedOfLight = 3e8; % Speed of light in meters per
second
satelliteRelativeVelocity =
commonParams.SatelliteSpeed -
commonParams.MobileSpeed;
dopplerShift = commonParams.CarrierFrequency *
satelliteRelativeVelocity / speedOfLight;
disp("Estimated Doppler Shift: " + dopplerShift + "
Hz");
% Generate a random input
rng(commonParams.Seed);
in = complex(randn(commonParams.SampleRate,1), ...
randn(commonParams.SampleRate,1));
% Generate the faded waveform for NTN narrowband
channel
[narrowbandOut,~,~] =
HelperGenerateNTNChannel(ntnNarrowbandChan,in);
% Plot the received signal spectrum
ntnNarrowbandAnalyzer = spectrumAnalyzer( ...
SampleRate = ntnNarrowbandParams.SampleRate);
ntnNarrowbandAnalyzer.Title = "Received Signal
Spectrum " ...
+ ntnNarrowbandChan.ChannelName;
ntnNarrowbandAnalyzer.ShowLegend = true;
ntnNarrowbandAnalyzer.ChannelNames = "Rx Antenna 1";
ntnNarrowbandAnalyzer(narrowbandOut);