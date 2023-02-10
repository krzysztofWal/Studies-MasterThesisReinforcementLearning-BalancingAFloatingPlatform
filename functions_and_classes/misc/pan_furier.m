function [f, amp, n] = pan_furier(sig,fs)
    n = length(sig);
    fur=fft(sig,n);
    amp_=abs(fur);
%     faza=unwrap(angle(fur));
    f=(0:length(fur)-1)'*fs/length(fur);
    amp = 2*amp_/length(fur);
end