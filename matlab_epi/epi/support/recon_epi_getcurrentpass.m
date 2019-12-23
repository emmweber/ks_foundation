function [kspace, rcnhandle, dabPacketIndex, refLines] = recon_epi_getcurrentpass(rcnhandle, dabPacketIndex, acqinvol)

if ~exist('dabPacketIndex','var')
  dabPacketIndex = 1;
end

% speedhack --> have kNx and Nchannels as last dimensions to ensure use of one
% continous memory block
if exist('acqinvol','var')
  kspacesize       = [rcnhandle.nKy, rcnhandle.SlicesPerPass(acqinvol), rcnhandle.nEchoes, rcnhandle.nKx, rcnhandle.nChannels];
else
  kspacesize       = [rcnhandle.nKy, rcnhandle.nChannels, max(rcnhandle.SlicesPerPass(:)), rcnhandle.nEchoes, rcnhandle.nKx, rcnhandle.nChannels];
end
refViewsTop      = rcnhandle.DownloadData.rdb_hdr_rec.rdb_hdr_extra_frames_top;
refViewsBottom   = rcnhandle.DownloadData.rdb_hdr_rec.rdb_hdr_extra_frames_bot;

refLines = [];

if isfield(rcnhandle, 'nRefLines') && rcnhandle.nRefLines >= 1
  if rcnhandle.nRawEchoes ~= (rcnhandle.nEchoes + 1)
    error('recon_epi_getcurrentpass: nRawEchoes ~= nEchoes+1')
  end
end


while dabPacketIndex <= rcnhandle.ControlCount
  
  gotData = false;
  currentControl = GERecon('Archive.Next', rcnhandle); 
  dabPacketIndex = dabPacketIndex + 1;
  kspace = complex(zeros(kspacesize, rcnhandle.data_precision));
  
  if strcmp(currentControl.Type, 'HyperFrameControlPacket')
    % HyperDAB data (product epi.e & epi2.e)
    
    while strcmp(currentControl.Type, 'HyperFrameControlPacket')
      kylines = currentControl.viewNum:currentControl.viewSkip:1;
      rcnhandle.kSpaceDir = currentControl.viewSkip; % pos: TopDown, neg: BottomUp (epi.e/epi2.e default)
      
      kspace(currentControl.viewNum,currentControl.sliceNum+1,currentControl.echoNum+1,:,:) = permute(currentControl.Data,[1 3 2]);
      
      currentControl = GERecon('Archive.Next', rcnhandle); dabPacketIndex = dabPacketIndex + 1;
      
      if strcmp(currentControl.Type, 'UnlockPacket')
        % Integrated Refscan has one UnlockPacket between each HyperFrameControlPacket
        currentControl = GERecon('Archive.Next', rcnhandle); dabPacketIndex = dabPacketIndex + 1;
      end
    end
    
    gotData = true;
    
  elseif strcmp(currentControl.Type, 'ProgrammableControlPacket')
    % Normal DAB data (ksepi.e)
    
    firstViewNum = currentControl.viewNum;
         
    while strcmp(currentControl.Type, 'ProgrammableControlPacket')
      
      if currentControl.sliceNum < kspacesize(2) % sliceNum 0-based
        if (currentControl.echoNum+1) <= rcnhandle.nEchoes % echoNum 0-based
          kspace(currentControl.viewNum,currentControl.sliceNum+1,currentControl.echoNum+1,:,:) = currentControl.Data;
          rcnhandle.kSpaceDir = (currentControl.viewNum - firstViewNum); % pos: TopDown, neg: BottomUp (ksepi.e default)
        elseif isfield(rcnhandle, 'nRefLines') && rcnhandle.nRefLines >= 1 && (currentControl.echoNum+1) == rcnhandle.nRawEchoes % echoNum 0-based
          if any(currentControl.Data(:))
            % phase reference lines
            shot = mod(currentControl.viewNum - 1, rcnhandle.nShots) + 1;
            line = idivide(int16(currentControl.viewNum - shot), int16(rcnhandle.nShots)) + 1;
            refLines(:,line,:,currentControl.sliceNum+1,1,shot) = currentControl.Data;
          end
        else
          error('recon_epi_getcurrentpass: Don''t know what to do with extra raw Echoes');
        end
      end
      
      currentControl = GERecon('Archive.Next', rcnhandle); 
      dabPacketIndex = dabPacketIndex + 1;
    end
    
    gotData = true;
    
  end
  
  % we permute back to a more natural order (which is also required by the
  % subsequent functions
  kspace = permute(kspace, [4 1 5 2 3]);
  
  if (gotData == true)
    
    if isEndofPass(currentControl) || isEndofScan(currentControl)
      
      if refViewsTop > 0
        rcnhandle.refViewsTopData = kspace(:,1:refViewsTop,:,:,:);
      end
      if refViewsBottom > 0
        rcnhandle.refViewsBottomData = kspace(:,(rcnhandle.nKy-refViewsBottom+1):rcnhandle.nKy,:,:,:);
      end
      if refViewsTop > 0 || refViewsBottom > 0
        kspace = kspace(:,(refViewsTop+1):(rcnhandle.nKy-refViewsBottom),:,:,:);
      end
      
      rcnhandle.kSpaceDir = rcnhandle.kSpaceDir / abs(rcnhandle.kSpaceDir);
      
      if isfield(rcnhandle,'rowFlipHandle')
        if ~isempty(rcnhandle.rowFlipHandle)
          for z = 1:size(kspace,4)
            for echo = 1:rcnhandle.nEchoes
              % Apply rowflip
              for channel=1:rcnhandle.nChannels
                kspace(:,:,channel,z,echo) = GERecon('Epi.ApplyImageRowFlip', rcnhandle.rowFlipHandle, kspace(:,:,channel,z,echo));
              end
            end
          end
        else
          rows2flip = recon_epi_rowstoflip(size(kspace), rcnhandle.nShots, rcnhandle.kSpaceDir); % which rows to flip
          kspace(:,rows2flip,:,:,:) = flip(kspace(:,rows2flip,:,:,:), 1);
          if ~isempty(refLines)
            rows2flip = recon_epi_rowstoflip(size(refLines), 1, rcnhandle.kSpaceDir); % which refLine rows to flip
            refLines(:,rows2flip,:,:,:,:) = flip(refLines(:,rows2flip,:,:,:,:), 1);
          end
        end
      end
      
      if ~isempty(refLines)
        % crop empty refLines
        refLines = refLines(:,size(refLines,2)-rcnhandle.nRefLines+1:size(refLines,2),:,:,:,:);
      end
      
      return;
      
    else
      
      warning('recon_epi_getcurrentpass: Expected ScanControlPacket with .isAcqDone = 1 or .isScanDone = 1 after data control packets in pass');
      
    end
    
  end
  
end

if (gotData == false)
  kspace = [];
end

end

function status = isEndofPass(currentControl)
status = strcmp(currentControl.Type, 'ScanControlPacket') && (isfield(currentControl, 'isAcqDone') && currentControl.isAcqDone);
end


function status = isEndofScan(currentControl)
status = strcmp(currentControl.Type, 'ScanControlPacket') && (isfield(currentControl, 'isScanDone') && currentControl.isScanDone);
end

