function p = check_defaults(defaults, p, rule)
% Syntax: p = check_defaults(defaults, p)

if isempty(defaults)
    defaults = struct('empty', '');
end

% Check & use available flags from input 'p'
if nargin < 2 || isempty(p)
    p = defaults;
else
    if nargin >= 3 && strcmp(rule,'strict')
        % Don't allow field in p that does not exist in defaults
        fina = fieldnames(p);
        for i=1:length(fina)
            if ~isfield(defaults,fina{i})
                disp('error in p struct');
                error('check_defaults: Invalid field %s in p-struct on input',fina{i});
            end
        end
    end
    
    % If fields exist in defaults but not in p, add them to p
    fina = fieldnames(defaults);
    for i=1:length(fina)
        if ~isfield(p,fina{i}) || isempty(p.(fina{i}))
            p.(fina{i}) = defaults.(fina{i});
        end
    end
end
