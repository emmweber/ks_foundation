function archive_show(varargin)

archive = archive_load(varargin);

outputfile = strrep(archive.h5file,'h5','txt');
if exist(outputfile, 'file')
    delete(outputfile);
end
diary(outputfile);

fprintf('%s: e%05d s%03d (%s)\n', archive.h5file, archive.ExamNumber, archive.SeriesNumber, archive.DownloadData.rdb_hdr_exam.ex_sysid);
fprintf('Patient name: %s\n', strrep(archive.DownloadData.rdb_hdr_exam.patnameff,'^', ' '));
fprintf('Patient ID:   %s\n', archive.DownloadData.rdb_hdr_exam.patidff);
fprintf('Date/Time:    %s\n', archive.DateTime);
fprintf('PSD:          %s\n', archive.DownloadData.rdb_hdr_image.psdname);

fprintf('\n\n');

pass = 1;

for j = 1:archive.ControlCount
    currentControl = GERecon('Archive.Next', archive);
    
    fprintf('pass %03d - ', pass);
    
    if strcmp(currentControl.Type, 'HyperFrameControlPacket')
        fprintf('%05d: %02d %s e%03d s%03d v%03d:%02d:%02d [', j, currentControl.opcode, currentControl.Type, currentControl.echoNum+1, currentControl.sliceNum+1, currentControl.viewNum, currentControl.viewSkip, currentControl.viewNum + currentControl.viewSkip * (currentControl.numViews-1));
        sz = size(currentControl.Data);
        for s = 1:numel(sz)
            fprintf('%d', sz(s)); if s < numel(sz), fprintf('x'); end
        end
        fprintf(']\n');
    else
        if currentControl.opcode ~= 0 &&  currentControl.opcode ~= 5
            fprintf('%05d: %02d %s - e%03d s%03d v%03d ', j, currentControl.opcode, currentControl.Type, currentControl.echoNum+1, currentControl.sliceNum+1, currentControl.viewNum);
            if isfield(currentControl,'echoTrainIndex')
                fprintf('et%02d ', currentControl.echoTrainIndex+1);
            end
            fprintf('[');
            sz = size(currentControl.Data);            
            for s = 1:numel(sz)
                fprintf('%d', sz(s)); if s < numel(sz), fprintf('x'); end
            end
            fprintf(']\n');
        elseif currentControl.opcode == 0
            fprintf('%05d: %02d %s ', j, currentControl.opcode, currentControl.Type);
            if currentControl.isAcqDone
                fprintf('Pass Done ');
                pass = pass + 1;
            end
            if currentControl.isScanDone
                fprintf('Scan Done ');
            end
            if currentControl.isAcqDone || currentControl.isScanDone
                fprintf('\n%s\n', repmat('-',1,100));
            end
        else
            fprintf('%05d: %02d %s\n', j, currentControl.opcode, currentControl.Type);
        end
    end
end

GERecon('Archive.Close', archive);

diary off

end
