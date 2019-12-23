function fov = moco_fov(rcnhandle)

fov = [rcnhandle_getfield(rcnhandle,'image','dfov_rect') ...
       rcnhandle_getfield(rcnhandle,'image','dfov') ...
       (rcnhandle_getfield(rcnhandle,'image','slthick') + rcnhandle_getfield(rcnhandle,'image','scanspacing')) * rcnhandle_getfield(rcnhandle,'image','slquant')];

end