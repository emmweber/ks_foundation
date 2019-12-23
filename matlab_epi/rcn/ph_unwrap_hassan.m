function uw_phase = ph_unwrap_hassan(phasemap)
    % The credit goes to Hassan (cc). His paper can be found at:
    % A modified Fourier-based phase unwrapping algorithm with an application to MRI venography.
    % Journal of Magnetic Resonance Imaging, Volume 27 Issue 3, Pages 649 - 652
    %
    % One thing about this method is that it's not accurate on the edges of the
    % image which is noise in most MRI cases and we don't care about it.
    % ------------------------------------------------------------------------------------------------
    % Modified by Stefan Skare. Dept Neuroradiology, Karolinska University Hospital. 2012-02-02
    
    isz = size(phasemap); isz(end+1:3) = 1;
    
    % Create a parabola to be used in k-space
    pq = ([1:isz(1)/2]' * ones(1,isz(2)/2)).^2 + (ones(isz(1)/2,1) * [1:isz(2)/2]).^2;
    p2q2 = repmat(fftshift([pq(end:-1:1,end:-1:1) pq(end:-1:1,:) ;pq(:,end:-1:1) pq]), [1 1 isz(3:end)]);
    
    % Unwrap the phase using those Laplacians (see paper)
    if isreal(phasemap) % I/O: Phasemap -> Unwrapped Phasemap
        tmp =                 ifft2(fft2(cos(phasemap) .* ifft2(p2q2.*fft2(sin(phasemap)))) ./ p2q2);
        uw_phase = real(tmp - ifft2(fft2(sin(phasemap) .* ifft2(p2q2.*fft2(cos(phasemap)))) ./ p2q2));
    else % I/O: Complex data -> Unwrapped Phasemap
        phasemap = phasemap ./ abs(phasemap+eps);
        tmp =                 ifft2(fft2(real(phasemap) .* ifft2(p2q2.*fft2(imag(phasemap)))) ./ p2q2);
        uw_phase = real(tmp - ifft2(fft2(imag(phasemap) .* ifft2(p2q2.*fft2(real(phasemap)))) ./ p2q2));        
    end
end


