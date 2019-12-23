function D = recon_epi_readtensordat(ndirs, fname)

if ~exist('ndirs','var')
    ndirs = [];
end
if ~exist('fname','var')
    fname = 'tensor.dat';
end
f = fopen(fname,'r');


while 1
    line = fgetl(f);
    if isnumeric(line) && line(1) == -1
        return;
    end
    if line(1) ~= '#'
        if size(line,2) <= 3 % if line with only one value indicating # diff dirs (preceding every diff scheme)
            numdir = str2num(line);
            d = 1;
            if isempty(ndirs)
                D{numdir} = zeros(numdir,3);
            elseif numdir == ndirs
                D = zeros(numdir,3);
            elseif numdir > ndirs
                if exist('D','var') == 0
                    D = [];
                end
                return
            end
        else
            if nargin == 0
                D{numdir}(d,:) = sscanf(line,'%g %g %g')';
            elseif numdir == ndirs
                D(d,:) = sscanf(line,'%g %g %g')';
            end
            d = d + 1;
        end
    end
end

