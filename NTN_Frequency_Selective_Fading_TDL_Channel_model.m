clear all
commonParams = struct;
commonParams.CarrierFrequency = 2e9;
commonParams.ElevationAngle = 50;
commonParams.SatelliteAltitude = 600000;
commonParams.SatelliteSpeed = 7562.2;
commonParams.MobileSpeed = 3 * 1000 / 3600;
commonParams.SampleRate = 15000000;
commonParams.RandomStream = "mt19937ar with seed";
commonParams.Seed = 73;
commonParams.NumSinusoids = 48;
ntnTDLParams = commonParams;
ntnTDLParams.NTNChannelType = "TDL";
ntnTDLParams.DelayProfile = "NTN-TDL-A";
ntnTDLParams.DelaySpread = 30e-9;
ntnTDLParams.TransmissionDirection = "Downlink";
ntnTDLParams.MIMOCorrelation = "Low";
ntnTDLParams.Polarization = "Co-Polar";
ntnTDLParams.NumTransmitAntennas = 1;
ntnTDLParams.NumReceiveAntennas = 2;
ntnTDLParams.TransmitCorrelationMatrix = 1;
ntnTDLParams.ReceiveCorrelationMatrix = [1 0; 0 1];
ntnTDLParams.TransmitPolarizationAngles = [45 -45];
ntnTDLParams.ReceivePolarizationAngles = [90 0];
ntnTDLParams.XPR = 10;
ntnTDLParams.SpatialCorrelationMatrix = [1 0; 0 1];
ntnTDLChan = HelperSetupNTNChannel(ntnTDLParams);
tdlChanInfo = info(ntnTDLChan.BaseChannel);
disp(tdlChanInfo);
speedOfLight = 3e8;
satelliteRelativeVelocity =
commonParams.SatelliteSpeed -
commonParams.MobileSpeed;
dopplerShift = commonParams.CarrierFrequency *
satelliteRelativeVelocity / speedOfLight;
disp("Estimated Doppler Shift: " + dopplerShift + "
Hz");
rng(commonParams.Seed);
in = complex(randn(commonParams.SampleRate,
tdlChanInfo.NumTransmitAntennas), ...
randn(commonParams.SampleRate,
tdlChanInfo.NumTransmitAntennas));
[tdlOut, tdlPathGains, tdlSampleTimes] =
HelperGenerateNTNChannel(ntnTDLChan, in);
% Plot the channel impulse response manually
figure;
for nRx = 1:ntnTDLParams.NumReceiveAntennas
for nTx = 1:ntnTDLParams.NumTransmitAntennas
subplot(ntnTDLParams.NumReceiveAntennas,
ntnTDLParams.NumTransmitAntennas,
(nRx-1)*ntnTDLParams.NumTransmitAntennas + nTx);
plot(tdlSampleTimes, squeeze(tdlPathGains(:, nRx,
nTx)));
title(['Channel Impulse Response - Rx ' num2str(nRx)
', Tx ' num2str(nTx)]);
xlabel('Time (s)');
ylabel('Amplitude');
end
end
% Plot the received signal spectrum
ntnTDLAnalyzer = spectrumAnalyzer(SampleRate =
ntnTDLParams.SampleRate);
ntnTDLAnalyzer.Title = "Received Signal Spectrum " +
ntnTDLChan.ChannelName;
ntnTDLAnalyzer.ShowLegend = true;
for nRx = 1:size(tdlOut,2)
ntnTDLAnalyzer.ChannelNames{nRx} = "Rx Antenna " +
nRx;
end
ntnTDLAnalyzer(tdlOut);