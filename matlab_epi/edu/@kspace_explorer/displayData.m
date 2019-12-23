function displayData(app)

displayKspaceData(app);
displayImageData(app);

I = app.imageData;
k = app.kspaceData;
save ~/Desktop/tmp I k


app.ScanTimeLabel.Text = sprintf('Scan Time [%%]:  %3d', app.phaseEncodingPercentage);

FOVy = app.FOVySlider.Value/100;
FOVx = app.FOVxSlider.Value/100;
baseSNR = 100 * sqrt(prod(app.fullDataSize(1:2)));

if isempty(app.kspaceSizePreZfill)
  app.kspaceSizePreZfill = size(app.kspaceData(:,:,1));
end

% SNR = round(baseSNR * FOVx * FOVy / sqrt(numel(app.kspaceData(:,:,1))) / sqrt(app.effR));
SNR = round(baseSNR * FOVx * FOVy / sqrt(prod(app.kspaceSizePreZfill)) / sqrt(app.effR));
app.RelativeSNRLabel.Text = sprintf('Relative SNR [%%]: %d', SNR);

app.SNRefficiencyLabel.Text = sprintf('SNR efficiency [%%]: %d', round(SNR/sqrt(app.phaseEncodingPercentage/100)));


if ~isempty(app.acqMatrix)
  asz = app.acqMatrix;
  rsz = size(app.imageData);
  app.acqMatrixSizeLabel.Text = sprintf('Acq. matrix: %dx%d', asz(1),asz(2));
  app.recMatrixSizeLabel.Text = sprintf('Rec. matrix: %dx%d', rsz(1),rsz(2));
end

end