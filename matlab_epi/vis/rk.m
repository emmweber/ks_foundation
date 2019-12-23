function varargout = rk(data)

k = render(sumsq(data), [], 'log');
truesize

if nargout
    varargout{1} = k;
end

end
