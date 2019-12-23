function dcm_remove_nondiagnosticdesc(ptrn)

if nargin < 1
    ptrn = '*.dcm';
end

f = dir(ptrn);

if isempty(f)
    return
end

serdesc = dcm_dump('0008','103e', fullfile(f(1).folder,f(1).name));

if ~isempty(serdesc) % sign of ok retrieval by dcm_dump
    serdesc = strrep(serdesc, 'NOT DIAGNOSTIC: ', '');
    dcm_modify('0008','103e', serdesc, ptrn);
end


end
