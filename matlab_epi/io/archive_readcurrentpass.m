function [kspace, rcnhandle] = archive_readcurrentpass(rcnhandle, acqinvol)

if exist('acqinvol','var')
  kspacesize       = [rcnhandle.nKx, rcnhandle.nKy, rcnhandle.nChannels, rcnhandle.SlicesPerPass(acqinvol), rcnhandle.nEchoes];
else
  kspacesize       = [rcnhandle.nKx, rcnhandle.nKy, rcnhandle.nChannels, max(rcnhandle.SlicesPerPass(:)), rcnhandle.nEchoes];
end

kspace = zeros(kspacesize, rcnhandle.data_precision);

for j = 1:rcnhandle.ControlCount
  
  currentControl = GERecon('Archive.Next', rcnhandle);
  
  if currentControl.opcode == 1 && strcmp(currentControl.Type, 'ProgrammableControlPacket') && currentControl.viewNum > 0 && currentControl.viewNum <= rcnhandle.nKy && currentControl.sliceNum < kspacesize(4)    
    kspace(:,currentControl.viewNum,:,currentControl.sliceNum+1,currentControl.echoNum+1) = currentControl.Data;
  elseif isEndofPass(currentControl) || isEndofScan(currentControl)      
      return;      
  end
  
end

end


function status = isEndofPass(currentControl)
status = currentControl.opcode == 0 || (strcmp(currentControl.Type, 'ScanControlPacket') && (isfield(currentControl, 'isAcqDone') && currentControl.isAcqDone));
end


function status = isEndofScan(currentControl)
status = strcmp(currentControl.Type, 'ScanControlPacket') && (isfield(currentControl, 'isScanDone') && currentControl.isScanDone);
end

