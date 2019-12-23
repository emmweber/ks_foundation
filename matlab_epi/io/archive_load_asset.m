function useAsset = archive_load_asset(archive)

% Load ASSET Calibration (if it exists)
% Check the exam data path for any ASSET calibration files that were
% included in the archive. If an ASSET calibration file is included in
% the archive then load the calibration here.
examDataDirectory = num2str(archive.DownloadData.rdb_hdr_exam.ex_no);
useAsset = (archive.DownloadData.rdb_hdr_rec.rdb_hdr_asset == 2);


if useAsset
  assetCalibrationFile = [];
  if (exist(num2str(archive.DownloadData.rdb_hdr_exam.ex_no), 'dir'))
    % If the exam data directory exists, check if it contains an ASSET calibration file
    fileList = dir(examDataDirectory);
    for i=1:size(fileList,1)
      findResult = strfind(fileList(i).name, 'Asset');
      if(size(findResult) > 0)
        assetCalibrationFile = fullfile(num2str(archive.DownloadData.rdb_hdr_exam.ex_no), fileList(i).name);
      end
    end
  elseif exist('extra','dir')
    fileList = dir(examDataDirectory);
    for i=1:size(fileList,1)
      findResult = strfind(fileList(i).name, 'Asset');
      if(size(findResult) > 0)
        assetCalibrationFile = fullfile('extra', fileList(i).name);        
      end
    end
  end
  
  if ~isempty(assetCalibrationFile)
    GERecon('Asset.LoadCalibration', assetCalibrationFile);
  end
  
end

end


